part of 'widgets.dart';

class SizedBox extends Relement {
  final double? width;   // px
  final double? height;  // px
  final Relement? child;
  final List<String> bootstrap;

  /// Si true et qu'aucune dimension n'est fournie, force 0×0 (comme SizedBox.shrink)
  final bool shrink;

  SizedBox({
    this.width,
    this.height,
    this.child,
    this.bootstrap = const [],
    this.shrink = false,
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      // ..id = id ?? 'sizedbox-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-sizedbox', ...bootstrap]);

    final s = _root.style
      ..display = 'block'
      ..flex = '0 0 auto'; // important en contexte flex

    if (width != null) s.width = '${width}px';
    if (height != null) s.height = '${height}px';

    if (shrink && width == null && height == null) {
      s.width = '0';
      s.height = '0';
      s.overflow = 'hidden';
    }

    _root.children.clear();
    if (child != null) _root.children.add(child!.create());
    return _root;
  }

  @override
  Element get getElement => _root;

  // helpers
  void setSize({double? w, double? h}) {
    if (w != null) _root.style.width = '${w}px';
    if (h != null) _root.style.height = '${h}px';
  }

  void setChild(Relement? newChild) {
    _root.children.clear();
    if (newChild != null) _root.children.add(newChild.create());
  }
}