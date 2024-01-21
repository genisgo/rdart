import 'dart:async';
import 'dart:developer';
import 'dart:html';
import 'package:rdart/src/bootstrap/js/bootrap.js.dart';
import '../../themes.dart';
import '../themes/data_themes.dart';
import '../../bootstrap.dart';
import '../utils/convert.dart';
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
part '../router/go.router.dart';
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
  Color? background;
  bool singleBootStrap;
  List<Bootstrap> bootstrap;
  Page(
      {this.appBar,
      this.body,
      this.bottom,
      this.background,
      this.appBarStyle,
      this.bodyStyle,
      super.id,
      this.singleBootStrap = false,
      this.bootstrap = const [],
      this.bottomStyle});

  //Div element
  var _element = DivElement();
  @override
  Element create() {
    _element = DivElement();
    _element.className = "page ${bootstrap.join(" ")}";
    _element.id = id ?? "page $generateId";
    if (!singleBootStrap) {
      _element
        ..className = ClassName.page.name
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.display = "grid"
        //..style.flexDirection = "column"
        ..style.background =
            background?.color ?? _currentTheme.background.color;
    }
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
  @override
  dispose() {
    appBar?.dispose();
    body?.dispose();
    bottom?.dispose();
    return super.dispose();
  }
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
  bool singleBootStrap;

  ///DataSet
  Map<String, String>? dataset;
  Container({
    this.child,
    this.style,
    this.width,
    this.height,
    super.id,
    this.singleBootStrap = false,
  });
  var _div = Element.div();
  @override
  Element create() {
    ///if style is defind and [ height] , [width] is defind
    ///
    if (id != null) _div.id = id!;
    if (!singleBootStrap) _div.className = "container";
    if (style != null) {
      if (height != 0) style = style!.copyWith(height: height);
      if (width != 0) style = style!.copyWith(width: width);

      ///create the new style
      _div = style!.createStyle(_div);
    } else {
      _div
        ..style.width = width == null ? null : "${width}px"
        ..style.height = height == null ? null : "${height}px";
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

  Color? background;
  AppBar(
      {this.title,
      this.alginVertical = AlignVertical.center,
      this.text = "",
      this.boxShadow = const BoxShadow(),
      this.backup,
      this.actions = const [],
      super.id,
      this.background,
      this.heigth = 45,
      this.onPress});

  //balise
  var div = Element.nav();
  @override
  Element create() {
    div
      ..id = id ?? "appbar"
      ..style.height = "${heigth}px"
      ..style.width = "100%"
      ..style.padding = "4px 0px 0px 0px"
      ..style.display = "inline-flex"
      ..style.alignContent = "center"
      ..style.boxShadow = boxShadow.toString()
      ..style.background =
          background?.color ?? _currentTheme.appBarStyle.background?.color;

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
  List<Bootstrap> bootstrap;
  String text;
  Color color;
  RStyle? style;
  final double size;
  final bool singleBootStrap;
  Text(this.text,
      {this.color = Colors.Black,
      this.size = 14,
      this.bootstrap = const [],
      this.style,
      this.singleBootStrap = false,
      super.id});
  //Div element
  final div = Element.div();
  @override
  Element create() {
    div.innerText = text;

    if (!singleBootStrap) {
      div
        ..style.color = color.color
        ..style.fontSize = "${size}px";
    }
    //set bootstrap
    div.className = " ${bootstrap.join(" ")}";
    return style?.createStyle(div) ?? div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => div;
}

//Icon
class Ricon extends Relement {
  const Ricon(
      {this.unicode = "\u2003",
      this.color = Colors.White,
      this.size = 24,
      super.id})
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
   // dispose(); 
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
  // TODO: implement getElement
  Element get getElement => _div;
 // @override
  // dispose() {
  //   getElement.children.clear();
  //   return super.dispose();
  // }
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

class RImage extends Relement {
  String url;

  RStyle? style;

  RImage({this.url = "", this.style, super.id});

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
      super.id,
      this.hinterText = "",
      this.onFocusStyle,
      this.obscure = false,
      this.focusColor = Colors.blue});
  var _div = TextInputElement();
  @override
  Element create() {
    _div.placeholder = hinterText;
    _div.className = "textfeild";
    //Set id
    if (id != null) _div.id = id!;
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
  Divider({this.height = 1, this.color = Colors.gray, this.width, super.id}) {
    _idgenerate++;
  }
  final Element _div = Element.hr();
  @override
  Element create() {
    //Set id
    _div
      ..id = id ?? "divider$_idgenerate"
      ..style.color = color.color
      ..style.width = width == null ? "-webkit-fill-available" : "${width}px"
      ..style.height = "${height}px";

    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}

class SizeBox extends Relement {
  double? height;
  double? width;
  bool modeRatio;
  List<Bootstrap> bootstrap;
  AlignHorizontal alignHorizontal;
  AlignVertical alignVertical;
  final Relement? child;
  static int _idgenerate = 0;
  SizeBox(
      {this.height,
      this.width,
      this.child,
      super.id,
      this.bootstrap = const [],
      this.modeRatio = false,
      this.alignHorizontal = AlignHorizontal.center,
      this.alignVertical = AlignVertical.center}) {
    _idgenerate++;
  }
  final Element _div = Element.div();
  @override
  Element create() {
    if (child != null) _div.children.add(child!.create());

    _div.id = id ?? "sizebox$_idgenerate";
    _div.className = bootstrap.join(" ");
    if (bootstrap.isEmpty) {
      _div
        ..style.justifyContent = alignHorizontal.value
        ..style.alignItems = alignVertical.value
        ..style.display = "flex"
        ..style.width = width.px
        ..style.height = height.px;
    }
    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}

class BsElement extends BootStrapComponent {
  final Relement? child;
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

class Link extends Relement {
  String? link;
  String label;
  Relement? child;
  bool active;
  List<Bootstrap> bootstrap;
  Function()? click;
  Link(
      {this.click,
      this.active = true,
      this.link,
      super.id,
      this.label = "",
      this.child,
      this.bootstrap = const []});
  final _a = Element.a();
  @override
  Element create() {
    //Set id
    if (id != null) _a.id = id!;
    if (child != null) {
      _a.children.add(child!.create());
    } else {
      _a.innerHtml = label;
    }
    // active
    //Set bootstrap
    _a.className = bootstrap.join(" ");

    _a.attributes.addAll({"href": link ?? ""});
    //onPress
    _a.onClick.listen((event) {
      click?.call();
      if (link == null) event.preventDefault();
    });
    return _a;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _a;
}

class DataListItem extends Relement {
  String data;
  String value;
  DataListItem({required this.data, required this.value, super.id});
  var option = OptionElement();
  @override
  Element create() {
    //Set id
    if (id != null) option.id = id!;
    option.value = value;
    return option;
  }

  @override
  // TODO: implement getElement
  Element get getElement => option;
}

class DataList extends Relement {
  List<DataListItem> options;
  DataList({required this.options, super.id});
  var datalist = DataListElement();
  @override
  Element create() {
    ///Set id
    if (id != null) datalist.id = id!;
    datalist.options?.addAll(options.map((e) => e.create()).toList());
    return datalist;
  }

  @override
  // TODO: implement getElement
  Element get getElement => datalist;
}

///////////////////RVIEW STYLE/////////////////////////////
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

class HtmlInnert extends Relement {
  String _html;
  HtmlInnert({required String html, super.id}) : _html = html;

  String get gethtml => _html;

  set html(String value) {
    _html = value;
  }

  final _element = Element.div();
  @override
  Element create() {
    final parse = Element.div();
    final cleanHtml = StringBuffer(decodeHtmlEntities(_html)).toString();
    parse.innerHtml = cleanHtml;
    _element.children.add(parse);

    return _element;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _element;
}