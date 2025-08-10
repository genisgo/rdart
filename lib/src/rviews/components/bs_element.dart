part of '../rview_bases.dart';


class BsElement extends BootStrapComponent {
  Relement? child;
  bool noUseChildClassName;

  /// Permet d'utiliser[BsElement] comme parent de [child]
  /// ceci implique que tout les [attributes],[bootstraps],
  /// et [dataset] sont appliquer directement au [BsElement]
  final bool userParent;
  BsElement(
      {this.child,
      this.userParent = false,
      required List<Bootstrap> bootstrap,
      Map<String, String> dataset = const {},
      Map<String, String> attributes = const {},
      this.noUseChildClassName = false,
      String? id})
      : super(bootstrap, dataset, attributes, id);
  var _div = Element.div();
  @override
  Element create() {
    //Set id
    _div.children.clear();
    if (child != null) {
      if (userParent) {
        _div.children.add(child!.create());
      } else {
        _div = child!.create();
      }
    }
    //set ID
    if (id != null) _div.id = id!;
    bootstrap();
    return _div;
  }

  @override
  Element get getElement => _div;
  @override
  bootstrap() {
    if (noUseChildClassName) {
      ///Delet all className on the child
      _div.className = " ${bootstraps.join(" ")}";
    } else {
      _div.className += " ${bootstraps.join(" ")}";
    }
    _div.dataset = dataset;
    _div.attributes.addAll(attributes);
  }
}