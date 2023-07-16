// This is used for implemented repert
part of "bases.dart";
abstract class EdgInset {
  final int top;
  final int left;
  final int right;
  final int bottom;

  const EdgInset(
      {this.top = 0, this.bottom = 0, this.left = 0, this.right = 0});
}

class REdgetInset extends EdgInset {
  static const zero = REdgetInset();
  const REdgetInset({super.top, super.bottom, super.left, super.right});

  static REdgetInset all(int value) =>
      REdgetInset(top: value, bottom: value, left: value, right: value);
}
