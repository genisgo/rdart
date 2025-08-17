part of 'widgets.dart';

class IconButton extends ButtonI {
  @override
  final VoidCallback? onPressed;
  @override
  final VoidCallback? onLongPress;

  final BsIcon icon; // requis
  final String? tooltip;
  final String? ariaLabel;

  final IconButtonStyle style;
  final ElevatedVariant variant; // couleur (reuse ElevatedVariant)
  final ButtonSize size;
  final bool circular; // rend le bouton rond
  final bool fullWidth; // rarement utile pour un icon-only

  bool _enabled;
  bool _loading;

  IconButton({
    required this.icon,
    this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.ariaLabel,
    this.style = IconButtonStyle.filled,
    this.variant = ElevatedVariant.primary,
    this.size = ButtonSize.medium,
    this.circular = true,
    this.fullWidth = false,
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
    _ensureGhostStyles();

    _btn
      ..id = id ?? 'iconbtn-${DateTime.now().microsecondsSinceEpoch}'
      ..type = 'button'
      ..title = tooltip ?? ''
      ..setAttribute('aria-label', ariaLabel ?? tooltip ?? 'icon button')
      ..classes.add('btn');

    // style visuel
    switch (style) {
      case IconButtonStyle.filled:
        _btn.classes.add(buttonElevClass(variant));
        break;
      case IconButtonStyle.outlined:
        _btn.classes.add('btn-outline-${_variantName(variant)}');
        break;
      case IconButtonStyle.ghost:
        _btn.classes.addAll(['btn-ghost']); // custom CSS ci-dessous
        break;
    }

    // taille
    final sz = _sizeClass(size);
    if (sz.isNotEmpty) _btn.classes.add(sz);

    if (fullWidth) _btn.classes.add('w-100');

    // shape + dimensions
    final w = _pxFor(size);
    _btn.style
      ..display = 'inline-flex'
      ..alignItems = 'center'
      ..justifyContent = 'center'
      ..gap = '0'
      ..padding = '0'
      ..width = '${w}px'
      ..height = '${w}px'
      ..lineHeight = '1';
    if (circular) _btn.style.borderRadius = '50%';

    _renderContent();
    _wireEvents();
    _applyState();

    return _btn;
  }

  void _renderContent() {
    _btn.children.clear();

    if (_loading) {
      final sp =
          SpanElement()
            ..classes.addAll(['spinner-border', 'spinner-border-sm']);
      if (sp.getComputedStyle().borderTopColor.isEmpty) {
        sp.classes
          ..clear()
          ..add('rdart-spinner');
      }
      _btn.children.add(sp);
      return;
    }

    final String textIcon = icon.create().outerHtml ?? "";
    final iconSpan =
        SpanElement()
          ..setInnerHtml(textIcon, treeSanitizer: NodeTreeSanitizer.trusted);
    _btn.children.add(iconSpan);
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

  int _pxFor(ButtonSize s) {
    switch (s) {
      case ButtonSize.small:
        return 32;
      case ButtonSize.medium:
        return 40;
      case ButtonSize.large:
        return 48;
    }
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
    /* icon-only : no-op */
  }

  @override
  Element get getElement => _btn;
}

void _ensureGhostStyles() {
  if (document.getElementById('rdart-btn-ghost-styles') != null) return;
  final style =
      StyleElement()
        ..id = 'rdart-btn-ghost-styles'
        ..text = '''
.btn-ghost{
  background: transparent; border: 0; color: var(--rd-ghost-fg, inherit);
}
.btn-ghost:hover{ background: rgba(0,0,0,.05); }
.btn-ghost:active{ background: rgba(0,0,0,.08); }
''';
  document.head?.append(style);
}
