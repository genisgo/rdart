import 'dart:async';
import 'dart:html';
import '../../themes.dart';
import '../themes/data_themes.dart';
part 'r.element.dart';
part 'rcolor.dart';
part 'border.dart';
part 'r.decoration.dart';
part 'rstyle.dart';
part 'edge.dart';
part 'r.app.dart';
part 'button.dart';
part 'enum.dart';
part '../router/r.router.dart';
part '../router/router.dart';
part 'bases/tabview.dart';
part 'bases/listview.dart';
part 'bases/combobox.dart';
///CurrentTheme qui doit etres initialiser dans [Rapplication]
late DataTheme _currentTheme;

/// La page d'application
class Page extends Relement {
  Relement? appBar;
  Relement? body;
  Relement? bottom;
  RStyle? bodyStyle;
  RStyle? appBarStyle;
  RStyle? bottomStyle;
  Color? backgroundColor;
  Page(
      {this.appBar,
      this.body,
      this.bottom,
      this.backgroundColor,
      this.appBarStyle,
      this.bodyStyle,
      this.bottomStyle});

  //Div element
  final _element = DivElement();
  @override
  Element create() {
    _element
      ..className = ClassName.page.name
      ..id = "page"
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.display = "flex"
      ..style.flexDirection = "column"
      ..style.backgroundColor =
          backgroundColor?.color ?? _currentTheme.backgroundColor.color;

    if (appBar != null) {
      var appbarElement = appBar!.create();
      if (appBarStyle != null) {
        appbarElement = appBarStyle!.createStyle(appbarElement);
      }
      _element.children.add(appbarElement);
    }
    if (body != null) {
      var bodyElment = body!.create();
      if (bodyStyle != null) bodyElment = bodyStyle!.createStyle(bodyElment);
      _element.children.add(bodyElment);
    }
    if (bottom != null) {
      var bottomElement = bottom!.create();
      if (bottomStyle != null) {
        bottomElement = bottomStyle!.createStyle(bottomElement);
      }
      _element.children.add(bottom!.create());
    }
    return _element;
  }

  @override
  Element get getElement => _element;
}

///Les container
class Container extends Relement {
  ///Definit la hauteur, si [width] est definis la hauter est en pixel (px)
  ///Lors ce que vous souhaitez une responsive utiliser [style] et definissez les dimensions
  double? width;

  ///Definit la hauteur, si [height] est definis la hauter est en pixel (px)
  ///Lors ce que vous souhaitez une responsive utiliser [style] et definissez les dimensions
  double? height;

  ///utiliez pour mettre un enfant (un est autre Relement)
  Relement? child;

  ///Utiliser pour definir les styles et decoration. [style] Permet par exemple la bordure, la couleur
  /* Exemple RStyle(margin: REdgetInset.all(10) */
  RStyle? style;
  Container({
    this.child,
    this.style,
    this.width,
    this.height,
  });
  var _div = Element.div();
  @override
  Element create() {
    ///if style is defind and [ height] , [width] is defind
    ///
    _div
      ..className = "container"
      ..style.display = "flex";

    if (style != null) {
      if (height != 0) style = style!.copyWith(height: height);
      if (width != 0) style = style!.copyWith(width: width);

      ///create the new style
      _div = style!.createStyle(_div);
    } else {
      _div
        ..style.width = width == null ? null : "${width}px"
        ..style.height = width == null ? null : "${height}px";
    }

    if (child != null) {
      _div.children.add(child!.create());
    }

    return _div;
  }

  @override
  Element get getElement => _div;
}

//AppBar : la barre d'application

class AppBar extends Relement {
  final Relement? title;
  final Relement? backup;
  final int heigth;
  final List<Relement> actions;
  final AlignVertical alginVertical;
  final String text;
  final BoxShadow boxShadow;
  final RelementCallBack? onPress;

  Color? backgroundColor;
  AppBar(
      {this.title,
      this.alginVertical = AlignVertical.center,
      this.text = "",
      this.boxShadow = const BoxShadow(),
      this.backup,
      this.actions = const [],
      this.backgroundColor,
      this.heigth = 45,
      this.onPress});

