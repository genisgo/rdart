part of 'widgets.dart';

class Positioned extends Relement {
  final Relement child;
  final double? left, top, right, bottom, width, height;

  /// Ajoute un conteneur "stack-fill" sous-jacent pour utiliser flex/align si besoin
  /// (ex: centrer l'enfant à l'intérieur du rectangle positionné)
  final Alignment? alignment;

  Positioned({
    required this.child,
    this.left, this.top, this.right, this.bottom,
    this.width, this.height,
    this.alignment,
    super.id,
  });

  final DivElement _host = DivElement();

  @override
  Element create() {
    _host
      ..id = id ?? 'pos-${DateTime.now().microsecondsSinceEpoch}'
      ..style.position = 'absolute';

    if (left != null)   _host.style.left = '${left}px';
    if (top != null)    _host.style.top = '${top}px';
    if (right != null)  _host.style.right = '${right}px';
    if (bottom != null) _host.style.bottom = '${bottom}px';
    if (width != null)  _host.style.width = '${width}px';
    if (height != null) _host.style.height = '${height}px';

    if (alignment != null) {
      _host.style
        ..display = 'flex'
        ..justifyContent = _cssJustify(alignment!.x)
        ..alignItems = _cssAlign(alignment!.y);
    }

    _host.children.add(child.create());
    return _host;
  }

  @override
  Element get getElement => _host;

  String _cssJustify(AlignX x) {
    switch (x) {
      case AlignX.start:   return 'flex-start';
      case AlignX.center:  return 'center';
      case AlignX.end:     return 'flex-end';
      case AlignX.stretch: return 'stretch';
    }
  }

  String _cssAlign(AlignY y) {
    switch (y) {
      case AlignY.start:   return 'flex-start';
      case AlignY.center:  return 'center';
      case AlignY.end:     return 'flex-end';
      case AlignY.stretch: return 'stretch';
    }
  }
}