// This is used for implemented repert
part of 'rview_bases.dart';
abstract class EdgInset {
  final double top;
  final double left;
  final double right;
  final double bottom;

  const EdgInset(
      {this.top = 0, this.bottom = 0, this.left = 0, this.right = 0});
}

class REdgetInset extends EdgInset {
  static const zero = REdgetInset();
  const REdgetInset({super.top, super.bottom, super.left, super.right});
  const REdgetInset.all(double value)
      : super(top: value, bottom: value, left: value, right: value);
}
