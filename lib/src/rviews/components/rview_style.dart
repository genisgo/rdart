part of '../rview_bases.dart';

/// RviewStyle : composant pour appliquer un style à un élément

  class RviewStyle extends Relement {
  Relement child;
  RStyle style;
  RviewStyle({required this.child, required this.style, super.id});
  late var _element;
  @override
  Element create() {
    //Set id
    if (id != null) _element.id = id!;
    _element = style.createStyle(child.create());
    return _element;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _element;
}
