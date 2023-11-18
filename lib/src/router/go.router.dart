part of '../rviews/rview_bases.dart';

class GoRouter extends Router {
  String? homPath;
  GoRouter({required super.routes, Route? home}) : super(home: home) {
    window.onPopState.listen((event) {
      var url = window.location.pathname;

      containSet(url!, null, true);

      event.preventDefault();
      event.stopPropagation();
    });
  }

  @override
  _setDefaultRoute() {
    window.history.pushState(null, "", _home!.absolutePath);
    activeRoute.add(_home!);
    routes.add(_home!);
    //Le probleme si nous essayons d'utiliser directement home
    // sa valeur a un moment donnée declanche null sécurité sans
    // et pourtant les valeur sont presente.
    homPath ??= _home!.absolutePath;
    //_setRoute(_home!);
    // activeRoute.add(_home!);
  }

  void _setRoute(Route route, [data, isHistory = false]) {
    if (!isHistory) {
      window.history.pushState(null, "", route.absolutePath);
      route.data = data;
      activeRoute.add(route);
    }
    _app.getElement.children.clear();

    if (route.url == "/") {
      _app.getElement.children.add(route.page(data).create());

      return;
    }

    var routePage = route.page(route.data).create();
    _app.getElement.children.add(routePage);
  }

  @override
  Route currentRoute() {
    return activeRoute.last;
  }

  @override
  pop() {
    if (activeRoute.length > 1) {
      activeRoute.removeLast();
      _setRoute(activeRoute.last, null, true);
    }
  }

  @override
  push(String url, {data}) {
    containSet(url, data);
  }

  void containSet(String url, data, [bool isHistory = false]) {
    bool isPrevious = isPreviousPop(url);

    //add /
    if (url[0] != "/") url = "/$url";

    if (isHistory && isPrevious) {
      pop();
      return;
    }

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
    //  if (newRoute == null) _setDefaultRoute();
  }

  bool isPreviousPop(String url) {
    return activeRoute
        .map((e) => e.absolutePath)
        .where((element) => element == url)
        .isNotEmpty;
  }

  @override
  Router copyWith({List<Route>? routes, Route? home}) {
    return GoRouter(routes: routes ?? this.routes, home: home ?? _home);
  }
}
