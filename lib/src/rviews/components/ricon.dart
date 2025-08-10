part of '../rview_bases.dart';


//Icon
class Ricon extends Relement {
  const Ricon(
      {this.unicode = "\u2003",
      this.color = Colors.White,
      this.size = 24,
      super.id})
      : super();
  final int size;
  final String unicode;
  final Color color;
  @override
  Element create() {
    return Element.div()
      ..text = unicode
      ..className = "icon"
      ..style.color = color.color
      ..style.fontSize = "${size}px"
      ..id = unicode;
  }

  @override
  Element get getElement => querySelector("#$unicode")!;
}

enum Ricons {
  ///  [\u2665]
  coeur("\u2665"),
  cotification("\u2740"),
  coeurSymbole("\u2765");

  const Ricons(this.iconCode);
  final String iconCode;
  Ricon getIcon({int size = 24, Color color = Colors.White}) =>
      Ricon(color: color, size: size, unicode: iconCode);
}
