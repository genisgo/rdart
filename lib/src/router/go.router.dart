part of '../rviews/rview_bases.dart';

class GoRouter extends Router {
  GoRouter({required super.routes,Route? home}):super(home: home) {
    window.onPopState.listen((event) {
      var url = window.location.pathname;

      containSet(url!, null, true);
      print(activeRoute);
      event.preventDefault();
      event.stopPropagation();
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

    app.getElement.children.add(route.page(route.data).create());
  }

  @override
  Route currentRoute() {
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
  
  @override
  Router copyWith({List<Route>? routes, Route? home}) {
    return GoRouter(routes: routes??this.routes,home: home??_home);
  }
}
