part of 'widgets.dart';

// ============================================================
// 2) OutlinedButton – variante contour (Bootstrap btn-outline-*)
// ============================================================
class OutlinedButton extends ButtonI {
  @override
  final VoidCallback? onPressed;
  @override
  final VoidCallback? onLongPress;

  final Relement label;
  final String? tooltip;
  final BsIcon? leftIcon;
  final BsIcon? rightIcon;

  final ElevatedVariant variant; // réutilise la palette
  final ButtonSize size;
  final bool fullWidth;
  final List<String> bootstrap; // extras (ex: 'shadow-sm')
  final ButtonType type; // 'button' | 'submit'
  final String? ariaLabel;

  bool _enabled;
  bool _loading;

  OutlinedButton({
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.leftIcon,
    this.rightIcon,
    this.variant = ElevatedVariant.primary,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.bootstrap = const [],
    this.type = ButtonType.button,
    this.ariaLabel,
    bool enabled = true,
    bool loading = false,
    super.id,
  }) : _enabled = enabled,
       _loading = loading;

  final ButtonElement _btn = ButtonElement();
  Timer? _lpTimer;

  @override
  Element create() {
    buttonEnsureSpinnerStyles();

    _btn
      ..id = id ?? 'outbtn-${DateTime.now().microsecondsSinceEpoch}'
      ..type = type.name
      ..title = tooltip ?? ''
      ..setAttribute('aria-label', ariaLabel ?? label)
      ..classes.addAll(['btn', 'btn-outline-${_variantName(variant)}']);

    final sz = _sizeClass(size);
    if (sz.isNotEmpty) _btn.classes.add(sz);
    if (fullWidth) _btn.classes.add('w-100');
    _btn.classes.addAll(bootstrap);

    _renderContent();
    _wireEvents();
    _applyState();

    return _btn;
  }

  void _renderContent() {
    _btn.children.clear();

    if (_loading) {
      final spinner =
          SpanElement()
            ..classes.addAll(['spinner-border', 'spinner-border-sm'])
            ..setAttribute('role', 'status')
            ..style.marginRight = '6px';
      if (spinner.getComputedStyle().borderTopColor.isEmpty) {
        spinner.classes
          ..clear()
          ..add('rdart-spinner');
      }
      _btn.children.add(spinner);
    } else if (leftIcon != null) {
      final left =
          SpanElement()
            ..setInnerHtml(
              iconToHtml(leftIcon!),
              treeSanitizer: NodeTreeSanitizer.trusted,
            )
            ..style.marginRight = '6px';
      _btn.children.add(left);
    }

    _btn.children.add(label.create());

    if (!_loading && rightIcon != null) {
      final right =
          SpanElement()
            ..setInnerHtml(
             iconToHtml( rightIcon!),
              treeSanitizer: NodeTreeSanitizer.trusted,
            )
            ..style.marginLeft = '6px';
      _btn.children.add(right);
    }
  }

  void _wireEvents() {
    _btn.onClick.listen((e) {
      if (!_enabled || _loading) {
        e.preventDefault();
        return;
      }
      onPressed?.call();
    });

    _btn.onMouseDown.listen((_) {
      if (!_enabled || _loading || onLongPress == null) return;
      _lpTimer?.cancel();
      _lpTimer = Timer(
        const Duration(milliseconds: 500),
        () => onLongPress?.call(),
      );
    });
    _btn.onMouseUp.listen((_) => _lpTimer?.cancel());
    _btn.onMouseLeave.listen((_) => _lpTimer?.cancel());

    _btn.onKeyDown.listen((e) {
      if (!_enabled || _loading) return;
      if (e.key == 'Enter' || e.key == ' ') onPressed?.call();
    });
  }

  void _applyState() {
    _btn.disabled = !_enabled || _loading;
    _btn.classes.toggle('disabled', !_enabled || _loading);
  }

  String _variantName(ElevatedVariant v) {
    switch (v) {
      case ElevatedVariant.primary:
        return 'primary';
      case ElevatedVariant.secondary:
        return 'secondary';
      case ElevatedVariant.success:
        return 'success';
      case ElevatedVariant.warning:
        return 'warning';
      case ElevatedVariant.danger:
        return 'danger';
      case ElevatedVariant.info:
        return 'info';
      case ElevatedVariant.light:
        return 'light';
      case ElevatedVariant.dark:
        return 'dark';
    }
  }

  String _sizeClass(ButtonSize s) {
    switch (s) {
      case ButtonSize.small:
        return 'btn-sm';
      case ButtonSize.medium:
        return '';
      case ButtonSize.large:
        return 'btn-lg';
    }
  }

  @override
  bool get enabled => _enabled;
  @override
  set enabled(bool v) {
    _enabled = v;
    _applyState();
  }

  @override
  bool get loading => _loading;
  @override
  void setLoading(bool v) {
    _loading = v;
    _renderContent();
    _applyState();
  }

  @override
  void setLabel(String text) {
    // simple re-render
    final was = _loading;
    _loading = false;
    // ignore: invalid_use_of_protected_member
    (this as dynamic).label = text;
    _renderContent();
    _loading = was;
    _applyState();
  }

  @override
  Element get getElement => _btn;
}
