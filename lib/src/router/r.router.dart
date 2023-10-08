part of '../rviews/rview_bases.dart';

// class Rrouter extends Router {
//   Rrouter({required super.routes, super.home}) {
//     _setDefaultRoute();
//   }

//   final Element _app = querySelector("body")!;

//   Route? _currentRoute;

//   final List<Route> _lastRoute = [];

//   @override
//   Route currentRoute() {
//     return _currentRoute!;
//   }

//   @override
//   nextRoute() {
//     // TODO: implement nextRoute
//     throw UnimplementedError();
//   }

//   @override
//   pop() {
//     int previousIndex = _lastRoute.indexOf(currentRoute()) - 1;

//     print(previousIndex);

//     if (previousIndex >= 0) {
//       var last = _lastRoute.elementAt(0);

//       print(last.url);

//       _setRoute(url: last.url);
//     }
//   }

//   @override
//   push(String url, {data}) {
//     _setRoute(url: url);
//   }

//   void _setRoute({String url = ""}) {
//     var route = routes
//         .singleWhere((element) => element.url == url );
//     _app.children.clear();
//     _app.children.add(route.page(null).create());
//     _currentRoute = route;

//     _lastRoute.add(_currentRoute!);
//   }

//   @override
//   _setDefaultRoute() {
//     ///Insertion of home page is first page
//     if (_home != null) _lastRoute.add(_home!);
//     if (_lastRoute.isNotEmpty) _currentRoute = _lastRoute.first;
//   }
  
//   @override
//   Router copyWith({List<Route>? routes, Route? home}) {
//     // TODO: implement copyWith
//     throw UnimplementedError();
//   }
// }

//route
class Rroute extends Route {
  Rroute(
      {required super.url,
      required super.page,
      super.data,
      super.routes}) {
    _setPartent();
  }

  void _setPartent() {
    for (var element in routes) {
      element.parent = this;
    }
  }

  @override
  // TODO: implement absolueUrl
  String get absolutePath {
    String pathname = url;
    bool slashNoSet = url[0] != "/";
    if (slashNoSet) {
      pathname = "/$url";
    }
    //su
    if (parent != null) {
      pathname = parent!.absolutePath + pathname;
    }

    return pathname;
  }

  @override
  Route? contains(String url) {
    String path = absolutePath;
    if (path == url) return this;
    for (var route in routes) {
      var con = route.contains(path + url);
      if (con != null) return con;
    }
    return null;
  }


}
