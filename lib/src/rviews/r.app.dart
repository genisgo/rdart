part of 'rview_bases.dart';

///test Router
Router routerNavigation = Rrouter(routes: []);

class Rapplication extends Relement {
  final Relement? home;

  final DataTheme theme;

  final Router router;

  Rapplication(
      {this.home, this.theme = Theme.defaultTheme, required this.router}) {
    _currentTheme = theme;

    if (router._home == null) {
      router._home = Rroute(url: "home", page: () => home!);

      router.routes.add(router._home!);
      router._setDefaultRoute();
    }

    routerNavigation = router;

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
