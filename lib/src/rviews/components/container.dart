part of '../rview_bases.dart';

/// Les container
class Container extends Relement {
  double? width;
  double? height;
  Relement? child;
  RStyle? style;
  bool singleBootStrap;
  Map<String, String>? dataset;
  Container({
    this.child,
    this.style,
    this.width,
    this.height,
    super.id,
    this.singleBootStrap = false,
  });
  var _div = Element.div();
  @override
  Element create() {
    _div.children.clear();
    if (id != null) _div.id = id!;
    if (!singleBootStrap) _div.className = "container";
    if (style != null) {
      if (height != 0) style = style!.copyWith(height: height);
      if (width != 0) style = style!.copyWith(width: width);
      _div = style!.createStyle(_div);
    } else {
      _div
        ..style.width = width == null ? null : "${width}px"
        ..style.height = height == null ? null : "${height}px";
    }
    if (child != null) {
      _div.children.add(child!.create());
    }
    return _div;
  }
  @override
  Element get getElement => _div;
}