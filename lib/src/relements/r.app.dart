part of '../rdart_base.dart';

class Rapplication extends Relement {
  Relement? home;
  DataTheme theme;
  Rapplication({this.home, this.theme = Theme.defaultTheme}) {
    _currentTheme = theme;
    create();
  }

  Element? element = querySelector("body");
  @override
  Element create() {
    element!.children.add(home!.create());
    return element!;
  }

  @override
  // TODO: implement getElement
  Element get getElement => element!;
}
