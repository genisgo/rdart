part of 'rview_bases.dart';

///test Router
late final Router rnavigator;
late final Rapplication app;

class Rapplication extends Relement {
  Relement? home;

  final DataTheme theme;

  Router router;

  final bool bootstrap;

  Rapplication(
      {this.home,
      this.theme = Theme.defaultTheme,
      required this.router,
      this.bootstrap = true})
      : super(id: "_app") {
    _currentTheme = theme;

    //assert if router._homm && home is null
    if (router._home == null) {
      router = router.copyWith(
          home: Rroute(url: "/", page: (data) => home!), routes: router.routes);

     // router.routes.add(router._home!);
    }

    rnavigator = router;

    create();
    //cet emplacement est important car c'est apres la creation que
    // l'application doit etre affecter
    app = this;

    router._setDefaultRoute();

    //set current App
  }

  Element? element = Element.div();

  @override
  Element create() {
    element?.id = id!;

    //Add default fontFamily
    iniApp();

    var routePage =
        home?.create() ?? router._home!.page(router._home!.data).create();

    ///Add Element
    element!.children.add(routePage);

    document.body!.children.add(element!);

    return element!;
  }

  void iniApp() {
    //Add default fontFamily
    element?.style
      ?..fontFamily = "-apple-system,system-ui,BlinkMacSystemFont,'Segoe UI',"
          "Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif,"
          "'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol',sans-serif"
      ..height = "100%"
      ..width = "100%";

    ///Active bootstrap
    if (bootstrap) {
      //add css libray
      activeBootStrap();
      //add script libray
    }

    ///Add native Script
    document.head!.children.addAll(bootstrapScript());
    //document.body!.children.add(getEventListeners());
  }

  @override
  // TODO: implement getElement
  Element get getElement => element!;

  @override
  ondispose() {
    home?.ondispose();
    getElement.children.clear();
    return super.ondispose();
  }
}
