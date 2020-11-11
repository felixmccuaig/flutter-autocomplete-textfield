part of autocomplete_textfield;

/// A [FormField] that contains an [AutoCompleteTextFormField]
///
/// This is a convenience widget that wraps an [AutoCompleteTextFormField] widget in a [FormField]
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// Remember to call [TextEditingController.dispose] of the the [TextEditingController]
/// when it is no longer needed. This will ensure we discard any resources used by the object.
///
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField] and [TextFieldConfiguration].
class AutoCompleteTextFormField<T> extends FormField<String> {
  AutoCompleteTextFormField({
    Key key,
    this.controller,
    FocusNode focusNode,
    String initialValue,
    @required Duration duration,
    @required AutoCompleteEntryBuilder<T> itemBuilder,
    @required AutoCompleteEntrySelected<T> onItemSelected,
    TextFieldConfiguration textFieldConfig = const TextFieldConfiguration(),
    AutoCompleteConfiguration config = const AutoCompleteConfiguration(),
    Duration reverseDuration,
    WidgetBuilder loadingBuilder,
    AutoCompleteErrorBuilder errorBuilder,
    AnimatedTransitionBuilder transitionBuilder,
    AutoCompleteNoSuggestionsBuilder noSuggestionsBuilder,
    FormFieldSetter<String> onSaved,
    FormFieldValidator<String> validator,
    AutovalidateMode autovalidateMode,
  })  : assert(initialValue == null || controller == null),
        assert(textFieldConfig != null),
        assert(duration != null),
        assert(itemBuilder != null),
        assert(onItemSelected != null),
        assert(config != null),
        super(
          key: key,
          initialValue: controller != null ? controller.text : (initialValue ?? ''),
          onSaved: onSaved,
          validator: validator,
          enabled: textFieldConfig.enabled ?? textFieldConfig.decoration?.enabled ?? true,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final _AutoCompleteTextFormFieldState state = field as _AutoCompleteTextFormFieldState;
            final InputDecoration effectiveDecoration = (textFieldConfig.decoration ?? const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);
            void onChangedHandler(String value) {
              if (textFieldConfig.onChanged != null) {
                textFieldConfig.onChanged(value);
              }
              field.didChange(value);
            }

            return AutoCompleteTextField<T>(
              duration: duration,
              itemBuilder: itemBuilder,
              transitionBuilder: transitionBuilder,
              reverseDuration: reverseDuration,
              loadingBuilder: loadingBuilder,
              errorBuilder: errorBuilder,
              onItemSelected: onItemSelected,
              noSuggestionsBuilder: noSuggestionsBuilder,
              config: config,
              controller: state._effectiveController,
              textFieldConfig: textFieldConfig.copyWith(
                decoration: effectiveDecoration.copyWith(errorText: field.errorText),
                onChanged: onChangedHandler,
                smartDashesType: textFieldConfig.smartDashesType ??
                    (textFieldConfig.obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
                smartQuotesType: textFieldConfig.smartQuotesType ??
                    (textFieldConfig.obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
                enabled: textFieldConfig.enabled ?? textFieldConfig.decoration?.enabled ?? true,
              ),
              focusNode: focusNode,
            );
          },
        );

  final TextEditingController controller;

  @override
  FormFieldState<String> createState() => _AutoCompleteTextFormFieldState();
}

class _AutoCompleteTextFormFieldState extends FormFieldState<String> {
  TextEditingController _controller;

  TextEditingController get _effectiveController => widget.controller ?? _controller;

  @override
  AutoCompleteTextFormField get widget => super.widget as AutoCompleteTextFormField;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(AutoCompleteTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller = TextEditingController.fromValue(oldWidget.controller.value);
      if (widget.controller != null) {
        setValue(widget.controller.text);
        if (oldWidget.controller == null) _controller = null;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void didChange(String value) {
    super.didChange(value);

    if (_effectiveController.text != value) _effectiveController.text = value;
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController.text = widget.initialValue;
    });
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) didChange(_effectiveController.text);
  }
}
