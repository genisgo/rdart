part of 'widgets.dart';

class Wrap extends Relement {
  final List<Relement> children;

  final Axis direction; // horizontal (par défaut) | vertical
  final TextDir textDirection; // ltr/rtl si horizontal
  final RunsDirection runsDirection; // wrap normal vs wrap-reverse
  final WrapAlignment alignment; // aligne les items sur l'axe principal
  final WrapAlignment runAlignment; // aligne les "runs" (align-content)
  final WrapCrossAlignment
  crossAxisAlignment; // aligne les items sur l'axe transversal

  /// Espace entre éléments sur l'axe principal
  final int spacing; // px
  /// Espace entre lignes/colonnes (entre "runs")
  final int runSpacing; // px

  final List<String> bootstrap; // classes supplémentaires
  final bool clip; // overflow hidden

  Wrap({
    required this.children,
    this.direction = Axis.horizontal,
    this.textDirection = TextDir.ltr,
    this.runsDirection = RunsDirection.down,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
    this.bootstrap = const [],
    this.clip = false,
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'wrap-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-wrap', ...bootstrap]);

    final s =
        _root.style
          ..display = 'flex'
          ..flexWrap =
              (runsDirection == RunsDirection.down) ? 'wrap' : 'wrap-reverse'
          ..justifyContent = _cssWrapAlign(alignment) // sur l'axe principal
          ..alignContent = _cssWrapAlign(runAlignment) // entre les runs
          ..alignItems = _cssWrapCross(crossAxisAlignment);

    // Direction (axe principal)
    if (direction == Axis.horizontal) {
      s.flexDirection = (textDirection == TextDir.ltr) ? 'row' : 'row-reverse';
      // spacing (main axis) -> column-gap, runSpacing -> row-gap
      s.columnGap = '${spacing}px';
      s.rowGap = '${runSpacing}px';
    } else {
      s.flexDirection =
          (runsDirection == RunsDirection.down) ? 'column' : 'column-reverse';
      // pour direction=column, main axis vertical => row-gap = spacing
      s.rowGap = '${spacing}px';
      s.columnGap = '${runSpacing}px';
    }

    if (clip) s.overflow = 'hidden';

    // Enfants
    _root.children.clear();
    for (final c in children) {
      _root.children.add(c.create());
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  // Helpers d'ajout dynamique (facultatifs)
  void addChild(Relement child) {
    children.add(child);
    if (_root.parent != null) _root.children.add(child.create());
  }

  void insertChild(int index, Relement child) {
    index = index.clamp(0, children.length);
    children.insert(index, child);
    if (_root.parent != null) _root.children.insert(index, child.create());
  }

  // Mappings
  String _cssWrapAlign(WrapAlignment a) {
    switch (a) {
      case WrapAlignment.start:
        return 'flex-start';
      case WrapAlignment.end:
        return 'flex-end';
      case WrapAlignment.center:
        return 'center';
      case WrapAlignment.spaceBetween:
        return 'space-between';
      case WrapAlignment.spaceAround:
        return 'space-around';
      case WrapAlignment.spaceEvenly:
        return 'space-evenly';
    }
  }

  String _cssWrapCross(WrapCrossAlignment a) {
    switch (a) {
      case WrapCrossAlignment.start:
        return 'flex-start';
      case WrapCrossAlignment.end:
        return 'flex-end';
      case WrapCrossAlignment.center:
        return 'center';
      case WrapCrossAlignment.stretch:
        return 'stretch';
    }
  }
}
