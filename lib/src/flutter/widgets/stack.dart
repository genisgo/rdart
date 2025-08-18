part of 'widgets.dart';

// -----------------------------------------------------------------------------
// Helpers supposés :
// abstract class Relement { final String? id; Relement({this.id}); Element create(); Element get getElement; }
// typedef VoidCallback = void Function();
// class Container / EdgeInsets / BoxDecoration / BorderRadius / Radius / RText ... (facultatif)
// -----------------------------------------------------------------------------

// =============================================================================
// 1) Stack & Positioned
// =============================================================================

class Stack extends Relement {
  final List<Relement> children;
  final Alignment alignment; // alignment pour les NON-positionnés
  final bool clip; // overflow: hidden
  final List<Bootstrap> bootstrap;

  Stack({
    required this.children,
    this.alignment = Alignment.center,
    this.clip = false,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'stack-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-stack', ...bootstrap.map((e) => e.cname)]);
    _root.style
      ..position = 'relative'
      ..display = 'block'
      ..height="100%"
      ..minHeight = '0';
    if (clip) _root.style.overflow = 'hidden';

    for (final child in children) {
      if (child is Positioned) {
        _root.children.add(child.create()); // enfant déjà positionné
      } else {
        // non-positionné: wrapper fill + flex align
        final host =
            DivElement()
              ..classes.add('rd-stack-fill')
              ..style.position = 'absolute'
              ..style.left = '0'
              ..style.top = '0'
              ..style.right = '0'
              ..style.bottom = '0'
              ..style.display = 'flex'
              ..style.justifyContent = _cssJustify(alignment.x)
              ..style.alignItems = _cssAlign(alignment.y);
        final el = child.create();
        // 'stretch' -> remplir l'axe correspondant
        if (alignment.x == AlignX.stretch) el.style.width = '100%';
        if (alignment.y == AlignY.stretch) el.style.height = '100%';
        host.children.add(el);
        _root.children.add(host);
      }
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
        return 'stretch'; // peu utilisé ici
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
