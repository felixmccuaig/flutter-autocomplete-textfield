part of autocomplete_textfield;

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();

  TextFormField textField;
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
  FocusNode focusNode;

  String currentText = "";

  FormFieldValidator<String> validator;
  InputDecoration decoration;
  List<TextInputFormatter> inputFormatters;
  TextCapitalization textCapitalization;
  TextStyle style;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  TextDirection textDirection;
  TextAlign textAlign;
  bool autovalidate;

  AutoCompleteTextFieldState({
    this.suggestions,
    this.textChanged,
    this.textSubmitted,
    this.onFocusChanged,
    this.itemSubmitted,
    this.itemBuilder,
    this.itemSorter,
    this.autovalidate = false,
    this.itemFilter,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.suggestionsAmount,
    this.submitOnSuggestionTap,
    this.clearOnSubmit,
    this.minLength,
    this.inputFormatters,
    this.textCapitalization,
    this.decoration,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    FocusNode focusNode,
  }) {
    this.focusNode = focusNode ?? new FocusNode();
    textField = new TextFormField(
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      decoration: decoration,
      style: style,
      textDirection: textDirection,
      textAlign: textAlign,
      keyboardType: keyboardType,
      focusNode: this.focusNode,
      validator: validator,
      autovalidate: autovalidate,
      controller: controller ?? new TextEditingController(),
      textInputAction: textInputAction,
      onChanged: (newText) {
        currentText = newText;
        updateOverlay(newText);

        if (textChanged != null) {
          textChanged(newText);
        }
      },
      onTap: () {
        updateOverlay(currentText);
      },
      onFieldSubmitted: (submittedText) =>
          triggerSubmitted(submittedText: submittedText),
    );

    if (this.controller != null && this.controller.text != null) {
      currentText = this.controller.text;
    }

    this.focusNode.addListener(() {
      if (onFocusChanged != null) {
        onFocusChanged(this.focusNode.hasFocus);
      }

      if (!this.focusNode.hasFocus) {
        filteredSuggestions = [];
        updateOverlay();
      } else if (!(currentText == "" || currentText == null)) {
        updateOverlay(currentText);
      }
    });
  }

  void updateDecoration(
      InputDecoration decoration,
      List<TextInputFormatter> inputFormatters,
      TextCapitalization textCapitalization,
      TextStyle style,
      TextInputType keyboardType,
      TextInputAction textInputAction) {
    if (decoration != null) {
      this.decoration = decoration;
    }

    if (inputFormatters != null) {
      this.inputFormatters = inputFormatters;
    }

    if (textCapitalization != null) {
      this.textCapitalization = textCapitalization;
    }

    if (style != null) {
      this.style = style;
    }

    if (keyboardType != null) {
      this.keyboardType = keyboardType;
    }

    if (textInputAction != null) {
      this.textInputAction = textInputAction;
    }

    setState(() {
      textField = new TextFormField(
        inputFormatters: this.inputFormatters,
        textCapitalization: this.textCapitalization,
        decoration: this.decoration,
        style: this.style,
        keyboardType: this.keyboardType,
        focusNode: focusNode ?? new FocusNode(),
        controller: controller ?? new TextEditingController(),
        textInputAction: this.textInputAction,
        onChanged: (newText) {
          currentText = newText;
          updateOverlay(newText);

          if (textChanged != null) {
            textChanged(newText);
          }
        },
        onTap: () {
          updateOverlay(currentText);
        },
        onFieldSubmitted: (submittedText) =>
            triggerSubmitted(submittedText: submittedText),
      );
    });
  }

  void triggerSubmitted({submittedText}) {
    submittedText == null
        ? textSubmitted(currentText)
        : textSubmitted(submittedText);

    if (clearOnSubmit) {
      clear();
    }
  }

  void clear() {
    textField.controller.clear();
    currentText = "";
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
                    children: filteredSuggestions.map(
                      (suggestion) {
                        return new Row(
                          children: [
                            new Expanded(
                              child: new InkWell(
                                child: itemBuilder(context, suggestion),
                                onTap: () {
                                  setState(
                                    () {
                                      if (submitOnSuggestionTap) {
                                        String newText = suggestion.toString();
                                        textField.controller.text = newText;
                                        this.focusNode.unfocus();
                                        itemSubmitted(suggestion);
                                        if (clearOnSubmit) {
                                          clear();
                                        }
                                      } else {
                                        String newText = suggestion.toString();
                                        textField.controller.text = newText;
                                        textChanged(newText);
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ),
          );
        },
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
  void dispose() {
    // if we created our own focus node and controller, dispose of them
    // otherwise, let the caller dispose of their own instances
    if (focusNode == null) {
      this.focusNode.dispose();
    }
    if (controller == null) {
      textField.controller.dispose();
    }
    listSuggestionsEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _layerLink, child: textField);
  }
}
