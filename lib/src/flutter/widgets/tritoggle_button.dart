part of 'widgets.dart';

class TriToggleButton extends ButtonI {
  @override
  final VoidCallback? onPressed; // déclenché à chaque clic
  @override
  final VoidCallback? onLongPress;

  final String label;
  final ButtonSize size;
  final ElevatedVariant variant;
  final bool fullWidth;
  final bool allowIndeterminate;
  final String? tooltip;

  /// Icônes optionnelles selon l’état
  final BsIcon? iconOff;
  final BsIcon? iconOn;
  final BsIcon? iconIndeterminate;

  final void Function(TriState state)? onChanged;

  TriState state;
  bool _enabled;
  bool _loading;

  TriToggleButton({
    required this.label,
    this.state = TriState.off,
    this.onChanged,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSize.medium,
    this.variant = ElevatedVariant.primary,
    this.fullWidth = false,
    this.allowIndeterminate = true,
    this.tooltip,
    this.iconOff,
    this.iconOn,
    this.iconIndeterminate,
    bool enabled = true,
    bool loading = false,
    super.id,
  }) : _enabled = enabled,
       _loading = loading;

  final ButtonElement _btn = ButtonElement();
  Timer? _lpTimer;

  @override
  Element create() {
    _ensureSpinnerStyles();

    _btn
      ..id = id ?? 'tri-${DateTime.now().microsecondsSinceEpoch}'
      ..type = 'button'
      ..title = tooltip ?? ''
      ..classes.add('btn');

    final sz = _sizeClass(size);
    if (sz.isNotEmpty) _btn.classes.add(sz);
    if (fullWidth) _btn.classes.add('w-100');

    _renderVisual();
    _wireEvents();
    _applyState();

    return _btn;
  }

  @override
  Element get getElement => _btn;

  // --- Public API ---
  void setState(TriState v, {bool notify = false}) {
    state = v;
    _renderVisual();
    _applyState();
    if (notify) onChanged?.call(state);
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
    _renderVisual();
    _applyState();
  }

  @override
  void setLabel(String text) {
    // ignore: invalid_use_of_protected_member
    (this as dynamic).label = text;
    _renderVisual();
  }

  // --- Internal ---
  void _renderVisual() {
    _btn.children.clear();

    // classes de base en fonction de l’état
    _btn.classes
      ..removeWhere(
        (c) =>
            c.startsWith('btn-outline-') ||
            c.startsWith('btn-') && _isBootstrapColor(c),
      )
      ..addAll(_classesForState(state, variant));

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
    } else {
      final iconHtml = _iconFor(state);
      if (iconHtml != null) {
        final icon =
            SpanElement()
              ..setInnerHtml(iconHtml, treeSanitizer: NodeTreeSanitizer.trusted)
              ..style.marginRight = '6px';
        _btn.children.add(icon);
      }
    }

    _btn.children.add(SpanElement()..text = label);

    // ARIA
    switch (state) {
      case TriState.on:
        _btn.setAttribute('aria-pressed', 'true');
        _btn.setAttribute('aria-checked', 'true');
        break;
      case TriState.off:
        _btn.setAttribute('aria-pressed', 'false');
        _btn.setAttribute('aria-checked', 'false');
        break;
      case TriState.indeterminate:
        _btn.setAttribute('aria-pressed', 'mixed');
        _btn.setAttribute('aria-checked', 'mixed');
        break;
    }
  }

  void _wireEvents() {
    _btn.onClick.listen((_) {
      if (!_enabled || _loading) return;
      _cycle();
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
      if (e.key == 'Enter' || e.key == ' ') {
        _cycle();
        onPressed?.call();
      }
    });
  }

  void _applyState() {
    _btn.disabled = !_enabled || _loading;
    _btn.classes.toggle('disabled', !_enabled || _loading);
  }

  void _cycle() {
    final next = _nextState(state, allowIndeterminate);
    if (next == state) return;
    state = next;
    _renderVisual();
    _applyState();
    onChanged?.call(state);
  }

  // helpers visuels
  List<String> _classesForState(TriState s, ElevatedVariant v) {
    final name = _variantName(v); // 'primary', ...
    switch (s) {
      case TriState.off:
        return ['btn', 'btn-outline-$name'];
      case TriState.on:
        return ['btn', 'btn-$name'];
      case TriState.indeterminate:
        return ['btn', 'btn-$name', 'opacity-75'];
    }
  }

  String? _iconFor(TriState s) {
    switch (s) {
      case TriState.off:
        return iconOff?.create().outerHtml;
      case TriState.on:
        return iconOn?.create().outerHtml;
      case TriState.indeterminate:
        return iconIndeterminate?.create().outerHtml;
    }
  }

  TriState _nextState(TriState s, bool allowInd) {
    if (!allowInd) {
      return (s == TriState.off) ? TriState.on : TriState.off;
    }
    switch (s) {
      case TriState.off:
        return TriState.on;
      case TriState.on:
        return TriState.indeterminate;
      case TriState.indeterminate:
        return TriState.off;
    }
  }

  // utilitaires (cohérents avec tes autres boutons)
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

  bool _isBootstrapColor(String c) =>
      c == 'btn-primary' ||
      c == 'btn-secondary' ||
      c == 'btn-success' ||
      c == 'btn-warning' ||
      c == 'btn-danger' ||
      c == 'btn-info' ||
      c == 'btn-light' ||
      c == 'btn-dark' ||
      c.startsWith('btn-outline-');
}

/// Fallback spinner CSS si Bootstrap n’est pas chargé
void _ensureSpinnerStyles() {
  if (document.getElementById('rdart-btn-spinner-styles') != null) return;
  final style =
      StyleElement()
        ..id = 'rdart-btn-spinner-styles'
        ..text = '''
.rdart-spinner {
  display:inline-block;width:1rem;height:1rem;border:.15em solid rgba(0,0,0,.2);
  border-top-color: rgba(0,0,0,.6); border-radius:50%; animation:rdart-spin .6s linear infinite;
  vertical-align:-.125em;
}
@keyframes rdart-spin { to{ transform: rotate(360deg); } }
''';
  document.head?.append(style);
}
