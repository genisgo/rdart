part of 'rview_bases.dart';

///test Router
Router routerNavigation = Rrouter(routes: []);
late Rapplication app;

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
      : super(key: "_app") {
    _currentTheme = theme;
    app = this;
    if (router._home == null) {
      router._home = Rroute(url: "/", page: (data) => home!);

      router.routes.add(router._home!);
      // router._setDefaultRoute();
    }


    routerNavigation = router;

    create();

    //set current App
  }

  Element? element = Element.div();

  @override
  Element create() {
    element?.id = key!;

    //Add default fontFamily
    iniApp();

    ///Add Element
    element!.children.add(home!.create());
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
    document.body!.children.add(getEventListeners());
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
