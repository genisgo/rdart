part of 'widgets.dart';

/// <p>=============================================================
/// <br> Column (rdart)
/// <br>============================================================= </p>
/// Un conteneur flex vertical, mappé à Flutter Column.
///
/// - mainAxis => CSS justify-content
/// - crossAxis => CSS align-items
/// - verticalDirection => column / column-reverse
/// - mainAxisSize.max => min-height:100% (+ flex:1 si parent flex)
///
/// NOTE: Flutter Column ne scrolle pas; c'est pareil ici.
///       Pour scroller, enveloppe avec un Relement qui met overflow.
class Column extends Relement {
  
  final List<Relement> children;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  MainAxisSize mainAxisSize;
  VerticalDirection verticalDirection;

  /// Espace entre enfants (en px) -> CSS gap
  int gap;

  /// Classes supplémentaires (ex: Bootstrap utilitaires)
  final List<Bootstrap> bootstrap;

  Column({
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.verticalDirection = VerticalDirection.down,
    this.gap = 0,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'col-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-column', ...bootstrap.map((e) => e.cname,)]);

    // Base flex
    _root.style
      ..display = 'flex'
      ..flexDirection = (verticalDirection == VerticalDirection.down)
          ? 'column'
          : 'column-reverse'
      ..justifyContent = _cssJustify(mainAxisAlignment)
      ..alignItems = _cssAlign(crossAxisAlignment)
      ..gap = '${gap}px';

    // Comportement "MainAxisSize"
    if (mainAxisSize == MainAxisSize.max) {
      // Aide à remplir verticalement si le parent est un flex container
      _root.style
        ..minHeight = '100%'
        ..flex = '1 1 auto';
    } else {
      _root.style
        ..minHeight = 'auto'
        ..flex = '';
    }

    // Injecte les enfants
    _root.children.clear();
    for (final c in children) {
      _root.children.add(c.create());
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  // ===========================================================
  // Helpers runtime (facultatifs) – utiles sans "setState" global
  // ===========================================================

  void addChild(Relement child) {
    children.add(child);
    if (_root.parent != null) {
      _root.children.add(child.create());
    }
  }

  void insertChild(int index, Relement child) {
    index = index.clamp(0, children.length);
    children.insert(index, child);
    if (_root.parent != null) {
      _root.children.insert(index, child.create());
    }
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
        ..minHeight = '100%'
        ..flex = '1 1 auto';
    } else {
      _root.style
        ..minHeight = 'auto'
        ..flex = '';
    }
  }

  void setVerticalDirection(VerticalDirection v) {
    verticalDirection = v;
    _root.style.flexDirection =
        (v == VerticalDirection.down) ? 'column' : 'column-reverse';
  }

  // ===========================================================
  // CSS mapping
  // ===========================================================
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
