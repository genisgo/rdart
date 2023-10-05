part of 'rview_bases.dart';

enum BtnType { button, menu, reset, submit }

class RButton extends Relement {
  RStyle? style;
  bool disable;
  bool singleBootStrap;
  Color? onMouseEnterColor;
  Color? onMouseDownColor;
  BtnType? type;
  Relement? child;
  Function(Relement relement)? onHover;
  Function(Relement relement)? onPress;
  RButton(
      {this.onPress,
      this.type,
      this.singleBootStrap = false,
      this.style,
      this.onHover,
      this.onMouseDownColor,
      this.onMouseEnterColor,
      this.child,
      this.disable = false});
  var element = ButtonElement();
  List<StreamSubscription<MouseEvent>?> events = [];

  @override
  Element create() {
    ///Crete child
    ///
    // ondispon
    ondispose();
    child?.create();

    /// set animation for child on [onMouseEnter] event.
    if (onMouseEnterColor != null) {
      var sub = child?.getElement.onMouseEnter.listen((event) {
        element.style.backgroundColor = onMouseEnterColor?.color;
      });
      //events.add(sub);
    }

    ///ajoute un listerner d'evenement de tipe quiter le button
    if (onMouseDownColor != null) {
      var sub = child?.getElement.onMouseOut.listen((event) {
        element.style.backgroundColor = style?.backgroundColor?.color;
      });
      events.add(sub);
    }
    if (!singleBootStrap) {
      ///ajout de nom de classe
      element.id = "btn_defaut";

      element.className = "btn";
    }

    if (child != null) element.children.add(child!.getElement);

    if (type != null) element.type = type!.name;

    ///Set default theme
    style ??= _currentTheme.buttonTheme.defaultStyle;

    ///Add event if [onMouseEnterColor] is not null or [onMouseDownColor] is not null
    // if (onMouseEnterColor != null || onMouseDownColor != null) {
    //   _onMouserEnterAnimation();
    // }

    ///Ajout des evenements
    if (onHover != null) {
      element.onMouseUp.listen((event) {
        onHover!(this);
      });
    }
    //Evement Click
    if (onPress != null) {
      var sub = element.onClick.listen((event) {
        onPress!(this);
      });
      //events.add(sub);
    }
    // mouseEventAnimation(element);

    //bootstrap no create default style
    // if (singleBootStrap) return element;

    ///add de style
    element = style?.createStyle(element) as ButtonElement;

    return element;
  }

  // void _onMouserEnterAnimation() {
  //   element.onMouseEnter.listen((event) {
  //     if (onMouseEnterColor != null) {
  //       element.style.backgroundColor = onMouseEnterColor?.color;
  //     }
  //   });

  //   element.onMouseOut.listen((event) {
  //     element.style.backgroundColor = style?.backgroundColor?.color;
  //   });
  // }

  @override
  // TODO: implement getElement
  Element get getElement => element;

  // void mouseEventAnimation(Element element) {
  //   element.onMouseDown.listen((event) {
  //     element.style.opacity = "0.9";
  //   });
  //   element.onMouseUp.listen((event) {
  //     element.style.opacity = "1";
  //   });
  // }
  @override
  ondispose() {
    // events.map((e) => e?.cancel());
    return super.ondispose();
  }
}
