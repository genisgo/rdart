part of '../rview_bases.dart';

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