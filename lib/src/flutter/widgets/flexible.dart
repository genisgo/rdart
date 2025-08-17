part of 'widgets.dart';

/// Wrapper qui applique le comportement flex d’un enfant.
/// Utilisable dans Row **et** Column.
class Flexible extends Relement {
  final Relement child;
  final int flex;
  final FlexFit fit;

  Flexible({
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
    super.id,
  }) : assert(flex > 0);

  final DivElement _host = DivElement();

  @override
  Element create() {
    _host.id = id ?? 'flex-${DateTime.now().microsecondsSinceEpoch}';

    // Applique la politique de flex
    if (fit == FlexFit.tight) {
      // Equivalent Flutter Expanded
      _host.style
        ..flexGrow = '$flex'
        ..flexShrink = '1'
        ..flexBasis = '0%';
    } else {
      // Flexible "loose"
      _host.style
        ..flexGrow = '$flex'
        ..flexShrink = '1'
        ..flexBasis = 'auto';
    }

    _host.children
      ..clear()
      ..add(child.create());

    return _host;
  }

  @override
  Element get getElement => _host;
}
