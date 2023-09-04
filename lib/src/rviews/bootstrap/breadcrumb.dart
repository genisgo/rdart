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
      nav.style.setProperty("--bs-breadcrumb-divider", "'$divider'");
    }
    //nav
    nav.attributes.addAll({"aria-label": bbreadcrumb.cname});
    ol.className = bbreadcrumb.cname;

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
  Link link;
  bool active;
  BsbreadcrumbItem({
    required this.link,
    this.active = false,
  });
  var li = Element.li();
  @override
  Element create() {
    li.className = bbreadcrumb.breadcrumbItem.cname;

    ///react link
    link.create();
    if (!active) {
      li.className += " ${bbreadcrumb.active}";
    } else {
      var disable = [
        bpointer.none,
      ].join(" ");

      link.getElement.className +=
          " ${blink.secondary} ${bunderlineLink.light}";
      li.className += " $disable";
    }

    li.children.add(link.getElement);

    return li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => li;
}
