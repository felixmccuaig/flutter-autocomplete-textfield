part of autocomplete_textfield;

/// A configuration class for [AutoCompleteTextField], [SimpleAutoCompleteTextField], and [AutoCompleteTextFormField]
class AutoCompleteConfiguration {
  /// Max size of the popup
  final Size maxSize;

  /// Material elevation (box shadow) of the popup
  final double elevation;

  /// Shape border of the field
  final ShapeBorder shape;

  /// The background color of the popup
  final Color backgroundColor;

  /// Determines if the popup should try to be shown above the field
  final bool preferAbove;

  /// Position offset of the field
  final Offset offset;

  /// How far apart the available space above and below must be if the opposite of
  /// [preferAbove] is the only suitable option
  final double overflowLeeway;

  /// Whether or not to invert the scroll direction
  final bool reverseScrollDirection;

  /// Clip behavior of the popup up
  final Clip clipBehavior;

  /// Whether to clear the field when an option is selected
  final bool clearOnSelected;

  /// Whether to dismiss the field when an option is dismissed
  final bool dismissOnSelected;

  /// The padding that surrounds the options
  final EdgeInsetsGeometry contentPadding;

  /// Creates an [AutoCompleteConfiguration]
  const AutoCompleteConfiguration({
    this.shape,
    this.backgroundColor,
    this.maxSize = const Size(double.infinity, 240.0),
    this.elevation = 8.0,
    this.preferAbove = false,
    this.reverseScrollDirection = false,
    this.clearOnSelected = false,
    this.dismissOnSelected = true,
    this.offset = Offset.zero,
    this.overflowLeeway = 0.0,
    this.clipBehavior = Clip.none,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 4.0),
  })  : assert(maxSize != null),
        assert(elevation != null),
        assert(preferAbove != null),
        assert(reverseScrollDirection != null),
        assert(clearOnSelected != null),
        assert(dismissOnSelected != null),
        assert(offset != null),
        assert(overflowLeeway != null),
        assert(clipBehavior != null),
        assert(contentPadding != null);
}
