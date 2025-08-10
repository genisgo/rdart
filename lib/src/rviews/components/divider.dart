part of '../rview_bases.dart';
// //divider

class Divider extends Relement {
  double height;
  double? width;
  Color color;
  static int _idgenerate = 0;
  Divider({this.height = 1, this.color = Colors.gray, this.width, super.id}) {
    _idgenerate++;
  }
  final Element _div = Element.hr();
  @override
  Element create() {
    //Set id
    _div
      ..id = id ?? "divider$_idgenerate"
      ..style.color = color.color
      ..style.width = width == null ? "-webkit-fill-available" : "${width}px"
      ..style.height = "${height}px";

    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}
