part of '../rviews/rview_bases.dart';

class Rrouter extends Router {
  Rrouter({required super.routes, super.home}) {
    _setDefaultRoute();
  }

  final Element _app = querySelector("body")!;
  Route? _currentRoute;
  final List<Route> _lastRoute = [];

  @override
  Route currentRoute() {
    return _currentRoute!;
  }

  @override
  nextRoute() {
    // TODO: implement nextRoute
    throw UnimplementedError();
  }

  @override
  pop() {
    int previousIndex = _lastRoute.indexOf(currentRoute()) - 1;
    print(previousIndex);
    if (previousIndex >= 0) {
      var last = _lastRoute.elementAt(0);
      print(last.url);

      _setRoute(url: last.url);
    }
  }

  @override
  push(String url) {
    _setRoute(url: url);
  }

  void _setRoute({String url = "", String name = ""}) {
    var route = routes
        .singleWhere((element) => element.url == url || element.name == name);
    _app.children.clear();
    _app.children.add(route.page().create());
    _currentRoute = route;
    window.onBeforeUnload.listen((event) {
      Uri url = Uri.parse(window.location.href);
    var query =url.queryParametersAll;
    print(query["url"]);
     });
    window.location.assign("/?url=$name");
    _lastRoute.add(_currentRoute!);
     
  
   
  }

  @override
  pushName(String name) {
    _setRoute(name: name);
  }

  @override
  _setDefaultRoute() {
    ///Insertion of home page is first page
    if (_home != null) _lastRoute.add(_home!);
    if (_lastRoute.isNotEmpty) _currentRoute = _lastRoute.first;
  }
}

//route
class Rroute extends Route {
  Rroute({required super.url, super.name, required super.page});
}
