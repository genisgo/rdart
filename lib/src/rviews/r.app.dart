part of 'rview_bases.dart';

///test Router
Router routerNavigation = Rrouter(routes: []);

class Rapplication extends Relement {
  final Relement? home;

  final DataTheme theme;

  final Router router;
  final bool bootstrap;

  Rapplication(
      {this.home,
      this.theme = Theme.defaultTheme,
      required this.router,
      this.bootstrap = true}) {
    _currentTheme = theme;

    if (router._home == null) {
      router._home = Rroute(url: "home", page: () => home!);

      router.routes.add(router._home!);
      router._setDefaultRoute();
    }

    routerNavigation = router;

    create();
    if (bootstrap) activeBootStrap();
  }

  Element? element = querySelector("body");

  @override
  Element create() {
    //Add default fontFamily
    element?.style
      ?..fontFamily = "-apple-system,system-ui,BlinkMacSystemFont,'Segoe UI',"
          "Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,"
          "'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol',sans-serif"
      ..height = "100%"
      ..width = "100%";

    element!.children.add(home!.create());
    return element!;
  }

  @override
  // TODO: implement getElement
  Element get getElement => element!;

  void activeBootStrap() {
    document.head?.children.addAll([
      ScriptElement()
        ..crossOrigin = "anonymous"
        ..integrity =
            "sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        ..src =
            "https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js",
      LinkElement()
        ..crossOrigin = "anonymous"
        ..href =
            "https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
        ..rel = "stylesheet"
        ..integrity =
            "sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9",
    ]);
  }
}
