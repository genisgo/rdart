part of 'widgets.dart';

/// ------------------------------------------------------------
/// TextButton – bouton lien (plat)
/// ------------------------------------------------------------
class TextButton extends ButtonI {
  @override
  final VoidCallback? onPressed;
  @override
  final VoidCallback? onLongPress;

  final String label;
  final String? tooltip;
  final String? leftIconHtml;
  final String? rightIconHtml;

  /// Classes supplémentaires (ex: ['text-primary']) — en plus de ['btn','btn-link',size]
  final List<String> bootstrap;

  /// Taille
  final ButtonSize size;

  /// Largeur 100%
  final bool fullWidth;

  /// type HTML: 'button' | 'submit'
  final String type;

  /// ARIA
  final String? ariaLabel;

  bool _enabled;
  bool _loading;

  TextButton({
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.leftIconHtml,
    this.rightIconHtml,
    this.bootstrap = const [],
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.type = 'button',
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
      ..id = id ?? 'textbtn-${DateTime.now().microsecondsSinceEpoch}'
      ..type = type
      ..classes.addAll(['btn', 'btn-link'])
      ..title = tooltip ?? ''
      ..setAttribute('aria-label', ariaLabel ?? label);

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
      // Bootstrap spinner si dispo, sinon fallback
      final spinner =
          SpanElement()
            ..classes.addAll(['spinner-border', 'spinner-border-sm'])
            ..setAttribute('role', 'status')
            ..style.marginRight = '6px';
      // fallback si la classe n'existe pas
      if (spinner.getComputedStyle().borderTopColor.isEmpty) {
        spinner.classes
          ..clear()
          ..add('rdart-spinner');
      }
      _btn.children.add(spinner);
    } else if (leftIconHtml != null) {
      final left =
          SpanElement()
            ..setInnerHtml(
              leftIconHtml!,
              treeSanitizer: NodeTreeSanitizer.trusted,
            )
            ..style.marginRight = '6px';
      _btn.children.add(left);
    }

    final text = SpanElement()..text = label;
    _btn.children.add(text);

    if (!_loading && rightIconHtml != null) {
      final right =
          SpanElement()
            ..setInnerHtml(
              rightIconHtml!,
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

    // Long press (≈500ms)
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

    // Accessibilité clavier: Enter/Space
    _btn.onKeyDown.listen((e) {
      if (!_enabled || _loading) return;
      if (e.key == 'Enter' || e.key == ' ') onPressed?.call();
    });
  }

  void _applyState() {
    _btn.disabled = !_enabled || _loading;
    _btn.classes.toggle('disabled', !_enabled || _loading);
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
    // petite astuce: remplace uniquement le noeud texte (2e enfant)
    // sinon on re-render complet
    // ici on rerender pour rester simple et robuste
    final wasLoading = _loading;
    _loading = false;
    final oldEnabled = _enabled;
    // final oldLabel = label; // (non utilisé, mais garde trace)
    // ignore: invalid_use_of_protected_member
    (this as dynamic).label = text; // si tu préfères, crée une prop mutable
    _renderContent();
    _enabled = oldEnabled;
    _loading = wasLoading;
    _applyState();
  }

  @override
  Element get getElement => _btn;
}
