part of autocomplete_textfield;

typedef bool SimpleAutoCompleteTextFilter(String value, String query);

/// An [AutoCompleteTextField] simplified to only support strings and have additional callbacks for sorting and filtering
class SimpleAutoCompleteTextField extends AutoCompleteTextField<String> {

  /// Creates a [TextField] with pop up suggestions
  ///
  /// The parameters [suggestions], [suggestionLimit], [itemFilter] are required
  /// By default [sorter] sorts items by ascending alphabetical order\
  /// By default [onItemSelected] returns the it's string value
  /// Parameters [duration], [config], and [textFieldConfig] must not be null but have defaults
  SimpleAutoCompleteTextField({
    Key key,
    TextEditingController controller,
    FocusNode focusNode,
    @required List<String> suggestions,
    @required int suggestionLimit,
    @required SimpleAutoCompleteTextFilter itemFilter,
    AutoCompleteEntrySelected<String> onItemSelected,
    Comparator<String> sorter,
    AutoCompleteNoSuggestionsBuilder noSuggestionsBuilder,
    Duration duration = const Duration(milliseconds: 300),
    AutoCompleteConfiguration config = const AutoCompleteConfiguration(),
    TextFieldConfiguration textFieldConfig = const TextFieldConfiguration(),
  })  : assert(suggestions != null),
        assert(suggestionLimit != null),
        assert(itemFilter != null),
        assert(duration != null),
        assert(textFieldConfig != null),
        assert(config != null),
        super(
          key: key,
          duration: duration,
          textFieldConfig: textFieldConfig,
          controller: controller,
          focusNode: focusNode,
          config: config,
          noSuggestionsBuilder: noSuggestionsBuilder ?? (c, t) => Center(child: Text('No results for "$t"')),
          onItemSelected: onItemSelected ?? (x) => x,
          errorBuilder: null,
          loadingBuilder: null,
          reverseDuration: null,
          transitionBuilder: null,
          itemBuilder: (context, t) {
            return (suggestions.where((x) => itemFilter(x, t)).toList()..sort(sorter))
                .take(suggestionLimit)
                .map((x) => AutoCompleteEntry<String>(value: x, child: ListTile(title: Text(x))))
                .toList();
          },
        );
}
