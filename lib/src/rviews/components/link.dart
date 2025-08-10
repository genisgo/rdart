part of '../rview_bases.dart';

class Link extends Relement {
  String? link;
  String label;
  Relement? child;
  bool active;
  List<Bootstrap> bootstrap;
  Function()? click;
  Link(
      {this.click,
      this.active = true,
      this.link,
      super.id,
      this.label = "",
      this.child,
      this.bootstrap = const []});
  final _a = Element.a();
  @override
  Element create() {
    //Set id
    if (id != null) _a.id = id!;
    if (child != null) {
      _a.children.add(child!.create());
    } else {
      _a.innerHtml = label;
    }
    // active
    //Set bootstrap
    _a.className = bootstrap.join(" ");

    _a.attributes.addAll({"href": link ?? ""});
    //onPress
    _a.onClick.listen((event) {
      click?.call();
      if (link == null) event.preventDefault();
    });
    return _a;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _a;
}
