part of 'rview_bases.dart';

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
    //Add default fontFamily
    element?.style.fontFamily =
        "-apple-system,system-ui,BlinkMacSystemFont,'Segoe UI',"
        "Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,"
        "'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol',sans-serif";
    element!.children.add(home!.create());
    return element!;
  }

  @override
  // TODO: implement getElement
  Element get getElement => element!;
}
