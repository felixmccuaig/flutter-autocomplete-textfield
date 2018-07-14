import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

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
  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
        title: new AutoCompleteTextField<String>(
            suggestions: [
              "Apple",
              "Blueberry",
              "Cheese",
              "Danish",
              "Eclair",
              "Fudge",
              "Granola"
            ],
            textChanged: (item) {

            },
            itemBuilder: (context, item) {
              return new Padding(
                  padding: EdgeInsets.all(8.0),
                  child: new Text(item)
              );
            },
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            itemFilter: (item, query) {
              return item.toLowerCase().startsWith(query.toLowerCase());
            }),
        trailing: new IconButton(icon: new Icon(Icons.add), onPressed: () {

        })

      )
    ]);

    return new Scaffold(
        appBar: new AppBar(title: new Text('Auto Complete TextField Demo')),
        body: body);
  }
}
