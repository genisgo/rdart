part of '../rview_bases.dart';

//Row Element

class Row extends Relement {
  List<Relement> children;
  AlignHorizontal? mainAxisAlignment;
  AlignVertical? crossAxisAlignment;
  List<Bootstrap> bootstrap;
  bool singleBootStrap;
  Row({
    super.id,
    this.children = const [],
    this.singleBootStrap = false,
    this.bootstrap = const [],
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  });

  var _div = Element.div();
  @override
  Element create() {
    dispose();
    //_div.children.clear();
    if (id != null) {
      _div.id = id!;
    }
    if (!singleBootStrap) _div.className = "row";

    _div.children.addAll(children.map((e) => e.create()));
    _div = RStyle(
            alignHorizontal: mainAxisAlignment,
            alignmentVertical: crossAxisAlignment,
            bootstrap: bootstrap,
            expandWidth: !singleBootStrap)
        .createStyle(_div);
    return _div;
  }

  @override
  dispose() {
    _div.children.clear();
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
  // @override
  // dispose() {
  //   getElement.children.clear();
  //   return super.dispose();
  // }
}