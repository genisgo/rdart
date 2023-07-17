part of 'rview_bases.dart';
class RButton extends Relement {
  RStyle? style;
  bool disable;
  Relement child;
  Function(Relement relement)? onHover;
  Function(Relement relement)? onPress;
  RButton(
      {this.onPress,
      this.style,
      this.onHover,
      required this.child,
      this.disable = false});
  var element = ButtonElement();
  @override
  Element create() {
    ///Insertion de titre

    element.children.add(child.create());

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
      if (style?.width == 0) style = style?.copyWith(width: 100);
      if (style?.height == 0) style = style?.copyWith(height: 45);

      ///Add default decoration
      final defaultDecoaration = Decoration(
          backgroundColor:
              _currentTheme.buttonTheme.defaultStyle.backgroundColor,
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(raduis: Raduis.all(8)));

      ///if decoration is Undefined
      if (style!.decoration == null) {
        style = style?.copyWith(decoration: defaultDecoaration);
      }
    }
    element = (style ?? _currentTheme.buttonTheme.defaultStyle)
        .createStyle(element) as ButtonElement;

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
