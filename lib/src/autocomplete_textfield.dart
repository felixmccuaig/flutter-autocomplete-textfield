part of autocomplete_textfield;

typedef FutureOr<List<AutoCompleteEntry<T>>> AutoCompleteEntryBuilder<T>(BuildContext context, String query);
typedef Widget AutoCompleteErrorBuilder(BuildContext context, Object error);
typedef String AutoCompleteEntrySelected<T>(T value);
typedef Widget AutoCompleteNoSuggestionsBuilder(BuildContext context, String term);

Widget _defaultTransitionBuilder(BuildContext context, Animation<double> animation, Widget child) =>
    FadeTransition(opacity: animation, child: child);

class AutoCompleteEntry<T> {
  /// Determines if this entry ignores the default [AutoCompleteTextField.onItemSelected] callback
  final bool ignoreOnSelected;

  /// Called when the item is selected
  final VoidCallback onTap;

  /// Determines if this entry should ignore [AutoCompleteConfiguration.clearOnSelected]
  final bool ignoreClearOnSelected;

  /// Determines if this entry should ignore [AutoCompleteConfiguration.dismissOnSelected]
  final bool ignoreDismissOnSelected;

  /// The widget that represents this widget
  final Widget child;

  /// Determines if the callbacks are disabled
  final bool enabled;

  /// Determines if to override [AutoCompleteConfiguration.clearOnSelected],
  /// [AutoCompleteConfiguration.dismissOnSelected], and [AutoCompleteTextField.onItemSelected]
  final bool overrideCallbacks;

  /// The value of this entry
  final T value;

  const AutoCompleteEntry({
    this.ignoreOnSelected = false,
    this.ignoreClearOnSelected = false,
    this.ignoreDismissOnSelected = false,
    this.overrideCallbacks = false,
    this.onTap,
    this.enabled = true,
    @required this.value,
    @required this.child,
  })  : assert(child != null),
        assert(ignoreOnSelected != null),
        assert(ignoreOnSelected != null),
        assert(ignoreClearOnSelected != null),
        assert(ignoreDismissOnSelected != null),
        assert(enabled != null),
        assert(overrideCallbacks != null);
}

class _RenderDetails {
  /// Whether or not to render the popup above
  final bool renderAbove;

  /// The height in logical pixels of the dialog
  final double height;

  const _RenderDetails(this.renderAbove, this.height);
}

/// A [TextField] with pop-up suggestions
///
/// A text field that shows suggestions based on the user's input
///
/// Behaves the same as a [TextField] except a popup appears/updates when the value of the text field changes
/// The callback [onItemSelected] is called
///
/// By default, [textFieldConfig] and [config] are created using blank constructors.
/// They cannot be null, and are useful for customizing the behavior and style of the field
///
/// To integrate the [AutoCompleteTextField] into a [Form] with other [FormField] widgets,
/// consider using [AutoCompleteTextFormField]
///
/// The [duration] and [reverseDuration] control the duration of [transitionBuilder]
///
/// If [itemBuilder] returns a [Future], then the [loadingBuilder] and [errorBuilder]
/// are called when the future is loading or the future errors (respectively)
class AutoCompleteTextField<T> extends StatefulWidget {
  final AutoCompleteEntryBuilder<T> itemBuilder;
  final AutoCompleteEntrySelected<T> onItemSelected;
  final AutoCompleteConfiguration config;
  final TextFieldConfiguration textFieldConfig;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Duration duration;
  final Duration reverseDuration;
  final AnimatedTransitionBuilder transitionBuilder;
  final WidgetBuilder loadingBuilder;
  final AutoCompleteErrorBuilder errorBuilder;
  final AutoCompleteNoSuggestionsBuilder noSuggestionsBuilder;

  const AutoCompleteTextField({
    Key key,
    @required this.duration,
    @required this.itemBuilder,
    @required this.onItemSelected,
    this.textFieldConfig = const TextFieldConfiguration(),
    this.config = const AutoCompleteConfiguration(),
    this.focusNode,
    this.controller,
    this.reverseDuration,
    this.transitionBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.noSuggestionsBuilder,
  })  : assert(duration != null),
        assert(itemBuilder != null),
        assert(onItemSelected != null),
        super(key: key);

