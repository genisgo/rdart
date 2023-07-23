part of '../rviews/rview_bases.dart';

///Use Router interface to create et dynamic router for navigation
///set [routes] to add navigator route in your application.
/// the [home] is a default route
///
abstract class Router {
  final List<Route> routes;
  final List<Route>? activeRoute = [];
  late final Route? _home;
  Router({required this.routes, Route? home}) : _home = home;
  pop();
  push(String url);
  pushName(String name);
  nextRoute();
  Route currentRoute();
  _setDefaultRoute();
}

abstract class Route {
  String url;
  String? name;
  Relement Function() child;

  Route({required this.url, this.name, required this.child});
}
