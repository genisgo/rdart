part of 'bs.components.dart';

class BsIcon extends Relement {
  RStyle? style;
  Color? color;
  Bicon icon;
  double? size;
  BsIcon({super.id, required this.icon, this.style, this.color, this.size});
  var _i = Element.tag("i");

  @override
  Element create() {
    if (id != null) {
      _i.id = id!;
    }
    if (size != null) _i.style.fontSize = "${size}px";
    _i.style.color = color?.color;
    if (style != null) {
      _i = style!.createStyle(_i);
    }
    _i.className = ["bi", "bi-$icon"].join(" ");
    return _i;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _i;
}
