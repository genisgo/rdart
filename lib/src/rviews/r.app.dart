part of 'rview_bases.dart';

///test Router
late final Router rnavigator;
late final Rapplication _app;

final class Rapplication extends Relement {
  final Relement? home;

  final DataTheme theme;

  Router router;

  final bool bootstrap;
  //Usable
  List<Usable> _usables = [];
  Rapplication(
      {this.home,
      this.theme = Theme.defaultTheme,
      required this.router,
      this.bootstrap = true})
      : super(id: "_app") {
    //Up init for usable module
    upInitUsable();
    _currentTheme = theme;

    //assert if router._homm && home is null
    if (router._home == null) {
      router = router.copyWith(
          home: Rroute(url: "/", page: (data) => home!), routes: router.routes);

      // router.routes.add(router._home!);
    }

    rnavigator = router;
    _app = this;
    create();
    executeUsable();
    //cet emplacement est important car c'est apres la creation que
    // l'application doit etre affecter

    router._setDefaultRoute();

    //set current App
  }

  Element? element = Element.div();

  @override
  Element create() {
    element?.id = id!;

    //Add default fontFamily
    _iniApp();

    var routePage =
        home?.create() ?? router._home!.page(router._home!.data).create();

    ///Add Element
    element!.children.add(routePage);

    document.body!.children.add(element!);

    return element!;
  }

  void _iniApp() {
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

  }

  @override
  // TODO: implement getElement
  Element get getElement => element!;

  @override
  dispose() {
    home?.dispose();
    getElement.children.clear();
    return super.dispose();
  }

  Future use<T extends Usable>(T use) async {
    // _usables.add(use);
    use.execute();
  }

  void upInitUsable() {
    for (var element in _usables) {
      element.preoloaded();
    }
  }

  void executeUsable() {
    for (var element in _usables) {
      element.execute();
    }
  }

  //
  // void _iniUsables() {
  //   // for (var use in _usables) {

  //   // }
  // }
}

abstract class Usable {
  void preoloaded();
  Future<void> execute();
}
