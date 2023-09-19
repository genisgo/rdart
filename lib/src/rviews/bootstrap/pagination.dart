part of 'bs.components.dart';

class BsPagination extends Relement {
  List<BsPaginationItem> items;
  List<Bootstrap> style;
  BsPagination({this.items = const [], this.style = const []});
  final _page = Element.ul();

  @override
  Element create() {
    _page.className = [bpagination, ...style].join(" ");
    _page.children.addAll(items.map((e) => e.create()));
    return _page;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _page;
}

class BsPaginationItem extends Relement {
  List<Link> links;
  List<Bootstrap> style;
  bool active;

  BsPaginationItem(
      {this.links = const [], this.style = const [], this.active = false});

  final item = Element.li();
  @override
  Element create() {
    var pageLinks = links.map((e) {
      e.create();
      e.getElement.className += " ${bpagination.link}";
      return e.getElement;
    });
    //set item bootstrap class
    item.className =
        [bpagination.item, if (active) bactive, ...style].join(" ");
    item.children.addAll(pageLinks);
    return item;
  }

  @override
  // TODO: implement getElement
  Element get getElement => item;
}
