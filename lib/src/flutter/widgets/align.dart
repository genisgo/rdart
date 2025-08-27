part of 'widgets.dart';

/// On suppose que `Relement`, `Alignment`, `AlignX`, `AlignY` existent déjà.
/// abstract class Relement { String? id; Relement({this.id}); Element create(); Element get getElement; }

/// =============================================================
/// Align (Flutter-like)
/// =============================================================
enum AlignExpand { width, height, all, none }

class Align extends Relement {
  final Alignment alignment; // ex: Alignment.center, .topLeft...
  final Relement? child;
  final double? width; // px (optionnel)
  final double? height; // px (optionnel)
  final AlignExpand expand; // si true: width/height 100% (prend toute la place)
  final bool clip; // masque le dépassement
  final List<String> bootstrap; // classes additionnelles

  Align({
    this.alignment = Alignment.center,
    this.child,
    this.width,
    this.height,
    this.expand = AlignExpand.none,
    this.clip = false,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'align-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-align', ...bootstrap]);

    final s =
        _root.style
          ..display = 'flex'
          ..flexDirection =
              'row' // peu importe, un seul enfant
          ..justifyContent = _cssJustify(alignment.x)
          ..alignItems = _cssAlign(alignment.y);

    switch (expand) {
      case AlignExpand.all || AlignExpand.height:
        s.height = "100%";
      case AlignExpand.all || AlignExpand.width:
        s.width = "100%";
        break;
      default:
        if (width != null) s.width = '${width}px';
        if (height != null) s.height = '${height}px';
    }
    // if (AlignExpand.none != null) {
    //   s
    //     ..width = '100%'
    //     ..height = '100%';
    // } else {
    //   if (width != null) s.width = '${width}px';
    //   if (height != null) s.height = '${height}px';
    // }

    if (clip) s.overflow = 'hidden';

    if (child != null) {
      final c = child!.create();
      _root.children.add(c);

      // Stretch géré en CSS : si stretch sur un axe, on étire l'enfant
      if (alignment.x == AlignX.stretch) c.style.width = '100%';
      if (alignment.y == AlignY.stretch) c.style.height = '100%';
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  String _cssJustify(AlignX x) {
    switch (x) {
      case AlignX.start:
        return 'flex-start';
      case AlignX.center:
        return 'center';
      case AlignX.end:
        return 'flex-end';
      case AlignX.stretch:
        return 'stretch'; // rare en justify, mais ok
    }
  }

  String _cssAlign(AlignY y) {
    switch (y) {
      case AlignY.start:
        return 'flex-start';
      case AlignY.center:
        return 'center';
      case AlignY.end:
        return 'flex-end';
      case AlignY.stretch:
        return 'stretch';
    }
  }
}
