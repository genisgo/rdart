part of "bases.dart";

class RButton extends Relement {
  RStyle? style;
  bool disable;
  Relement child;
  Function(Relement relement)? onHover;
  Function(Relement relement)? onPress;
  RButton(
      {
      this.onPress, 
      this.style,
      this.onHover,
      required this.child,
      this.disable = false});
  var element = ButtonElement();
  @override
  Element create() {
    ///Insertion de titre
    
    element.children.add( child.create());

    ///ajout de nom de classe
    element.id = "btn_defaut";
    element.className = "rbtn";

    ///Ajout des evenements
    if (onHover != null) {
      element.onMouseUp.listen((event) {
        onHover!(this);
      });
    }
    //Evement Click
    if (onPress != null) {
      element.onClick.listen((event) {
        onPress!(this);
      });
    }
    mouseEventAnimation(element);

    ///add de style
    if (style != null) {
      ///Add default size
      style!.width == 0 ? style!.width = 100 : null;
      style!.height == 0 ? style!.height = 45 : null;

      ///Add default decoration
      if (style!.decoration == null) {
        style!.decoration = Decoration(
            backgroundColor: Default.primaryColor,
            shadow: BoxShadow(blur: 3,horizontal: 1,vertical: 1),
            border: Rborder(raduis: Raduis.all(8)));
      }
      
    }
    element =
        (style ?? Default.buttonStyle).createStyle(element) as ButtonElement;

    return element;
  }

  @override
  // TODO: implement getElement
  Element get getElement => element;

  void mouseEventAnimation(Element element) {
    element.onMouseDown.listen((event) {
      element.style.opacity = "0.9";
    });
    element.onMouseUp.listen((event) {
      element.style.opacity = "1";
    });
  }
}

void main(List<String> args) {}
