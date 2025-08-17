part of 'widgets.dart';

class ElevatedButton extends ButtonI {
  @override
  final VoidCallback? onPressed;
  @override
  final VoidCallback? onLongPress;

  final String label;
  final String? tooltip;
  final String? leftIconHtml;
  final String? rightIconHtml;

  final ElevatedVariant variant;
  final ButtonSize size;
  final bool fullWidth;
  final List<String> bootstrap; // s'ajoute à ['btn', elevClass, size, 'shadow']

  final String type; // 'button' | 'submit'
  final String? ariaLabel;

  bool _enabled;
  bool _loading;

  ElevatedButton({
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.leftIconHtml,
    this.rightIconHtml,
    this.variant = ElevatedVariant.primary,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.bootstrap = const ['shadow'],
    this.type = 'button',
    this.ariaLabel,
    bool enabled = true,
    bool loading = false,
    super.id,
  })  : _enabled = enabled,
        _loading = loading;

  final ButtonElement _btn = ButtonElement();
  Timer? _lpTimer;

  @override
  Element create() {
    buttonEnsureSpinnerStyles();

    _btn
      ..id = id ?? 'elevbtn-${DateTime.now().microsecondsSinceEpoch}'
      ..type = type
      ..title = tooltip ?? ''
      ..setAttribute('aria-label', ariaLabel ?? label)
      ..classes.addAll(['btn', buttonElevClass(variant)]);

    final sz = buttonSizeClass(size);
    if (sz.isNotEmpty) _btn.classes.add(sz);
    _btn.classes.addAll(bootstrap);
    if (fullWidth) _btn.classes.add('w-100');

    _renderContent();
    _wireEvents();
    _applyState();

    return _btn;
  }

  void _renderContent() {
    _btn.children.clear();

    if (_loading) {
      final spinner = SpanElement()
        ..classes.addAll(['spinner-border', 'spinner-border-sm'])
        ..setAttribute('role', 'status')
        ..style.marginRight = '6px';
      if (spinner.getComputedStyle().borderTopColor.isEmpty) {
        spinner.classes
          ..clear()
          ..add('rdart-spinner');
      }
      _btn.children.add(spinner);
    } else if (leftIconHtml != null) {
      final left = SpanElement()
        ..setInnerHtml(leftIconHtml!, treeSanitizer: NodeTreeSanitizer.trusted)
        ..style.marginRight = '6px';
      _btn.children.add(left);
    }

    final text = SpanElement()..text = label;
    _btn.children.add(text);

    if (!_loading && rightIconHtml != null) {
      final right = SpanElement()
        ..setInnerHtml(rightIconHtml!, treeSanitizer: NodeTreeSanitizer.trusted)
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
      _lpTimer = Timer(const Duration(milliseconds: 500), () => onLongPress?.call());
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
    // Optionnel: estomper visuellement quand disabled
    _btn.style.opacity = (!_enabled || _loading) ? '.8' : '1';
    _btn.style.pointerEvents = (!_enabled || _loading) ? 'auto' : 'auto';
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
    final wasLoading = _loading;
    _loading = false;
    final oldEnabled = _enabled;
    // ignore: invalid_use_of_protected_member
    (this as dynamic).label = text;
    _renderContent();
    _enabled = oldEnabled;
    _loading = wasLoading;
    _applyState();
  }

  @override
  Element get getElement => _btn;
}