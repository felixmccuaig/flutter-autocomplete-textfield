library autocomplete_textfield;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion);

typedef bool Filter<T>(T suggestion, String query);

typedef InputEventCallback<T>(T data);

typedef StringCallback(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  List<T> suggestions;
  Filter<T> itemFilter;
  Comparator<T> itemSorter;
  StringCallback textChanged, textSubmitted;
  ValueSetter<bool> onFocusChanged;
  InputEventCallback<T> itemSubmitted;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  int suggestionsAmount;
  GlobalKey<AutoCompleteTextFieldState<T>> key;
  bool submitOnSuggestionTap, clearOnSubmit;
  List<TextInputFormatter> inputFormatters;
  int minLength;

  InputDecoration decoration;
  TextStyle style;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  TextCapitalization textCapitalization;
  final TextEditingController controller;

  AutoCompleteTextField(
      {@required
          this.itemSubmitted, //Callback on item selected, this is the item selected of type <T>
      @required
          this.key, //GlobalKey used to enable addSuggestion etc
      @required
          this.suggestions, //Suggestions that will be displayed
      @required
          this.itemBuilder, //Callback to build each item, return a Widget
      @required
          this.itemSorter, //Callback to sort items in the form (a of type <T>, b of type <T>)
      @required
          this.itemFilter, //Callback to filter item: return true or false depending on input text
      this.inputFormatters,
      this.style,
      this.decoration: const InputDecoration(),
      this.textChanged, //Callback on input text changed, this is a string
      this.textSubmitted, //Callback on input text submitted, this is also a string
	  this.onFocusChanged,
      this.keyboardType: TextInputType.text,
      this.suggestionsAmount:
          5, //The amount of suggestions to show, larger values may result in them going off screen
      this.submitOnSuggestionTap:
          true, //Call textSubmitted on suggestion tap, itemSubmitted will be called no matter what
      this.clearOnSubmit: true, //Clear autoCompleteTextfield on submit
      this.textInputAction: TextInputAction.done,
      this.textCapitalization: TextCapitalization.sentences,
      this.minLength = 1,
      this.controller})
      : super(key: key);

  void clear() {
    key.currentState.clear();
  }

  void addSuggestion(T suggestion) {
    key.currentState.addSuggestion(suggestion);
  }

  void removeSuggestion(T suggestion) {
    key.currentState.removeSuggestion(suggestion);
  }

  void updateSuggestions(List<T> suggestions) {
    key.currentState.updateSuggestions(suggestions);
  }

  TextField get textField => key.currentState.textField;

  @override
  State<StatefulWidget> createState() => new AutoCompleteTextFieldState<T>(
      suggestions,
      textChanged,
      textSubmitted,
	  onFocusChanged,
      itemSubmitted,
      itemBuilder,
      itemSorter,
      itemFilter,
      suggestionsAmount,
      submitOnSuggestionTap,
      clearOnSubmit,
      minLength,
      inputFormatters,
      textCapitalization,
      decoration,
      style,
      keyboardType,
      textInputAction,
      controller);
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {

  final LayerLink _layerLink = LayerLink();

  TextField textField;
  List<T> suggestions;
  StringCallback textChanged, textSubmitted;
  ValueSetter<bool> onFocusChanged;
  InputEventCallback<T> itemSubmitted;
  AutoCompleteOverlayItemBuilder<T> itemBuilder;
  Comparator<T> itemSorter;
  OverlayEntry listSuggestionsEntry;
  List<T> filteredSuggestions;
  Filter<T> itemFilter;
  int suggestionsAmount;
  int minLength;
  bool submitOnSuggestionTap, clearOnSubmit;
  TextEditingController controller;

  String currentText = "";

  AutoCompleteTextFieldState(
      this.suggestions,
      this.textChanged,
      this.textSubmitted,
	  this.onFocusChanged,
      this.itemSubmitted,
      this.itemBuilder,
      this.itemSorter,
      this.itemFilter,
      this.suggestionsAmount,
      this.submitOnSuggestionTap,
      this.clearOnSubmit,
      this.minLength,
      List<TextInputFormatter> inputFormatters,
      TextCapitalization textCapitalization,
      InputDecoration decoration,
      TextStyle style,
      TextInputType keyboardType,
      TextInputAction textInputAction,
      TextEditingController controller) {
    textField = new TextField(
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      decoration: decoration,
      style: style,
      keyboardType: keyboardType,
      focusNode: new FocusNode(),
      controller: controller ?? new TextEditingController(),
      textInputAction: textInputAction,
      onChanged: (newText) {
//        print('Autocomplete onChanged '+newText);
        currentText = newText;
        updateOverlay(newText);

        if (textChanged != null) {
          textChanged(newText);
        }
      },
      onTap: (){
        updateOverlay(currentText);
      },
      onSubmitted: (submittedText) {
        if (clearOnSubmit) {
          clear();
        }

        if (textSubmitted != null) {
          textSubmitted(submittedText);
        }
      },
    );
    textField.focusNode.addListener(() {
	    if(onFocusChanged != null)
		    onFocusChanged(textField.focusNode.hasFocus);

      if (!textField.focusNode.hasFocus) {
        filteredSuggestions = [];
        updateOverlay();
      }
      else if(!(currentText == "" || currentText == null)){
        updateOverlay(currentText);
      }
    });
  }

  void clear() {
    textField.controller.clear();
    updateOverlay();
  }

  void addSuggestion(T suggestion) {
    suggestions.add(suggestion);
    updateOverlay(currentText);
  }

  void removeSuggestion(T suggestion) {
    suggestions.contains(suggestion)
        ? suggestions.remove(suggestion)
        : throw "List does not contain suggestion and therefore cannot be removed";
    updateOverlay(currentText);
  }

  void updateSuggestions(List<T> suggestions) {
    this.suggestions = suggestions;
    updateOverlay(currentText);
  }

  void updateOverlay([String query]) {
    if (listSuggestionsEntry == null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      listSuggestionsEntry = new OverlayEntry(
        builder: (context) {
          return new Positioned(
            width: width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, height),
              child: new SizedBox(
                width: width,
                child: new Card(
                  child: new Column(
                    children: filteredSuggestions.map((suggestion) {
                      return new Row(
                        children: [
                          new Expanded(
                            child: new InkWell(
                              child: itemBuilder(context, suggestion),
                              onTap: () {
                                setState(() {
                                  if (submitOnSuggestionTap) {
                                    String newText = suggestion.toString();
                                    textField.controller.text = newText;
                                    textField.focusNode.unfocus();
                                    itemSubmitted(suggestion);
                                    if (clearOnSubmit) {
                                      clear();
                                    }
                                  } else {
                                    String newText = suggestion.toString();
                                    textField.controller.text = newText;
                                    textChanged(newText);
                                  }
                                });
                              }
                            )
                          )
                        ]
                      );
                    }).toList(),
                  )
                )
              )
            )
          );
        }
      );
      Overlay.of(context).insert(listSuggestionsEntry);
    }

    filteredSuggestions = getSuggestions(
        suggestions, itemSorter, itemFilter, suggestionsAmount, query);

    listSuggestionsEntry.markNeedsBuild();
  }

  List<T> getSuggestions(List<T> suggestions, Comparator<T> sorter,
      Filter<T> filter, int maxAmount, String query) {
    if (null == query || query.length < minLength) {
      return [];
    }

    suggestions = suggestions.where((item) => filter(item, query)).toList();
    suggestions.sort(sorter);
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: textField
    );
  }
}

