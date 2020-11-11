part of autocomplete_textfield;

/// See flutter's [TextField]
class TextFieldConfiguration {
  const TextFieldConfiguration({
    this.decoration = const InputDecoration(),
    TextInputType keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    ToolbarOptions toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    SmartDashesType smartDashesType,
    SmartQuotesType smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
  })  : assert(textAlign != null),
        assert(readOnly != null),
        assert(autofocus != null),
        assert(obscuringCharacter != null && obscuringCharacter.length == 1),
        assert(obscureText != null),
        assert(autocorrect != null),
        smartDashesType = smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        assert(enableSuggestions != null),
        assert(enableInteractiveSelection != null),
        assert(maxLengthEnforced != null),
        assert(scrollPadding != null),
        assert(dragStartBehavior != null),
        assert(selectionHeightStyle != null),
        assert(selectionWidthStyle != null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(expands != null),
        assert(
          !expands || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.'),
        assert(maxLength == null || maxLength == TextField.noMaxLength || maxLength > 0),
        // Assert the following instead of setting it directly to avoid surprising the user by silently changing the value they set.
        assert(
            !identical(textInputAction, TextInputAction.newline) ||
                maxLines == 1 ||
                !identical(keyboardType, TextInputType.text),
            'Use keyboardType TextInputType.multiline when using TextInputAction.newline on a multiline TextField.'),
        keyboardType = keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  )
                : const ToolbarOptions(
                    copy: true,
                    cut: true,
                    selectAll: true,
                    paste: true,
                  ));


  /// See [TextField.decoration]
  final InputDecoration decoration;

  /// See [TextField.keyboardType]
  final TextInputType keyboardType;

  /// See [TextField.textInputAction]
  final TextInputAction textInputAction;

  /// See [TextField.textCapitalization]
  final TextCapitalization textCapitalization;

  /// See [TextField.style]
  final TextStyle style;

  /// See [TextField.strutStyle]
  final StrutStyle strutStyle;

  /// See [TextField.textAlign]
  final TextAlign textAlign;

  /// See [TextField.textAlignVertical]
  final TextAlignVertical textAlignVertical;

  /// See [TextField.textDirection]
  final TextDirection textDirection;

  /// See [TextField.autofocus]
  final bool autofocus;

  /// See [TextField.obscuringCharacter]
  final String obscuringCharacter;

  /// See [TextField.obscureText]
  final bool obscureText;

  /// See [TextField.autocorrect]
  final bool autocorrect;

  /// See [TextField.smartDashesType]
  final SmartDashesType smartDashesType;

  /// See [TextField.smartQuotesType]
  final SmartQuotesType smartQuotesType;

  /// See [TextField.enableSuggestions]
  final bool enableSuggestions;

  /// See [TextField.maxLines]
  final int maxLines;

  /// See [TextField.minLines]
  final int minLines;

  /// See [TextField.expands]
  final bool expands;

  /// See [TextField.readOnly]
  final bool readOnly;

  /// See [TextField.toolbarOptions]
  final ToolbarOptions toolbarOptions;

  /// See [TextField.showCursor]
  final bool showCursor;

  /// See [TextField.maxLength]
  final int maxLength;

  /// See [TextField.maxLengthEnforced]
  final bool maxLengthEnforced;

  /// See [TextField.onChanged]
  final ValueChanged<String> onChanged;

  /// See [TextField.onEditingComplete]
  final VoidCallback onEditingComplete;

  /// See [TextField.onSubmitted]
  final ValueChanged<String> onSubmitted;

  /// See [TextField.onAppPrivateCommand]
  final AppPrivateCommandCallback onAppPrivateCommand;

  /// See [TextField.inputFormatters]
  final List<TextInputFormatter> inputFormatters;

  /// See [TextField.enabled]
  final bool enabled;

  /// See [TextField.cursorWidth]
  final double cursorWidth;

  /// See [TextField.cursorHeight]
  final double cursorHeight;

  /// See [TextField.cursorRadius]
  final Radius cursorRadius;

  /// See [TextField.cursorColor]
  final Color cursorColor;

  /// See [TextField.selectionHeightStyle]
  final ui.BoxHeightStyle selectionHeightStyle;

