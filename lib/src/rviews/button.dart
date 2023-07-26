part of 'rview_bases.dart';

class RButton extends Relement {
  RStyle? style;
  bool disable;
  Color? onMouseEnterColor;
  Color? onMouseDownColor;

  Relement child;
  Function(Relement relement)? onHover;
  Function(Relement relement)? onPress;
  RButton(
      {this.onPress,
      this.style,
      this.onHover,
      this.onMouseDownColor,
      this.onMouseEnterColor,
      required this.child,
      this.disable = false});
  var element = ButtonElement();
  @override
  Element create() {
    ///Crete child
    child.create();

    /// set animation for child on [onMouseEnter] event.
    if (onMouseEnterColor != null) {
      print("isnonte null");
      child.getElement.onMouseEnter.listen((event) {
        element.style.backgroundColor = onMouseEnterColor?.color;
      });
    }

    ///ajoute un listerner d'evenement de tipe quiter le button
    if (onMouseDownColor != null) {
      child.getElement.onMouseOut.listen((event) {
        element.style.backgroundColor = style?.backgroundColor?.color;
      });
    }

    element.children.add(child.getElement);

    ///ajout de nom de classe
    element.id = "btn_defaut";
    element.className = "rbtn";

    ///Set default theme
    style ??= _currentTheme.buttonTheme.defaultStyle;

    ///Add event if [onMouseEnterColor] is not null or [onMouseDownColor] is not null
    if (onMouseEnterColor != null || onMouseDownColor != null) {
      _onMouserEnterAnimation();
    }

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
    element = style?.createStyle(element) as ButtonElement;

    return element;
  }

  void _onMouserEnterAnimation() {
    element.onMouseEnter.listen((event) {
      if (onMouseEnterColor != null) {
        element.style.backgroundColor = onMouseEnterColor?.color;
      }
    });

    element.onMouseOut.listen((event) {
      element.style.backgroundColor = style?.backgroundColor?.color;
    });
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
