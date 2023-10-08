part of '../rviews/rview_bases.dart';

///Use Router interface to create et dynamic router for navigation
///set [routes] to add navigator route in your application.
/// the [home] is a default route
///
abstract class Router {
  final List<Route> routes;
  final List<Route> activeRoute = [];
  Route? _home;
  Router({required this.routes, Route? home}) : _home = home;
  pop();
  push(String url, {data});
  //pushName(String name, {data});
  nextRoute();
  Route currentRoute();
  _setDefaultRoute();
}

abstract class Route {
  String url;
  List<Route> routes;
  var data;
  Relement Function(dynamic data) page;
  String get absolutePath;
   Route? parent; 
   Route? contains(String url);
  Route(
      {required this.url,
      required this.page,
      this.data,
      this.routes = const []});
}