  //balise
  var div = Element.nav();
  @override
  Element create() {
    div
      ..id = "appbar"
      ..style.height = "${heigth}px"
      ..style.width = "100%"
      ..style.padding = "4px 0px 0px 0px"
      ..style.display = "inline-flex"
      ..style.alignContent = "center"
      ..style.boxShadow = boxShadow.toString()
      ..style.backgroundColor = backgroundColor?.color ??
          _currentTheme.appBarStyle.backgroundColor?.color;

    //initilized childreen
    div.children.clear();

    if (onPress != null) {
      div.onClick.listen((event) {
        onPress!(this);
      });
    }

    if (backup != null) {
      div.children.add(Element.div()
        ..id = "backup"
        ..style.display = "inline-flex"
        ..style.alignItems = alginVertical.value
        ..style.padding = "10px"
        ..children.add(backup!.create())
        ..style.width = "10%");
    }
    if (title != null) {
      div.children.add(Element.div()
        ..style.width = "40%"
        ..style.padding = "10px"
        ..style.display = "inline-flex"
        ..children.add(title!.create())
        ..id = "titre");
    }

    if (text.isNotEmpty) {
      div.innerText = text;
    }

    if (actions.isNotEmpty) {
      final contentAction = Element.div()
        ..id = "titreAction"
        ..style.display = "flex"
        ..style.justifyContent = ""
        ..style.width = "50%";
      contentAction.children.addAll(actions.map((e) => e.create()));

      div.children.add(contentAction);
    }
    querySelector("body")!.children.add(div);

    return div;
  }

  @override
  Element get getElement => div;
}

//Text Element

class Text extends Relement {
  String text;
  Color color;
  RStyle? style;
  final int size;
  Text(this.text, {this.color = Colors.Black, this.size = 14, this.style});
  //Div element
  final divele = Element.div();
  @override
  Element create() {
    divele
      ..innerText = text
      ..style.color = color.color
      ..style.fontSize = "${size}px";
    return style?.createStyle(divele) ?? divele;
  }

  @override
  // TODO: implement getElement
  Element get getElement => divele;
}

//Icon
class Ricon extends Relement {
  const Ricon(
      {this.unicode = "\u2003", this.color = Colors.White, this.size = 24})
      : super();
  final int size;
  final String unicode;
  final Color color;
  @override
  Element create() {
    return Element.div()
      ..text = unicode
      ..className = "icon"
      ..style.color = color.color
      ..style.fontSize = "${size}px"
      ..id = unicode;
  }

  @override
  Element get getElement => querySelector("#$unicode")!;
}

enum Ricons {
  ///  [\u2665]
  coeur("\u2665"),
  cotification("\u2740"),
  coeurSymbole("\u2765");

  const Ricons(this.iconCode);
  final String iconCode;
  Ricon getIcon({int size = 24, Color color = Colors.White}) =>
      Ricon(color: color, size: size, unicode: iconCode);
}

//Row Element

class Row extends Relement {
  List<Relement> children;
  AlignHorizontal mainAxisAlignment;
  AlignVertical crossAxisAlignment;
  Row(
      {this.children = const [],
      this.crossAxisAlignment = AlignVertical.top,
      this.mainAxisAlignment = AlignHorizontal.left});
  final _div = Element.div();
  @override
  Element create() {
    _div
      ..className = "row"
      ..style.display = "flex"
      ..style.float = "left";
    _div.children.addAll(children.map((e) => e.create()));
    return RStyle(
            alignHorizontal: mainAxisAlignment,
            alignmentVertical: crossAxisAlignment,
            expandWidth: true)
        .createStyle(_div);
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}

///Colum Element

class Column extends Relement {
  ///Les elements de la colone
  List<Relement> children;

  ///Le mainAxisAlignment est l'alignement qui definis la disposition des
  ///elements de façon horizontale par defaut les element sondisposer a gauche
  ///la valeur par defaut est une list vide *const []*
  AlignHorizontal mainAxisAlignment;
  bool mainAxisExpand;
  bool crossAxisExpand;

