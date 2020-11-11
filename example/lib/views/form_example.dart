import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class ResourceOwner<T> {
  int id;
}

class User {
  int id;
  String name;
}

class Assignment {
  int id;
  String name;
  ResourceOwner<User> assignedTo;
}

class FormExample extends StatefulWidget {
  @override
  _FormExampleState createState() => _FormExampleState();
}

class _FormExampleState extends State<FormExample> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _userController = TextEditingController();

  void _validate() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Assignment Created')));
    }
  }

  List<User> _users = [
    User()
      ..name = "John Doe"
      ..id = 1,
    User()
      ..name = "Jane Doe"
      ..id = 2,
    User()
      ..name = "Your Boss"
      ..id = 3,
  ];
  List<Assignment> _assignments = [];

  void _showUsersDialog() {
    showDialog(context: context, child: _Dialog(users: _users));
  }

  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      Iterable<Widget> _actions() sync* {
        yield Tooltip(
          message: 'Validate',
          child: IconButton(
            onPressed: _validate,
            icon: Icon(Icons.done),
          ),
        );

        yield Tooltip(
          message: 'Add a User',
          child: IconButton(
            onPressed: _showUsersDialog,
            icon: Icon(Icons.person_add_sharp),
          ),
        );
      }

      return AppBar(
        title: Text('Form Example'),
        actions: _actions().toList(),
      );
    }

    Widget _body() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              validator: (s) {
                if (s.isEmpty) return 'Name cannot be empty';

                return null;
              },
              decoration: InputDecoration(
                labelText: "Name",
              ),
            ),
            SizedBox(height: 16),
            AutoCompleteTextFormField<User>(
              controller: _userController,
              textFieldConfig: TextFieldConfiguration(decoration: InputDecoration(labelText: "Assigned To: ")),
              config: AutoCompleteConfiguration(preferAbove: false),
              validator: (s) {
                if (!_users.any((x) => s == x.name)) return 'User does not exist';

                return null;
              },
              onItemSelected: (user) {
                return user.name;
              },
              duration: const Duration(milliseconds: 300),
              itemBuilder: (context, term) {
                return (_users.where((x) => x.name.toLowerCase().startsWith(term.toLowerCase())).toList()
                      ..sort((a, b) => a.name.compareTo(b.name)))
                    .take(5)
                    .map(_mapToEntry)
                    .toList();
              },
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: RaisedButton(
                        child: Text('Create'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            final previousId = _assignments.isNotEmpty ? _assignments.last.id + 1 : 1;
                            final assign = Assignment()
                              ..id = previousId
                              ..name = _nameController.text
                              ..assignedTo = (ResourceOwner<User>()
                                ..id = _users.firstWhere((x) => x.name == _userController.text).id);

                            setState(() {
                              _assignments.add(assign);
                              _nameController.clear();
                              _userController.clear();
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: _assignments
                            .map((x) => ListTile(
                                  leading: Icon(Icons.assignment),
                                  trailing: Text('ID: ${x.id}'),
                                  title: Text(x.name),
                                  subtitle:
                                      Text("Assigned To: " + _users.firstWhere((u) => u.id == x.assignedTo.id).name),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: _appBar(),
        body: _body(),
      ),
    );
  }

  AutoCompleteEntry<User> _mapToEntry(User user) {
    return AutoCompleteEntry(
      value: user,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(user.name),
        subtitle: Text('User ID: ${user.id}'),
      ),
    );
  }
}

class _Dialog extends StatefulWidget {
  final List<User> users;

  const _Dialog({Key key, this.users}) : super(key: key);

  @override
  __DialogState createState() => __DialogState();
}

class __DialogState extends State<_Dialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isFirstPage = true;

  @override
  Widget build(BuildContext context) {
    Widget _content() {
      if (_isFirstPage) {
        return SingleChildScrollView(
          child: ListBody(
            children: widget.users
                .map(
                  (user) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Material(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        title: Text(user.name),
                        subtitle: Text("User ID: ${user.id}"),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => setState(() => widget.users.remove(user)),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      } else {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ListBody(
              children: [
                TextFormField(
                  controller: _controller,
                  validator: (s) => s.isEmpty ? 'Please enter a valid value' : null,
                  decoration: InputDecoration(hintText: 'Add a username'),
                ),
              ],
            ),
          ),
        );
      }
    }

    Iterable<Widget> _actions() sync* {
      yield FlatButton(
        child: Text(_isFirstPage ? 'Add a User' : 'See users'),
        onPressed: () => setState(() => _isFirstPage = !_isFirstPage),
      );

      yield FlatButton(
        child: Text('Done'),
        onPressed: _isFirstPage
            ? () {
                Navigator.pop(context);
              }
            : () {
                if (_formKey.currentState.validate()) {
                  widget.users.add(User()
                    ..name = _controller.text
                    ..id = widget.users.last.id + 1);
                  Navigator.pop(context);
                }
              },
      );
    }

    return AlertDialog(
      title: Text('Edit Users'),
      content: _content(),
      actions: _actions().toList(),
    );
  }
}
