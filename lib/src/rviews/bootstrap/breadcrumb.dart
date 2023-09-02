part of 'bs.components.dart';

class Bsbreadcrumb extends Relement {
  List<BsbreadcrumbItem> items;
  String? divider;
  Bsbreadcrumb({this.items = const [], this.divider});
  var ol = Element.ol();
  var nav = Element.nav();
  @override
  Element create() {
    //set Divider
    if (divider != null) {
      nav.style.setProperty("--bs-breadcrumb-divider:", divider);
    }
    //nav
    nav.attributes.addAll({"aria-label": Bbreadcrumb.breadcrumb.cname});
    ol.className = Bbreadcrumb.breadcrumb.cname;

    ///Add item in Nave
    for (var element in items) {
      ol.children.add(element.create());
    }

    nav.children.add(ol);
    return nav;
  }

  @override
  Element get getElement => nav;
}

class BsbreadcrumbItem extends Relement {
  Relement child;
  bool active;
  BsbreadcrumbItem({required this.child, this.active = false});
  var li = Element.li();
  @override
  Element create() {
    li.className = Bbreadcrumb.breadcrumbItem.cname;
    
    if (active) li.className += " ${Bbreadcrumb.active.cname}";
    li.children.add(child.create());

    return li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => li;
}