  /// See [TextField.selectionWidthStyle]
  final ui.BoxWidthStyle selectionWidthStyle;

  /// See [TextField.keyboardAppearance]
  final Brightness keyboardAppearance;

  /// See [TextField.scrollPadding]
  final EdgeInsets scrollPadding;

  /// See [TextField.enableInteractiveSelection]
  final bool enableInteractiveSelection;

  /// See [TextField.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// See [TextField.onTap]
  final GestureTapCallback onTap;

  /// See [TextField.mouseCursor]
  final MouseCursor mouseCursor;

  /// See [TextField.buildCounter]
  final InputCounterWidgetBuilder buildCounter;

  /// See [TextField.scrollPhysics]
  final ScrollPhysics scrollPhysics;

  /// See [TextField.scrollController]
  final ScrollController scrollController;

  /// See [TextField.autofillHints]
  final Iterable<String> autofillHints;

  /// See [TextField.restorationId]
  final String restorationId;

  TextFieldConfiguration copyWith({
    InputDecoration decoration,
    TextInputType keyboardType,
    TextInputAction textInputAction,
    TextCapitalization textCapitalization,
    TextStyle style,
    StrutStyle strutStyle,
    TextAlign textAlign,
    TextAlignVertical textAlignVertical,
    TextDirection textDirection,
    bool autofocus,
    String obscuringCharacter,
    bool obscureText,
    bool autocorrect,
    SmartDashesType smartDashesType,
    SmartQuotesType smartQuotesType,
    bool enableSuggestions,
    int maxLines,
    int minLines,
    bool expands,
    bool readOnly,
    ToolbarOptions toolbarOptions,
    bool showCursor,
    int maxLength,
    bool maxLengthEnforced,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    ValueChanged<String> onSubmitted,
    AppPrivateCommandCallback onAppPrivateCommand,
    List<TextInputFormatter> inputFormatters,
    bool enabled,
    double cursorWidth,
    double cursorHeight,
    Radius cursorRadius,
    Color cursorColor,
    ui.BoxHeightStyle selectionHeightStyle,
    ui.BoxWidthStyle selectionWidthStyle,
    Brightness keyboardAppearance,
    EdgeInsets scrollPadding,
    bool enableInteractiveSelection,
    DragStartBehavior dragStartBehavior,
    GestureTapCallback onTap,
    MouseCursor mouseCursor,
    InputCounterWidgetBuilder buildCounter,
    ScrollPhysics scrollPhysics,
    ScrollController scrollController,
    Iterable<String> autofillHints,
    String restorationId,
  }) {
    return TextFieldConfiguration(
      decoration: decoration ?? this.decoration,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      textDirection: textDirection ?? this.textDirection,
      autofocus: autofocus ?? this.autofocus,
      obscuringCharacter: obscuringCharacter ?? this.obscuringCharacter,
      obscureText: obscureText ?? this.obscureText,
      autocorrect: autocorrect ?? this.autocorrect,
      smartDashesType: smartDashesType ?? this.smartDashesType,
      smartQuotesType: smartQuotesType ?? this.smartQuotesType,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      maxLines: maxLines ?? this.maxLines,
      minLines: minLines ?? this.minLines,
      expands: expands ?? this.expands,
      readOnly: readOnly ?? this.readOnly,
      toolbarOptions: toolbarOptions ?? this.toolbarOptions,
      showCursor: showCursor ?? this.showCursor,
      maxLength: maxLength ?? this.maxLength,
      maxLengthEnforced: maxLengthEnforced ?? this.maxLengthEnforced,
      onChanged: onChanged ?? this.onChanged,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      onAppPrivateCommand: onAppPrivateCommand ?? this.onAppPrivateCommand,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      enabled: enabled ?? this.enabled,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      selectionHeightStyle: selectionHeightStyle ?? this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? this.selectionWidthStyle,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      enableInteractiveSelection: enableInteractiveSelection ?? this.enableInteractiveSelection,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      onTap: onTap ?? this.onTap,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      buildCounter: buildCounter ?? this.buildCounter,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      scrollController: scrollController ?? this.scrollController,
      autofillHints: autofillHints ?? this.autofillHints,
      restorationId: restorationId ?? this.restorationId,
    );
  }
}
