part of '../rview_bases.dart';

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