  /// [crossAxisAlignment] est l'alignement verticale des elements par defaut
  /// sa valeur est [AlignmentVertical.top]
  AlignVertical crossAxisAlignment;
  Column(
      {this.children = const [],
      this.mainAxisExpand = false,
      this.crossAxisExpand = true,
      this.crossAxisAlignment = AlignVertical.top,
      this.mainAxisAlignment = AlignHorizontal.left});
  final _div = Element.div();
  @override
  Element create() {
    _div
      ..className = "column"
      ..style.display = "flex"
      ..style.flexDirection = "column";

    _div.children.addAll(children.map((e) => e.create()));
    return RStyle(
            alignHorizontal: mainAxisAlignment,
            expandWidth: crossAxisExpand,
            expandHeight: mainAxisExpand,
            backgroundColor: Colors.none,
            alignmentVertical: crossAxisAlignment)
        .createStyle(_div);
  }

  @override
  Element get getElement => _div;
}

class RImage extends Relement {
  String url;

  RStyle? style;

  RImage({
    this.url = "",
    this.style,
  });

  var _image = Element.img();
  @override
  Element create() {
    _image.attributes.addAll({"src": url});
    if (style != null) {
      _image = style!.createStyle(_image);
    }
    return _image;
  }

  @override
  Element get getElement => _image;
}

//InputText

class TextField extends Relement {
  RStyle? style;
  String hinterText;
  Color focusColor;
  bool obscure;
  RStyle? onFocusStyle;
  Function(String? value)? onChange;
  TextField(
      {this.onChange,
      this.style,
      this.hinterText = "",
      this.onFocusStyle,
      this.obscure = false,
      this.focusColor = Colors.blue});
  var _div = TextInputElement();
  @override
  Element create() {
    _div.placeholder = hinterText;
    _div.className = "textfeild";

//Style
    style ??= RStyle(
        padding: REdgetInset.all(_currentTheme.defaultPadding),
        decoration: Decoration(
            border: Rborder.all(
                raduis: Raduis.all(4),
                side:
                    BorderSide(color: Colors.gray, style: BorderStyle.solid))));

    _div = style!.createStyle(_div) as TextInputElement;

    ///Events
    if (onChange != null) {
      _div.onInput.listen((event) {
        onChange!(_div.value);
      });
    }
    //
    _div.inputMode;

    ///onFocus
    _div.onFocus.listen((event) {
      _div.style.outline = "none";
      if (onFocusStyle == null) {
        _div.style.borderColor = focusColor.color;
      } else {
        onFocusStyle?.createStyle(_div);
      }
    });

    _div.addEventListener("focusout", (event) {
      style!.createStyle(_div);
    });
    return _div;
  }

  @override
  Element get getElement => _div;
}
//divider

class Divider extends Relement {
  double height;
  double? width;
  Color color;
  static int _idgenerate = 0;
  Divider({this.height = 1, this.color = Colors.gray, this.width}) {
    _idgenerate++;
  }
  final Element _div = Element.div();
  @override
  Element create() {
    _div
      ..id = "divider$_idgenerate"
      ..style.backgroundColor = color.color
      ..style.width = width == null ? "-webkit-fill-available" : "${width}px"
      ..style.height = "${height}px";

    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}

class SizeBox extends Relement {
  int? height;
  int? width;
  bool modeRatio;
  AlignHorizontal alignHorizontal;
  AlignVertical alignVertical;
  final Relement? child;
  static int _idgenerate = 0;
  SizeBox(
      {this.height,
      this.width,
      this.child,
      this.modeRatio = false,
      this.alignHorizontal = AlignHorizontal.center,
      this.alignVertical = AlignVertical.center}) {
    _idgenerate++;
  }
  final Element _div = Element.div();
  @override
  Element create() {
    if (child != null) _div.children.add(child!.create());

    return _div
      ..id = "sizebox$_idgenerate"
      ..style.justifyContent = alignHorizontal.value
      ..style.alignItems = alignVertical.value
      ..style.display = "flex"
      ..style.width = width.px
      ..style.height = height.px;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}

