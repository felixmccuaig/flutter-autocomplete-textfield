import 'package:example/views/complex_example.dart';
import 'package:example/views/form_example.dart';
import 'package:example/views/simple_example.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: _Body(),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  int _index = 0;

  final List<Widget> _children = [
    SimpleExample(),
    ComplexExample(),
    FormExample(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _children[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Text('1'), label: "Simple Example"),
          BottomNavigationBarItem(icon: Text('2'), label: "Complex Example"),
          BottomNavigationBarItem(icon: Text('3'), label: "Form Example"),
        ],
        onTap: (i) => setState(() => _index = i),
        currentIndex: _index,
      ),
    );
  }
}
