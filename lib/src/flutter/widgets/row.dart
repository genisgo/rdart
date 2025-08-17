part of 'widgets.dart';
/// ===============================
/// Row (rdart) – Flutter-like
/// ===============================
class Row extends Relement {
  final List<Relement> children;

  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment; // par défaut: center (comme Flutter)
  MainAxisSize mainAxisSize;
  HorizontalDirection horizontalDirection;

  /// Espacement entre enfants (px) → CSS gap
  int gap;

  /// Autoriser le retour à la ligne (Flutter Row ne wrap pas)
  bool wrap;

  /// Classes additionnelles (Bootstrap…)
  final List<String> bootstrap;

  Row({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.horizontalDirection = HorizontalDirection.ltr,
    this.gap = 0,
    this.wrap = false,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'row-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-row', ...bootstrap]);

    // Base flex
    _root.style
      ..display = 'flex'
      ..flexDirection = (horizontalDirection == HorizontalDirection.ltr)
          ? 'row'
          : 'row-reverse'
      ..flexWrap = wrap ? 'wrap' : 'nowrap'
      ..justifyContent = _cssJustify(mainAxisAlignment)
      ..alignItems = _cssAlign(crossAxisAlignment)
      ..gap = '${gap}px';

    // MainAxisSize
    if (mainAxisSize == MainAxisSize.max) {
      _root.style
        ..minWidth = '100%'
        ..flex = '1 1 auto';
    } else {
      _root.style
        ..minWidth = 'auto'
        ..flex = '';
    }

    // Enfants
    _root.children.clear();
    for (final c in children) {
      _root.children.add(c.create());
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  // Helpers runtime
  void addChild(Relement child) {
    children.add(child);
    if (_root.parent != null) _root.children.add(child.create());
  }

  void insertChild(int index, Relement child) {
    index = index.clamp(0, children.length);
    children.insert(index, child);
    if (_root.parent != null) _root.children.insert(index, child.create());
  }

  void clearChildren() {
    children.clear();
    _root.children.clear();
  }

  void setGap(int px) {
    gap = px;
    _root.style.gap = '${gap}px';
  }

  void setMainAxisAlignment(MainAxisAlignment v) {
    mainAxisAlignment = v;
    _root.style.justifyContent = _cssJustify(v);
  }

  void setCrossAxisAlignment(CrossAxisAlignment v) {
    crossAxisAlignment = v;
    _root.style.alignItems = _cssAlign(v);
  }

  void setMainAxisSize(MainAxisSize v) {
    mainAxisSize = v;
    if (v == MainAxisSize.max) {
      _root.style
        ..minWidth = '100%'
        ..flex = '1 1 auto';
    } else {
      _root.style
        ..minWidth = 'auto'
        ..flex = '';
    }
  }

  void setHorizontalDirection(HorizontalDirection dir) {
    horizontalDirection = dir;
    _root.style.flexDirection =
        (dir == HorizontalDirection.ltr) ? 'row' : 'row-reverse';
  }

  // Mappings
  String _cssJustify(MainAxisAlignment v) {
    switch (v) {
      case MainAxisAlignment.start:
        return 'flex-start';
      case MainAxisAlignment.end:
        return 'flex-end';
      case MainAxisAlignment.center:
        return 'center';
      case MainAxisAlignment.spaceBetween:
        return 'space-between';
      case MainAxisAlignment.spaceAround:
        return 'space-around';
      case MainAxisAlignment.spaceEvenly:
        return 'space-evenly';
    }
  }

  String _cssAlign(CrossAxisAlignment v) {
    switch (v) {
      case CrossAxisAlignment.start:
        return 'flex-start';
      case CrossAxisAlignment.end:
        return 'flex-end';
      case CrossAxisAlignment.center:
        return 'center';
      case CrossAxisAlignment.stretch:
        return 'stretch';
    }
  }
}