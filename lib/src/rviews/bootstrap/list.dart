part of 'bs.components.dart';

class BsList extends Relement {
  List<BsListItem> items;
  List<Bootstrap> style;
  BsList({this.items = const [], this.style = const []});
  final _ol = Element.ol();
  @override
  Element create() {
    _ol.className = [blist, ...style].join(" ");

    _ol.children.addAll(items.map((e) => e.create()));
    return _ol;
  }

  @override
  // TODO: implement getElement
  Element get getElement => throw UnimplementedError();
}

class BsListItem extends Relement {
  bool active;
  Relement child;
  bool disabled;
  List<Bootstrap> style;
  BsListItem(
      {required this.child,
      this.active = false,
      this.disabled = false,
      this.style = const []});
  final _li = Element.li();
  @override
  Element create() {
    var item = BsElement(child: child, bootstrap: [
      blistItem,
      ...style,
      if (active) blistItem.active,
      if (disabled) blistItem.disabled,
      if (child is Link || child is RButton) blistItem.action,
    ], dataset: {
      if (disabled) "aria-disabled": "true",
      if (active) "aria-current": "true"
    });
    _li.children.add(item.create());
    return _li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _li;
}
