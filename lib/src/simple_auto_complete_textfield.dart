part of autocomplete_textfield;

class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  final StringCallback textChanged, textSubmitted;
  final int minLength;
  final ValueSetter<bool> onFocusChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextStyle sugTextStyle;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final bool autovalidate;

  SimpleAutoCompleteTextField(
      {TextStyle style,
      InputDecoration decoration: const InputDecoration(),
      this.onFocusChanged,
      this.textChanged,
      this.textSubmitted,
      this.minLength = 1,
      this.controller,
      this.focusNode,
      this.sugTextStyle,
      this.textDirection,
      this.textAlign,
      this.autovalidate,
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
          textCapitalization: textCapitalization,
          sugTextStyle: sugTextStyle,
          textAlign: textAlign,
          textDirection: textDirection,
        );

  @override
  State<StatefulWidget> createState() => new AutoCompleteTextFieldState<String>(
        suggestions: suggestions,
        textChanged: textChanged,
        textSubmitted: textSubmitted,
        onFocusChanged: onFocusChanged,
        itemSubmitted: itemSubmitted,
        focusNode: focusNode,
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        style: style,
        decoration: decoration,
        minLength: minLength,
        textAlign: textAlign,
        autovalidate: autovalidate,
        textDirection: textDirection,
        textCapitalization: textCapitalization,
        clearOnSubmit: clearOnSubmit,
        submitOnSuggestionTap: submitOnSuggestionTap,
        suggestionsAmount: suggestionsAmount,
        inputFormatters: [],
        itemBuilder: (context, item) {
          return new Padding(
            padding: EdgeInsets.all(8.0),
            child: new Text(
              item,
              style: sugTextStyle,
            ),
          );
        },
        itemSorter: (a, b) {
          return a.compareTo(b);
        },
        itemFilter: (item, query) {
          return item.toLowerCase().startsWith(query.toLowerCase());
        },
      );
}
