part of 'widgets.dart';

class SegmentedControl extends Relement {
  final List<SegmentItem> items;
  int currentIndex;
  final void Function(int index)? onChanged;

  /// Apparence
  final ButtonSize size; // sm / md / lg
  final bool fullWidth; // w-100
  final String? trackColor; // CSS (ex: '#f1f3f5')
  final String? indicatorColor; // CSS (ex: '#fff')
  final String? activeColor; // texte actif
  final String? inactiveColor; // texte inactif

  SegmentedControl({
    required this.items,
    this.currentIndex = 0,
    this.onChanged,
    this.size = ButtonSize.medium,
    this.fullWidth = false,
    this.trackColor,
    this.indicatorColor,
    this.activeColor,
    this.inactiveColor,
    super.id,
  }) : assert(items.isNotEmpty, 'SegmentedControl requires at least one item'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'currentIndex out of range',
       );

  final DivElement _root = DivElement();
  final DivElement _track = DivElement();
  final SpanElement _indicator = SpanElement();
  final List<ButtonElement> _buttons = [];

  static bool _segmentedCssInjected = false;

  @override
  Element create() {
    _ensureSegmentedStyles();

    _root
      ..id = id ?? 'seg-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rd-seg')
      ..dataset['size'] = _sizeToken(size);

    if (fullWidth) _root.classes.add('w-100');

    // CSS vars (optionnelles)
    if (trackColor != null) _root.style.setProperty('--seg-bg', trackColor!);
    if (indicatorColor != null)
      _root.style.setProperty('--seg-indicator', indicatorColor!);
    if (activeColor != null)
      _root.style.setProperty('--seg-active-fg', activeColor!);
    if (inactiveColor != null)
      _root.style.setProperty('--seg-fg', inactiveColor!);

    // Track
    _track.classes.add('rd-seg-track');
    _root.children
      ..clear()
      ..add(_track);

    // Buttons + indicator
    _buttons.clear();
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      final btn =
          ButtonElement()
            ..classes.add('rd-seg-btn')
            ..type = 'button';
      if (it.icon != null) {
        final icon =
            SpanElement()
              ..setInnerHtml(
                it.icon!.create().outerHtml!,
                treeSanitizer: NodeTreeSanitizer.trusted,
              )
              ..style.marginRight = '6px';
        btn.children.add(icon);
      }
      btn.appendText(it.label);
      btn.onClick.listen((_) => setIndex(i, notify: true));
      _buttons.add(btn);
      _track.children.add(btn);
    }

    _indicator.classes.add('rd-seg-indicator');
    _track.children.add(_indicator);

    _layoutIndicator(initial: true);
    _refreshActive();

    return _root;
  }

  @override
  Element get getElement => _root;

  void setIndex(int i, {bool notify = false}) {
    if (i < 0 || i >= items.length || i == currentIndex) return;
    currentIndex = i;
    _layoutIndicator();
    _refreshActive();
    if (notify) onChanged?.call(currentIndex);
  }

  void _layoutIndicator({bool initial = false}) {
    if (_buttons.isEmpty) return;
    final n = items.length;
    final widthPct = 100 / n;
    _indicator.style.width = '$widthPct%';
    // translateX(100%) == largeur de l'indicateur → parfait pour n cases égales
    _indicator.style.transform = 'translateX(${currentIndex * 100}%)';
    if (initial) {
      // évite l’anim à la première pose
      _indicator.style.transition = 'none';
      window.requestAnimationFrame((_) {
        _indicator.style.transition = 'transform .2s ease, width .2s ease';
      });
    }
  }

  void _refreshActive() {
    for (var i = 0; i < _buttons.length; i++) {
      final b = _buttons[i];
      b.classes.toggle('active', i == currentIndex);
      b.setAttribute('aria-pressed', (i == currentIndex).toString());
    }
  }

  static String _sizeToken(ButtonSize s) {
    switch (s) {
      case ButtonSize.small:
        return 'sm';
      case ButtonSize.medium:
        return 'md';
      case ButtonSize.large:
        return 'lg';
    }
  }

  static void _ensureSegmentedStyles() {
    if (_segmentedCssInjected) return;
    _segmentedCssInjected = true;

    final style =
        StyleElement()
          ..id = 'rdart-segmented-styles'
          ..text = '''
.rd-seg{
  --seg-bg: #f1f3f5;
  --seg-indicator: #ffffff;
  --seg-border: rgba(0,0,0,.08);
  --seg-fg: #475569;
  --seg-active-fg: #0f172a;
  display:inline-block; border:1px solid var(--seg-border); border-radius:999px; background:var(--seg-bg); padding:4px; position:relative;
}
.rd-seg.w-100{ display:block; }
.rd-seg-track{ position:relative; display:flex; width:100%; }
.rd-seg-btn{
  flex:1 1 0; position:relative; z-index:1; background:transparent; border:0; border-radius:999px;
  color:var(--seg-fg); cursor:pointer; padding:.5rem .75rem; font-size:.875rem; line-height:1.2; white-space:nowrap;
}
.rd-seg-btn.active{ color:var(--seg-active-fg); font-weight:600; }
.rd-seg-indicator{
  position:absolute; z-index:0; top:0; bottom:0; left:0; width:0; border-radius:999px; background:var(--seg-indicator);
  box-shadow:0 2px 10px rgba(0,0,0,.08); transition:transform .2s ease, width .2s ease;
}
.rd-seg[data-size="sm"] .rd-seg-btn{ padding:.35rem .5rem; font-size:.8rem; }
.rd-seg[data-size="lg"] .rd-seg-btn{ padding:.65rem 1rem; font-size:1rem; }
''';
    document.head?.append(style);
  }
}
