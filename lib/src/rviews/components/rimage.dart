part of '../rview_bases.dart';

class RImage extends Relement {
  String url;

  RStyle? style;
  List<String> className;
  RImage({this.url = "", this.style, super.id, this.className = const []});

  var _image = Element.img();

  @override
  Element create() {
    
    _image.attributes.addAll({"src": url, "crossOrigin": "anonymous"});
    if (style != null) {
      _image = style!.createStyle(_image);
    }
    _image.className += " ${className.join(" ")}";
    return _image;
  }

  @override
  Element get getElement => _image;
}
