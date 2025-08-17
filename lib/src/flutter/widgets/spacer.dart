part of 'widgets.dart';

/// Espace extensible (comme Flutter Spacer).
class Spacer extends Relement {
  final int flex;
  Spacer({this.flex = 1, super.id}) : assert(flex > 0);

  final DivElement _el = DivElement();

  @override
  Element create() {
    _el
      ..id = id ?? 'spacer-${DateTime.now().microsecondsSinceEpoch}'
      ..style.flexGrow = '$flex'
      ..style.flexShrink = '1'
      ..style.flexBasis = '0%'
      ..setAttribute('aria-hidden', 'true');
    return _el;
  }

  @override
  Element get getElement => _el;
}
