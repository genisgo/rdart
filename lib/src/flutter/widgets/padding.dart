part of  'widgets.dart';
/// =============================================================
/// 1) Padding – wrapper qui applique un padding autour du child
/// =============================================================
class Padding extends Relement {
  final EdgeInsets padding;
  final Relement child;
  final List<Bootstrap> bootstrap;

  Padding({
    required this.padding,
    required this.child,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'padding-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-padding', ...bootstrap.map((e) => e.cname,)])
      ..style.padding = padding.toCss();

    _root.children
      ..clear()
      ..add(child.create());

    return _root;
  }

  @override
  Element get getElement => _root;

  // runtime helper
  void setPadding(EdgeInsets p) {
    _root.style.padding = p.toCss();
  }
}
