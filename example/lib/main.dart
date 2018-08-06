import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Auto Complete TextField Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    var textField = new AutoCompleteTextField<String>(
        decoration: new InputDecoration(
            hintText: "Search Item",
            border: new OutlineInputBorder(
                gapPadding: 0.0, borderRadius: new BorderRadius.circular(16.0)),
            suffixIcon: new Icon(Icons.search)),
        key: key,
        suggestions: [
          "Apple",
          "Armidillo",
          "Actual",
          "Actuary",
          "America",
          "Argentina",
          "Australia",
          "Antarctica",
          "Blueberry",
          "Cheese",
          "Danish",
          "Eclair",
          "Fudge",
          "Granola",
          "Hazelnut",
          "Ice Cream",
          "Jely",
          "Kiwi Fruit",
          "Lamb",
          "Macadamia",
          "Nachos",
          "Oatmeal",
          "Palm Oil",
          "Quail",
          "Rabbit",
          "Salad",
          "T-Bone Steak",
          "Urid Dal",
          "Vanilla",
          "Waffles",
          "Yam",
          "Zest"
        ],
        textChanged: (item) {
          currentText = item;
        },
        itemBuilder: (context, item) {
          return new Padding(
              padding: EdgeInsets.all(8.0), child: new Text(item));
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        itemFilter: (item, query) {
          return item.toLowerCase().startsWith(query.toLowerCase());
        });

    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  added.add(currentText);
                  textField.clear();
                });
              }))
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return new Scaffold(
        appBar: new AppBar(title: new Text('Auto Complete TextField Demo')),
        body: body);
  }
}
