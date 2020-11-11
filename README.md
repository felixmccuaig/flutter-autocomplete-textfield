# autocomplete_textfield
An Auto-Complete Text-Field for flutter

#### Pull Requests
Feel free to submit pull requests for desired changes / features / bug fixes... It makes the maintenance of this code much easier as I no longer use Flutter frequently. 

 ## Breaking Changes from Version 1.x.x to 2.x.x

 * All [TextField](https://api.flutter.dev/flutter/material/TextField-class.html) parameters except `TextEditingController controller` and `FocusNode focusNode` have been moved to a `TextFieldConfiguration` class
    * `textChanged` moved and renamed to `onChanged` to reflect flutter's implementation
    * `textSubmitted` moved and renamed  to `onSubmitted` to reflect flutter's implementation
    
 * Removed `submitOnSuggestions`
 * Moved several configuration options to `AutoCompleteConfiguration` 
    * Renamed `clearOnSubmit` to `clearOnSelected`
    
 * Removed `bool Function<T>(T value) itemFilter`, should be incorporated into `itemBuilder`
 * Removed `int Function<T>(T a, T b) itemSorter`, should be incorporated into `itemBuilder`
 * Removed `int suggestionsAmount`, this should be incorporated into `itemBuilder`
 * Removed `ValueSetter<bool> onFocusChanged` as this can be achieved by adding a listener to a provided `FocusNode`
 
 * Renamed `itemSubmitted` to `onItemSelected` to reflect Dart's naming conventions
 
# Features
* Supports asynchronous tasks, just return a future from `itemBuilder` and optionally implement `errorBuilder` and `loadingBuilder` parameters
* Using the optional `transitionBuilder` function you can create custom transition animations (defaults to FadeTransition)
* AutoCompleteConfiguration
    * Specify is you'd prefer the suggestions to be shown above or below the field, if there is not enough space then the popup is rendered in whichever direction has the most space.
    * The overflowLeeway parameter specifies how little difference there can be between the space above and space below to go with the preferred option
    * The `clearOnSelected` parameter specifies whether to clear the field on item selection
    * The `dismissOnSelected` parameters specifies whether to dismiss the popup on item selection
    * Customize the shape, background color, and elevation of the dialog
    * Invert the scroll direction using `reverseScrollDirection`
    * Offset the position of the popup using `offset`
    * Set the max size of the popup, must be finite and positive
 
# Usage
Check out the [example project](https://github.com/felixlucien/flutter-autocomplete-textfield/blob/master/example/lib/main.dart)

### Installation
Add to pubspec.yaml
```yaml
    dependencies:
      autocomplete_textfield: ^2.0.0
``` 

Import it into your project
```dart
import 'package:autocomplete_textfield.dart';
```

Implement the and auto-complete text field with an `AutoCompleteTextField`, `AutoCompleteTextFormField`, or `SimpleAutoCompleteTextField`

##### SimpleAutoCompleteTextField [example](https://github.com/felixlucien/flutter-autocomplete-textfield/blob/master/example/lib/views/simple_example.dart)
`SimpleAutoCompleteTextField` only supports the String type, the default child is a list tile with the title being the value of the suggestion.
```dart
  final List<String> suggestions = ['Foo', 'Bar', 'Baz', 'Bat', 'Qux', 'Corge', 'Grault', 'Garply', 'Waldo', 'Fred', 'Plugh', 'XYZZY'];

  Widget build(BuildContext context) {
    return SimpleAutoCompleteTextField(
      suggestions: suggestions,
      suggestionLimit: 5,
      itemFilter: (a, searchTerm) => a.toLowerCase().startsWith(searchTerm.toLowerCase()),
      // The 'sorter' parameter is optional, by default suggestions are sorted in ascending 
      // alphabetical order the following sorts the items in descending alphabetical order
      sorter: (a, b) => b.compareTo(a),
    );
  }
```

##### AutoCompleteTextField - [example](https://github.com/felixlucien/flutter-autocomplete-textfield/blob/master/example/lib/views/complex_example.dart) 
##### and AutoCompleteTextFormField - [example](https://github.com/felixlucien/flutter-autocomplete-textfield/blob/master/example/lib/views/form_example.dart)
* The `query` parameter (`itemBuilder: (context, query)`) is case-sensitive
* Parameters itemBuilder, duration, and onItemSelected are required

```dart
class Foo {
  String bar;
  int baz;
}

...

Widget build(BuildContext context) {
  return AutoCompleteTextField<Foo>(
    onItemSelected: (foo) => foo.bar,
    duration: const Duration(milliseconds: 300),
    itemBuilder: (context, searchTerm) {
      // Keep in mid searchTerm is case-sensitive and this example expects matching case
      return (myFoos
              // Filter out undesired suggestions
              .where((foo) => foo.bar.startsWith(searchTerm))
              .toList()
            // Sort suggestions
            ..sort())
              // Take the amount of suggestions you want to show up, there is no limit and the popup is scrollable
              .take(10)
              // convert to AutoCompleteEntry<Foo>'s
              .map((foo) => AutoCompleteEntry<Foo>(value: foo, child: ListTile(title: Text(foo.bar))))
              .toList();
    } 
  );
}
```

# Demo
![](textfield-demo.gif)
