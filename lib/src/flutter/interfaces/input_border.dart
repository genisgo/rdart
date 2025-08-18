part of 'interfaces.dart';

abstract class InputBorder {
  final double borderRadius; // px
  final BorderSide borderSide;

  const InputBorder({
    this.borderRadius = 10,
    this.borderSide = const BorderSide(),
  });
  void applyTo(DivElement el);
}
