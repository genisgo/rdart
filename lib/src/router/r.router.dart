
part of '../rviews/rview_bases.dart';

class Rrouter extends Router {
   Rrouter({required super.routes});
  final Element _app = querySelector("body")!;

  @override
  Route currentRoute() {
    // TODO: implement currentRoute
    throw UnimplementedError();
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

  @override
  push(String url) {
    var rview = routes.singleWhere((element) => element.url == url).child!();
    _app.children.clear();
    _app.children.add(rview.create());
  }

  @override
  pushName(String name) {
    // TODO: implement pushName
    throw UnimplementedError();
  }
}
