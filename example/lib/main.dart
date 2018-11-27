import 'package:example/widgets/pages.dart';
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
