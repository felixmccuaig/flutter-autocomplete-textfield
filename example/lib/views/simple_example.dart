import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:english_words/english_words.dart' as english_words;
import 'package:flutter/material.dart';

class SimpleExample extends StatefulWidget {
  SimpleExample({Key key}) : super(key: key);

  @override
  _SimpleExampleState createState() => _SimpleExampleState();
}

class _SimpleExampleState extends State<SimpleExample> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _node = FocusNode();

  List<String> _added = [];

  Set<String> get words => [
        ...english_words.all,
        ..._added,
      ].toSet();

  void _addCurrentValue([String value]) => setState(() {
        final _val = value ?? _controller.text;
        if (_added.indexOf(_val) < 0 && english_words.all.indexOf(_val) < 0) {
          return _added.add(_val);
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Item is already added')));
        }
      });

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> _children() sync* {
      yield ListTile(
        trailing: IconButton(
          onPressed: _addCurrentValue,
          icon: Icon(Icons.add),
        ),
        title: SimpleAutoCompleteTextField(
          controller: _controller,
          focusNode: _node,
          textFieldConfig: TextFieldConfiguration(
            decoration: InputDecoration(border: OutlineInputBorder()),
            onSubmitted: _addCurrentValue,
          ),
          config: AutoCompleteConfiguration(preferAbove: true),
          onItemSelected: (x) {
            if (x == null) {
              return null;
            }
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(x)));
            return x;
          },
          suggestionLimit: 10,
          itemFilter: (a, q) => a.toLowerCase().startsWith(q.toLowerCase()),
          suggestions: words.toList(),
          duration: const Duration(milliseconds: 300),
        ),
      );

      yield Divider();

      for (final addition in _added) {
        yield Dismissible(
          key: Key(addition),
          direction: DismissDirection.endToStart,
          onDismissed: (dir) {
            if (dir != DismissDirection.endToStart) return;

            setState(() => _added.remove(addition));
          },
          background: Container(color: Colors.red),
          child: ListTile(
            title: Text(addition),
            trailing: IconButton(
              onPressed: () {
                setState(() => _added.remove(addition));
              },
              icon: Icon(Icons.remove),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Simple Example')),
      body: ListView(
        children: _children().toList(),
      ),
    );
  }
}
