part of '../rviews/rview_bases.dart';

class GoRouter extends Router {
  GoRouter({required super.routes}) {
    window.onPopState.listen((event) {
      var url = window.location.pathname;

      containSet(url!, "", true);
      print(activeRoute);
      event.preventDefault();
      event.stopPropagation();
      // routes.singleWhere((element) => element.url==event.path);
    });
  }

  @override
  _setDefaultRoute() {
    _setRoute(_home!);
    //activeRoute.add(_home!);
  }

  void _setRoute(Route route, [data, isHistory = false]) {
    if (!isHistory) {
      window.history.pushState(null, "", route.absolutePath);
      route.data = data;
      activeRoute.add(route);
    }

    iniEvent();
    app.getElement.children.clear();
    //iniApp
    //app.iniApp();
    app.getElement.children.add(route.page(route.data).create());
  }

  @override
  Route currentRoute() {
    // _setRoute(activeRoute.last);
    //print(activeRoute.last);
    return activeRoute.last;
  }

  @override
  nextRoute() {
    // TODO: implement nextRoute
    throw UnimplementedError();
  }

  @override
  pop() {
    activeRoute.removeLast();
    containSet(activeRoute.last.url, activeRoute.last.data);
  }

  @override
  push(String url, {data}) {
    containSet(url, data);
  }

  void containSet(String url, data, [bool isHistory = false]) {
    //add /
    if (url[0] != "/") url = "/$url";

    if (isHistory) {
      //  hs = activeRoute.singleWhere(
      //       (element) => element.absolutePath == newRoute!.absolutePath);
      //  print("history ${hs.data}");

      activeRoute.removeLast();
      _setRoute(activeRoute.last, null, isHistory);

      return;
    }
    print(activeRoute);
    Route? newRoute;
    for (var route in routes) {
      newRoute = route.contains(url);

      if (newRoute != null) {
        // Route hs;
        _setRoute(newRoute, data, isHistory);
        break;
      }
    }
    //if routne no exist
    if (newRoute == null) _setDefaultRoute();
  }
}
