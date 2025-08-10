part of '../rview_bases.dart';

class SizeBox extends Relement {
  double? height;
  double? width;
  bool modeRatio;
  List<Bootstrap> bootstrap;
  AlignHorizontal alignHorizontal;
  AlignVertical alignVertical;
  final Relement? child;
  static int _idgenerate = 0;
  SizeBox(
      {this.height,
      this.width,
      this.child,
      super.id,
      this.bootstrap = const [],
      this.modeRatio = false,
      this.alignHorizontal = AlignHorizontal.center,
      this.alignVertical = AlignVertical.center}) {
    _idgenerate++;
  }
  final Element _div = Element.div();
  @override
  Element create() {
    if (child != null) _div.children.add(child!.create());

    _div.id = id ?? "sizebox$_idgenerate";
    _div.className = bootstrap.join(" ");
    if (bootstrap.isEmpty) {
      _div
        ..style.justifyContent = alignHorizontal.value
        ..style.alignItems = alignVertical.value
        ..style.display = "flex"
        ..style.width = width.px
        ..style.padding = 0.px
        ..style.height = height.px;
    }
    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}