  @override
  _AutoCompleteTextFieldState<T> createState() => _AutoCompleteTextFieldState<T>();
}

class _AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField<T>>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TextEditingController _textController;
  FocusNode _focusNode;
  AnimationController _animationController;
  OverlayEntry _overlayEntry;
  final LayerLink _link = LayerLink();

  TextEditingController get _effectiveController => widget.controller ?? _textController;

  FocusNode get _effectiveNode => widget.focusNode ?? _focusNode;

  RenderBox get _renderBox => context.findRenderObject() as RenderBox;

  AnimatedTransitionBuilder get _transitionBuilder => widget.transitionBuilder ?? _defaultTransitionBuilder;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _textController = TextEditingController();
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    WidgetsBinding.instance
      ..addObserver(this)
      ..addPostFrameCallback((_) {
        _overlayEntry?.markNeedsBuild();
      });
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
    );

    _effectiveNode.addListener(_focusListener);
  }

  void _focusListener() {
    if (_effectiveNode.hasFocus) {
      if (!_tryInsertOverlay()) {
        _overlayEntry.markNeedsBuild();
      }
    } else {
      removeOverlay();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _effectiveNode.removeListener(_focusListener);
    _textController?.dispose();
    _focusNode?.dispose();
    super.dispose();
  }

  Future<void> insertOverlay() async {
    if (_tryInsertOverlay()) {
      await _animationController.forward();
    }
  }

  Future<void> removeOverlay() async {
    if (_overlayEntry != null) {
      await _animationController.reverse();
      _overlayEntry.remove();
      _overlayEntry = null;
    }
  }

  Rect _getRect(RenderBox box) {
    final translation = box.getTransformTo(null).getTranslation().xy;
    return box.paintBounds.shift(Offset(translation.x, translation.y));
  }

  _RenderDetails _calculateRenderAbove(BuildContext context, Size size, Offset position) {
    assert(() {
      if (widget.config.maxSize.height.isFinite) {
        return true;
      }
      throw FlutterError("The height of the dialog cannot be infinite\n${StackTrace.current}");
    }());
    final mq = MediaQuery.of(context);
    final insets = mq.padding + mq.viewInsets;
    bool renderAbove;
    double overlayHeight = widget.config.maxSize.height;

    final spaceAbove = () {
      final posY = position.dy - widget.config.offset.dy;
      final minY = insets.bottom;
      return posY - minY;
    }();
    final roomAbove = spaceAbove + widget.config.overflowLeeway >= widget.config.maxSize.height;

    final spaceBelow = () {
      final posY = position.dy + size.height + widget.config.offset.dy;
      final maxY = mq.size.height - insets.top;
      return maxY - posY;
    }();
    final roomBelow = spaceBelow + widget.config.overflowLeeway >= widget.config.maxSize.height;

    if (roomAbove ^ roomBelow) {
      renderAbove = roomAbove;
      overlayHeight = (renderAbove ? spaceAbove : spaceBelow).clamp(0.0, overlayHeight);
    } else if (roomAbove && roomBelow) {
      renderAbove = widget.config.preferAbove;
      overlayHeight = (renderAbove ? spaceAbove : spaceBelow).clamp(0.0, overlayHeight);
    } else {
      overlayHeight = math.max(spaceAbove, spaceBelow);
      renderAbove = spaceAbove == overlayHeight;
    }

    return _RenderDetails(renderAbove, overlayHeight.clamp(0, widget.config.maxSize.height));
  }

  List<Widget> _mapEntries(List<AutoCompleteEntry<T>> entries, Size size) => entries
      .map((x) => _OptionWidget(
            option: x,
            config: widget.config,
            enabled: widget.textFieldConfig.enabled,
            width: size.width,
            clearCallback: _effectiveController.clear,
            dismissCallback: _effectiveNode.unfocus,
            onSelected: (v) {
              final string = widget.onItemSelected(v);
              if (string == null) {
                return null;
              } else if (!widget.config.clearOnSelected) {
                _effectiveController.text = string;
                _effectiveController.selection = TextSelection.fromPosition(TextPosition(offset: string.length));
              } else {
                _effectiveController.clear();
              }
              if (widget.config.dismissOnSelected) {
                _effectiveNode.unfocus();
              }
              return string;
            },
          ))
      .toList();

  static Widget _defaultErrorBuilder(BuildContext context, Object error) => Text('Error getting suggestions');

  static Widget _defaultLoadingBuilder(context) => Center(child: CircularProgressIndicator());

  AutoCompleteErrorBuilder get _errorBuilder => widget.errorBuilder ?? _defaultErrorBuilder;

  WidgetBuilder get _loadingBuilder => widget.loadingBuilder ?? _defaultLoadingBuilder;

  bool _tryInsertOverlay() {
    if (_overlayEntry != null) return false;

    _overlayEntry = OverlayEntry(builder: (context) {
      final box = _renderBox;
      final size = _renderBox.size;
      final position = _getRect(box).topLeft;
      final renderDetails = _calculateRenderAbove(context, size, position);

      final offset = renderDetails.renderAbove
          ? Offset(widget.config.offset.dx, -widget.config.offset.dy - renderDetails.height)
          : Offset(widget.config.offset.dx, widget.config.offset.dy + size.height);

      final theme = Theme.of(context);

      Widget _child() {
        return CompositedTransformFollower(
          showWhenUnlinked: false,
          link: _link,
          offset: offset,
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints.loose(Size(size.width, renderDetails.height)),
              child: Material(
                color: widget.config.backgroundColor ?? theme.popupMenuTheme.color,
                elevation: widget.config.elevation,
                shape: widget.config.shape ?? theme.popupMenuTheme.shape,
                clipBehavior: widget.config.clipBehavior,
                animationDuration: widget.duration,
                child: AnimatedBuilder(
                  animation: _effectiveController,
                  builder: (context, _) {
                    final futureOr = widget.itemBuilder(context, _effectiveController.text);

                    Widget _body(List<Widget> children) {
                      return SingleChildScrollView(
                        padding: widget.config.contentPadding,
                        reverse: widget.config.reverseScrollDirection,
                        child: ListBody(
                          reverse: renderDetails.renderAbove,
                          children: children,
                        ),
                      );
                    }

                    if (futureOr is Future) {
                      return FutureBuilder<List<AutoCompleteEntry<T>>>(
                        future: futureOr as Future,
                        builder: (context, snap) {
                          if (snap.hasError) {
                            return _body([_errorBuilder(context, snap.error)]);
                          } else if (snap.hasData) {
                            final items = snap.data;
                            assert(items != null);

                            if (items.isEmpty) {
                              if (widget.noSuggestionsBuilder != null) {
                                return _body([widget.noSuggestionsBuilder(context, _effectiveController.text)]);
                              } else {
                                return ConstrainedBox(constraints: BoxConstraints.tight(Size.zero));
                              }
                            } else {
                              return _body(_mapEntries(snap.data, size));
                            }
                          } else {
                            return _body([_loadingBuilder(context)]);
                          }
                        },
                      );
                    } else {
                      final raw = futureOr as List<AutoCompleteEntry<T>>;
                      if (raw.isEmpty) {
                        if (widget.noSuggestionsBuilder != null) {
                          return _body([widget.noSuggestionsBuilder(context, _effectiveController.text)]);
                        } else {
                          return ConstrainedBox(constraints: BoxConstraints.tight(Size.zero));
                        }
                      }
                      return _body(_mapEntries(raw, size));
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }

      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => _transitionBuilder(
          context,
          _animationController,
          child,
        ),
        child: _child(),
      );
    });
    _animationController.forward();
    Overlay.of(context).insert(_overlayEntry);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: TextField(
        onTap: widget.textFieldConfig.onTap,
        selectionHeightStyle: widget.textFieldConfig.selectionHeightStyle,
        onAppPrivateCommand: widget.textFieldConfig.onAppPrivateCommand,
        dragStartBehavior: widget.textFieldConfig.dragStartBehavior,
        restorationId: widget.textFieldConfig.restorationId,
        scrollController: widget.textFieldConfig.scrollController,
        selectionWidthStyle: widget.textFieldConfig.selectionWidthStyle,
        mouseCursor: widget.textFieldConfig.mouseCursor,
        controller: _effectiveController,
        decoration: widget.textFieldConfig.decoration,
        style: widget.textFieldConfig.style,
        onChanged: widget.textFieldConfig.onChanged,
        onSubmitted: widget.textFieldConfig.onSubmitted,
        focusNode: _effectiveNode,
        enabled: widget.textFieldConfig.enabled,
        inputFormatters: widget.textFieldConfig.inputFormatters,
        keyboardType: widget.textFieldConfig.keyboardType,
        toolbarOptions: widget.textFieldConfig.toolbarOptions,
        textAlign: widget.textFieldConfig.textAlign,
        maxLengthEnforced: widget.textFieldConfig.maxLengthEnforced,
        maxLines: widget.textFieldConfig.maxLines,
        minLines: widget.textFieldConfig.minLines,
        textDirection: widget.textFieldConfig.textDirection,
        autofocus: widget.textFieldConfig.autofocus,
        cursorColor: widget.textFieldConfig.cursorColor,
        autocorrect: widget.textFieldConfig.autocorrect,
        autofillHints: widget.textFieldConfig.autofillHints,
        cursorHeight: widget.textFieldConfig.cursorHeight,
        cursorRadius: widget.textFieldConfig.cursorRadius,
        enableInteractiveSelection: widget.textFieldConfig.enableInteractiveSelection,
        cursorWidth: widget.textFieldConfig.cursorWidth,
        enableSuggestions: widget.textFieldConfig.enableSuggestions,
        expands: widget.textFieldConfig.expands,
        keyboardAppearance: widget.textFieldConfig.keyboardAppearance,
        maxLength: widget.textFieldConfig.maxLength,
        obscureText: widget.textFieldConfig.obscureText,
        obscuringCharacter: widget.textFieldConfig.obscuringCharacter,
        onEditingComplete: widget.textFieldConfig.onEditingComplete,
        readOnly: widget.textFieldConfig.readOnly,
        scrollPadding: widget.textFieldConfig.scrollPadding,
        scrollPhysics: widget.textFieldConfig.scrollPhysics,
        showCursor: widget.textFieldConfig.showCursor,
        smartDashesType: widget.textFieldConfig.smartDashesType,
        smartQuotesType: widget.textFieldConfig.smartQuotesType,
        strutStyle: widget.textFieldConfig.strutStyle,
        textAlignVertical: widget.textFieldConfig.textAlignVertical,
        textCapitalization: widget.textFieldConfig.textCapitalization,
        textInputAction: widget.textFieldConfig.textInputAction,
        buildCounter: widget.textFieldConfig.buildCounter,
      ),
    );
  }
}

class _OptionWidget<T> extends StatelessWidget {
  final double width;
  final AutoCompleteConfiguration config;
  final AutoCompleteEntry<T> option;
  final VoidCallback clearCallback;
  final VoidCallback dismissCallback;
  final AutoCompleteEntrySelected<T> onSelected;
  final bool enabled;

  const _OptionWidget({
    Key key,
    @required this.width,
    @required this.config,
    @required this.option,
    @required this.dismissCallback,
    @required this.clearCallback,
    @required this.enabled,
    @required this.onSelected,
  })  : assert(width != null),
        assert(config != null),
        assert(option != null),
        assert(dismissCallback != null),
        assert(clearCallback != null),
        assert(enabled != null),
        assert(onSelected != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = option.child;

    final _enabled = option.enabled && enabled;
    VoidCallback _clearCallback = config.clearOnSelected && option.ignoreClearOnSelected ? clearCallback : null;
    VoidCallback _dismissCallback = config.dismissOnSelected && option.ignoreDismissOnSelected ? dismissCallback : null;

    if (option.overrideCallbacks) {
      body = GestureDetector(
        onTap: _enabled ? option.onTap : null,
        child: body,
      );
    } else {
      body = InkWell(
        onTap: _enabled
            ? () {
                if (!option.ignoreOnSelected) {
                  onSelected?.call(option.value);
                }
                if (!option.ignoreClearOnSelected) {
                  _clearCallback?.call();
                }
                if (!option.ignoreDismissOnSelected) {
                  _dismissCallback?.call();
                }
                option.onTap?.call();
              }
            : null,
        child: body,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 48.0,
        minWidth: width,
      ),
      child: MergeSemantics(
        child: Semantics(
          button: true,
          enabled: _enabled,
          child: body,
        ),
      ),
    );
  }
}
