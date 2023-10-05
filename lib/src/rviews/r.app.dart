part of 'rview_bases.dart';

///test Router
Router routerNavigation = Rrouter(routes: []);
String appID ="_rapp"; 
class Rapplication extends Relement {
  final Relement? home;

  final DataTheme theme;

  final Router router;

  final bool bootstrap;

  Rapplication(
      {this.home,
      this.theme = Theme.defaultTheme,
      required this.router,
      
      this.bootstrap = true})
      : super(key: appID) {
    _currentTheme = theme;

    if (router._home == null) {
      router._home = Rroute(url: "/", page: (data) => home!);

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
    element?.id = key!;

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
      LinkElement()
        ..crossOrigin = "anonymous"
        ..href =
            "https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
        ..rel = "stylesheet"
        ..integrity =
            "sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9",
    ]);
    // document.body?.children.add(
    //   ScriptElement()
    //     ..crossOrigin = "anonymous"
    //     ..integrity =
    //         "sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
    //     ..src =
    //         "https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js",
    // );
  }
}
