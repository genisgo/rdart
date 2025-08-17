part of 'interfaces.dart';

/// ------------------------------------------------------------
/// Interface commune
/// ------------------------------------------------------------
abstract class ButtonI extends Relement {
  ButtonI({super.id});
  VoidCallback? get onPressed;
  VoidCallback? get onLongPress;
  bool get enabled;
  set enabled(bool v);
  bool get loading;
  void setLoading(bool v);
  void setLabel(String text);
}
