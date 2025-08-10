part of '../rview_bases.dart';

class Text extends Relement {
  List<Bootstrap> bootstrap;
  String text;
  Color color;
  RStyle? style;
  final double size;
  final bool singleBootStrap;
  Text(this.text,
      {this.color = Colors.Black,
      this.size = 14,
      this.bootstrap = const [],
      this.style,
      this.singleBootStrap = false,
      super.id});
  final div = Element.div();
  @override
  Element create() {
    div.innerText = text;
    if (!singleBootStrap) {
      div
        ..style.color = color.color
        ..style.fontSize = "${size}px";
    }
    div.className = " ${bootstrap.join(" ")}";
    return style?.createStyle(div) ?? div;
  }
  @override
  Element get getElement => div;
}