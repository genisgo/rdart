part of '../rviews/rview_bases.dart';

class GoRouter extends Router {
  GoRouter({required super.routes}) {
    var oldState;
    window.onPopState.listen((event) {
      //  if (oldState == event.state) return;
      oldState = event.state;
      window.history.state;
      var url = window.location.pathname;
      var data = "";
      print("state ${window.history.state} $url");
      if (url == "/") containSet(url!, data);

      event.preventDefault();
      event.stopPropagation();
      // routes.singleWhere((element) => element.url==event.path);
    });
  }

  @override
  _setDefaultRoute() {
    _setRoute(_home);
  }

  void _setRoute(Route? route, [data]) {
    window.history.pushState(route?.data, "", route?.absolutePath);
    //activeRoute.add(route!);
    var app = document.getElementById(appID);
    app?.children.clear();
    app?.children.add(route!.page(data).create());
  }

  @override
  Route currentRoute() {
    // _setRoute(activeRoute.last);
    print(activeRoute.last);
    return activeRoute.last;
  }

  @override
  nextRoute() {
    // TODO: implement nextRoute
    throw UnimplementedError();
  }

  @override
  pop() {
    // TODO: implement pop
    throw UnimplementedError();
  }

  int couter = 0;
  @override
  push(String url, {data}) {
    print(url);
    //_setRoute(routes.singleWhere((element) => element.url == url));
    //print(routes);
    print("push $couter");
    containSet(url, data);
  }

  void containSet(String url, data) {
    if (url[0] != "/") url = "/$url";
    int counter = 0;
    for (var route in routes) {
      var res = route.contains(url);
      print(route.routes);
      if (res != null) {
        counter++;
        print("pushRes ${res.absolutePath} ${route.url} $counter $data");
        _setRoute(res, data);
        break;
      }
    }
  }

  @override
  pushName(String name, {data}) {
    // TODO: implement pushName
    throw UnimplementedError();
  }
}
