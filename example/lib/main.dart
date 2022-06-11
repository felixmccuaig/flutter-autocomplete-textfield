import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Complete TextField Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [FirstPage(), SecondPage()];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Center(child: Text("1")),
            label: "Simple Use",
          ),
          BottomNavigationBarItem(
              icon: Center(child: Text("2")),
              label: "Complex Use"
          ),
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
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  _FirstPageState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: InputDecoration(errorText: "Beans"),
      controller: TextEditingController(text: "Starting Text"),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
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

  SimpleAutoCompleteTextField? textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = Column(children: [
      ListTile(
          title: textField,
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                textField!.triggerSubmitted();
                showWhichErrorText = !showWhichErrorText;
                textField!.updateDecoration(
                    decoration: InputDecoration(
                        errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return ListTile(title: Text(item));
    }));

    return Scaffold(
      appBar:
          AppBar(title: Text('AutoComplete TextField Demo Simple'), actions: [
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => showDialog(
                builder: (_) {
                  String text = "";

                  return AlertDialog(
                      title: Text("Change Suggestions"),
                      content: TextField(onChanged: (text) => text = text),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (text != "") {
                                suggestions.add(text);
                                textField!.updateSuggestions(suggestions);
                              }
                              Navigator.pop(context);
                            },
                            child: Text("Add")),
                      ]);
                },
                context: context))
      ]),
      body: body,
    );
  }
}

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  num stars;
  String name, imgURL;

  ArbitrarySuggestionType(this.stars, this.name, this.imgURL);
}

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<ArbitrarySuggestionType> suggestions = [
    ArbitrarySuggestionType(4.7, "Minamishima",
        "https://media-cdn.tripadvisor.com/media/photo-p/0f/25/de/0c/photo1jpg.jpg"),
    ArbitrarySuggestionType(1.5, "The Meat & Wine Co Hawthorn East",
        "https://media-cdn.tripadvisor.com/media/photo-s/12/ba/7d/4c/confit-cod-chorizo-red.jpg"),
    ArbitrarySuggestionType(3.4, "Florentino",
        "https://media-cdn.tripadvisor.com/media/photo-s/12/fc/bb/11/from-the-street.jpg"),
    ArbitrarySuggestionType(4.3, "Syracuse Restaurant & Winebar Melbourne CBD",
        "https://media-cdn.tripadvisor.com/media/photo-p/07/ad/76/b0/the-gyoza-had-a-nice.jpg"),
    ArbitrarySuggestionType(1.1, "Geppetto Trattoria",
        "https://media-cdn.tripadvisor.com/media/photo-s/0c/85/3d/cb/photo1jpg.jpg"),
    ArbitrarySuggestionType(3.4, "Cumulus Inc.",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/21/a0/be/photo0jpg.jpg"),
    ArbitrarySuggestionType(2.2, "Chin Chin",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/83/ec/07/triple-beef-triple-bacon.jpg"),
    ArbitrarySuggestionType(5.0, "Anchovy",
        "https://media-cdn.tripadvisor.com/media/photo-s/07/e7/f6/8e/daneli-s-kosher-deli.jpg"),
    ArbitrarySuggestionType(4.7, "Sezar Restaurant",
        "https://media-cdn.tripadvisor.com/media/photo-s/04/b8/23/d1/nevsky-russian-restaurant.jpg"),
    ArbitrarySuggestionType(2.6, "Tipo 00",
        "https://media-cdn.tripadvisor.com/media/photo-s/11/17/67/8c/front-seats.jpg"),
    ArbitrarySuggestionType(3.4, "Coda",
        "https://media-cdn.tripadvisor.com/media/photo-s/0d/b1/6a/84/photo0jpg.jpg"),
    ArbitrarySuggestionType(1.1, "Pastuso",
        "https://media-cdn.tripadvisor.com/media/photo-w/0a/d9/cf/52/photo4jpg.jpg"),
    ArbitrarySuggestionType(0.2, "San Telmo",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/51/35/35/tempura-sashimi-combo.jpg"),
    ArbitrarySuggestionType(3.6, "Supernormal",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/bc/63/69/mr-miyagi.jpg"),
    ArbitrarySuggestionType(4.4, "EZARD",
        "https://media-cdn.tripadvisor.com/media/photo-p/09/f2/83/15/photo0jpg.jpg"),
    ArbitrarySuggestionType(2.1, "Maha",
        "https://media-cdn.tripadvisor.com/media/photo-s/10/f8/9e/af/20171013-205729-largejpg.jpg"),
    ArbitrarySuggestionType(4.2, "MoVida",
        "https://media-cdn.tripadvisor.com/media/photo-s/0e/1f/55/79/and-here-we-go.jpg")
  ];

  GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>> key =
      GlobalKey<AutoCompleteTextFieldState<ArbitrarySuggestionType>>();

  AutoCompleteTextField<ArbitrarySuggestionType>? textField;

  ArbitrarySuggestionType? selected;

  _SecondPageState() {
    textField = AutoCompleteTextField<ArbitrarySuggestionType>(
      decoration: InputDecoration(
          hintText: "Search Resturant:", suffixIcon: Icon(Icons.search)),
      itemSubmitted: (item) => setState(() => selected = item),
      key: key,
      suggestions: suggestions,
      itemBuilder: (context, suggestion) => Padding(
          child: ListTile(
              title: Text(suggestion.name),
              trailing: Text("Stars: ${suggestion.stars}")),
          padding: EdgeInsets.all(8.0)),
      itemSorter: (a, b) => a.stars == b.stars
          ? 0
          : a.stars > b.stars
              ? -1
              : 1,
      itemFilter: (suggestion, input) =>
          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AutoComplete TextField Demo Complex'),
      ),
      body: Column(children: [
        Padding(
            child: Container(child: textField), padding: EdgeInsets.all(16.0)),
        Padding(
            padding: EdgeInsets.fromLTRB(0.0, 64.0, 0.0, 0.0),
            child: Card(
                child: selected != null
                    ? Column(children: [
                        ListTile(
                            title: Text(selected!.name),
                            trailing: Text("Rating: ${selected!.stars}/5")),
                        Container(
                            child: Image(image: NetworkImage(selected!.imgURL)),
                            width: 400.0,
                            height: 300.0)
                      ])
                    : Icon(Icons.cancel))),
      ]),
    );
  }
}
