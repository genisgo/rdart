part of '../rview_bases.dart';

// ///Colum Element

class Column extends Relement {
  ///Les elements de la colone
  List<Relement> children;

  ///Le mainAxisAlignment est l'alignement qui definis la disposition des
  ///elements de façon horizontale par defaut les element sondisposer a gauche
  ///la valeur par defaut est une list vide *const []*
  AlignHorizontal mainAxisAlignment;
  bool mainAxisExpand;
  bool crossAxisExpand;
  List<Bootstrap> bootstrap;
  bool singleBootStrap;

  /// [crossAxisAlignment] est l'alignement verticale des elements par defaut
  /// sa valeur est [AlignmentVertical.top]
  AlignVertical crossAxisAlignment;
  Column(
      {this.children = const [],
      this.mainAxisExpand = false,
      this.crossAxisExpand = true,
      this.bootstrap = const [],
      super.id,
      this.singleBootStrap = true,
      this.crossAxisAlignment = AlignVertical.top,
      this.mainAxisAlignment = AlignHorizontal.left});
  var _div = Element.div();
  @override
  Element create() {
    _div.children?.clear(); 
    if (id != null) _div.id = id!;
    if (!singleBootStrap) {
      _div
        ..className = "column"
        ..style.display = "flex"
        ..style.flexDirection = "column";
    }

    _div.children.addAll(children.map((e) => e.create()).toList());
    _div = singleBootStrap
        ? RStyle(bootstrap: bootstrap).createStyle(_div)
        : RStyle(
                bootstrap: bootstrap,
                alignHorizontal: mainAxisAlignment,
                expandWidth: crossAxisExpand,
                expandHeight: mainAxisExpand,
                background: Colors.none,
                alignmentVertical: crossAxisAlignment)
            .createStyle(_div);
    return _div;
  }

  @override
  Element get getElement => _div;
}
