part of '../rdart_base.dart';
class Rapplication extends Relement {
  Relement? home;
  Rapplication({this.home}) {
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
