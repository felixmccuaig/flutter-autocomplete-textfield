import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() {
  final List<String> suggestions = [
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
    "Jelly",
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
  testWidgets("SimpleAutocompleteTextField contains suggestions supplied",
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey<AutoCompleteTextFieldState<String>>();
    final SimpleAutoCompleteTextField textField =
        SimpleAutoCompleteTextField(key: key, suggestions: suggestions);

    final Widget app = MaterialApp(home: Scaffold(body: textField));

    await tester.pumpWidget(app);

    expect(find.byType(SimpleAutoCompleteTextField), findsOneWidget);

    final AutoCompleteTextFieldState<String> state =
        tester.state(find.byType(SimpleAutoCompleteTextField));

    expect(state.suggestions, suggestions);
  });

  testWidgets("Item can be added to SimpleAutocompleteTextField",
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey<AutoCompleteTextFieldState<String>>();
    final SimpleAutoCompleteTextField textField =
        SimpleAutoCompleteTextField(key: key, suggestions: suggestions);

    final Widget app = MaterialApp(home: Scaffold(body: textField));

    await tester.pumpWidget(app);

    expect(find.byType(SimpleAutoCompleteTextField), findsOneWidget);

    final AutoCompleteTextFieldState<String> state =
        tester.state(find.byType(SimpleAutoCompleteTextField));

    state.addSuggestion("Test");
    List<String> modifiedSuggestions = suggestions;
    modifiedSuggestions.add("Test");
    expect(state.suggestions, modifiedSuggestions);
  });

  testWidgets("Item can be removed from SimpleAutocompleteTextField",
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey<AutoCompleteTextFieldState<String>>();
    final SimpleAutoCompleteTextField textField =
        SimpleAutoCompleteTextField(key: key, suggestions: suggestions);

    final Widget app = MaterialApp(home: Scaffold(body: textField));

    await tester.pumpWidget(app);

    expect(find.byType(SimpleAutoCompleteTextField), findsOneWidget);

    final AutoCompleteTextFieldState<String> state =
        tester.state(find.byType(SimpleAutoCompleteTextField));

    state.removeSuggestion("Cheese");
    List<String> modifiedSuggestions = suggestions;
    modifiedSuggestions.remove("Cheese");
    expect(state.suggestions, modifiedSuggestions);
  });

  testWidgets(
      "SimpleAutocompleteTextField shows expected suggestions with input",
      (WidgetTester tester) async {
    final GlobalKey key = GlobalKey<AutoCompleteTextFieldState<String>>();
    final SimpleAutoCompleteTextField textField = SimpleAutoCompleteTextField(
        key: key, suggestions: suggestions, suggestionsAmount: 5);

    final Widget app = MaterialApp(home: Scaffold(body: textField));

    await tester.pumpWidget(app);

    expect(find.byType(SimpleAutoCompleteTextField), findsOneWidget);

    final AutoCompleteTextFieldState<String> state =
        tester.state(find.byType(SimpleAutoCompleteTextField));

    await tester.enterText(find.byType(TextField), 'm');

    expect(state.filteredSuggestions.length, 1);
    expect(state.filteredSuggestions,
        suggestions.where((element) => element.toLowerCase().startsWith("m")));
  });
}
