part of '../rviews/rview_bases.dart';
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
