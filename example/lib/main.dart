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
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [new FirstPage(), new SecondPage()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Center(child: new Text("1")),
              title: new Text("Simple Use")),
          new BottomNavigationBarItem(
              icon: new Center(child: new Text("2")),
              title: new Text("Complex Use")),
        ],
        onTap: (index) => setState(() {
              selectedIndex = index;
            }),
        currentIndex: selectedIndex,
      ),
      body: pages[selectedIndex],
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      textSubmitted: (text) => setState(() {
            added.add(text);
          }),
    );
  }

  List<String> suggestions = [
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
  ];

  SimpleAutoCompleteTextField textField;

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                setState(() {
                  if (currentText != "") {
                    added.add(currentText);
                    textField.clear();
                    currentText = "";
                  }
                });
              }))
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return new Scaffold(
        appBar: new AppBar(
            title: new Text('AutoComplete TextField Demo Simple'),
            actions: [
              new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () => showDialog(
                      builder: (_) {
                        String text = "";

                        return new AlertDialog(
                            title: new Text("Change Suggestions"),
                            content: new TextField(
                                onChanged: (newText) => text = newText),
                            actions: [
                              new FlatButton(
                                  onPressed: () {
                                    if (text != "") {
                                      suggestions.add(text);
                                      textField.updateSuggestions(suggestions);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: new Text("Add")),
                            ]);
                      },
                      context: context))
            ]),
        body: body);
  }
}

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  int id;
  num stars;
  String name;

  ArbitrarySuggestionType(this.id, this.stars, this.name);
}

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<ArbitrarySuggestionType> suggestions = [
    new ArbitrarySuggestionType(0, 3.4, "Green Eggs And Ham"),
    new ArbitrarySuggestionType(1, 1.2, "Skinny Dog Hotel"),
    new ArbitrarySuggestionType(2, 4.3, "Local Cafe"),
    new ArbitrarySuggestionType(3, 2.5, "Pie Man"),
    new ArbitrarySuggestionType(4, 5, "Dumpling parlour"),
    new ArbitrarySuggestionType(5, 4, "Great Scott!"),
    new ArbitrarySuggestionType(6, 1.2, "Laurant Cafe")
  ];

  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();

  AutoCompleteTextField<ArbitrarySuggestionType> textField;

  ArbitrarySuggestionType selected;

  _SecondPageState() {
    textField = new AutoCompleteTextField<ArbitrarySuggestionType>(
      itemSubmitted: (item) => setState(() => selected = item),
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => new Padding(
          child: new ListTile(
              title: new Text(suggestion.name),
              trailing: new Text("Stars: ${suggestion.stars}")),
          padding: EdgeInsets.all(8.0)),
      itemSorter: (a, b) => a.stars == b.stars ? 0 : a.stars > b.stars ? -1 : 1,
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('AutoComplete TextField Demo Complex'),
      ),
      body: new Column(children: [
        new Padding(child: textField, padding: EdgeInsets.all(16.0)),
        new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
            child: new Card(
                child: selected != null
                    ? new ListTile(
                        title: new Text(selected.name),
                        trailing: new Text("Rating: ${selected.stars}/5"))
                    : new Icon(Icons.cancel))),
      ]),
    );
  }
}