class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  final StringCallback textChanged, textSubmitted;
  final int minLength;
  final ValueSetter<bool> onFocusChanged;
  final TextEditingController controller;

  SimpleAutoCompleteTextField(
      {TextStyle style,
      InputDecoration decoration: const InputDecoration(),
	  this.onFocusChanged,
      this.textChanged,
      this.textSubmitted,
      this.minLength = 1,
      this.controller,
      TextInputType keyboardType: TextInputType.text,
      @required GlobalKey<AutoCompleteTextFieldState<String>> key,
      @required List<String> suggestions,
      int suggestionsAmount: 5,
      bool submitOnSuggestionTap: true,
      bool clearOnSubmit: true,
      TextInputAction textInputAction: TextInputAction.done,
      TextCapitalization textCapitalization: TextCapitalization.sentences})
      : super(
            style: style,
            decoration: decoration,
            textChanged: textChanged,
            textSubmitted: textSubmitted,
            itemSubmitted: textSubmitted,
            keyboardType: keyboardType,
            key: key,
            suggestions: suggestions,
            itemBuilder: null,
            itemSorter: null,
            itemFilter: null,
            suggestionsAmount: suggestionsAmount,
            submitOnSuggestionTap: submitOnSuggestionTap,
            clearOnSubmit: clearOnSubmit,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization);

  @override
  State<StatefulWidget> createState() => new AutoCompleteTextFieldState<String>(
          suggestions, textChanged, textSubmitted, onFocusChanged, itemSubmitted,
          (context, item) {
        return new Padding(padding: EdgeInsets.all(8.0), child: new Text(item));
      }, (a, b) {
        return a.compareTo(b);
      }, (item, query) {
        return item.toLowerCase().startsWith(query.toLowerCase());
      },
          suggestionsAmount,
          submitOnSuggestionTap,
          clearOnSubmit,
          minLength,
          [],
          textCapitalization,
          decoration,
          style,
          keyboardType,
          textInputAction,
          controller);
}
