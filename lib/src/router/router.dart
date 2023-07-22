///Use Router interface to create et dynamic router for navigation
///set [routes] to add navigator route in y
abstract class Router {
  List<Route> routes;
  Route? home;
  Router({required this.routes, this.home});
  pop();
  push(String url);
  pushName(String name);
  nextRoute();
}

abstract class Route {
  String url;
  String name;
  Route({required this.url, required this.name});
}
