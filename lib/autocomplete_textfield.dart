library autocomplete_textfield;

import 'package:flutter/material.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion);

typedef bool Filter<T>(T suggestion, String query);

typedef StringCallback(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  List<T> suggestions;
  Filter<T> itemFilter;
  Comparator<T> itemSorter;
  StringCallback textChanged;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  int suggestionsAmount;
  GlobalKey<AutoCompleteTextFieldState<T>> key;

  AutoCompleteTextField(
      {@required this.key,
        @required this.suggestions,
        @required this.textChanged,
        @required this.itemBuilder,
        @required this.itemSorter,
        @required this.itemFilter,
        this.suggestionsAmount : 5}) : super(key: key);

  void clear() {
    key.currentState.textField.controller.clear();
  }

  @override
  State<StatefulWidget> createState() => new AutoCompleteTextFieldState<T>(
      suggestions, textChanged, itemBuilder, itemSorter, itemFilter, suggestionsAmount);
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  TextField textField;
  List<T> suggestions;
  StringCallback textChanged;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  Comparator<T> itemSorter;
  OverlayEntry listSuggestionsEntry;
  List<T> filteredSuggestions;
  Filter<T> itemFilter;
  int suggestionsAmount;

  AutoCompleteTextFieldState(this.suggestions, this.textChanged,
      this.itemBuilder, this.itemSorter, this.itemFilter, this.suggestionsAmount) {
    textField = new TextField(
      focusNode: new FocusNode(),
      controller: new TextEditingController(),
      onChanged: (newText) {
        textChanged(newText);
        updateOverlay(newText);
      },
    );
    textField.focusNode.addListener(() {
      if(!textField.focusNode.hasFocus) {
        filteredSuggestions = [];
      }
    });
  }

  void updateOverlay(String query) {
    if (listSuggestionsEntry == null) {
      final RenderBox textFieldRenderBox = context.findRenderObject();
      final RenderBox overlay = Overlay.of(context).context.findRenderObject();
      final width = textFieldRenderBox.size.width;
      final RelativeRect position = new RelativeRect.fromRect(
        new Rect.fromPoints(
          textFieldRenderBox.localToGlobal(
              textFieldRenderBox.size.bottomLeft(Offset.zero),
              ancestor: overlay),
          textFieldRenderBox.localToGlobal(
              textFieldRenderBox.size.bottomRight(Offset.zero),
              ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );

      listSuggestionsEntry = new OverlayEntry(builder: (context) {
        return new Positioned(
            top: position.top,
            left: position.left,
            child: new Container(
                width: width,
                child: new Card(
                    child: new Column(
                      children: filteredSuggestions.map((suggestion) {
                        return new Row(children: [
                          new Expanded(
                              child: new InkWell(
                                  child: itemBuilder(context, suggestion),
                                  onTap: () {
                                    setState(() {
                                      String newText = suggestion.toString();
                                      textField.controller.text = newText;
                                      textField.focusNode.unfocus();
                                      textChanged(newText);
                                    });
                                  }))
                        ]);
                      }).toList(),
                    ))));
      });
      Overlay.of(context).insert(listSuggestionsEntry);
    }

    filteredSuggestions =
        getSuggestions(suggestions, itemSorter, itemFilter, suggestionsAmount, query);
    listSuggestionsEntry.markNeedsBuild();
  }

  List<T> getSuggestions(List<T> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String query) {
    if (query == "") {
      return [];
    }

    suggestions.sort(sorter);
    suggestions = suggestions.where((item) => filter(item, query)).toList();
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return textField;
  }
}
