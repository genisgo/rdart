part of 'bs.components.dart';

class BsPagination extends Relement {
  List<BsPaginationItem> items;
  List<Bootstrap> style;
  final Function(int index)? onPrevious;
  final Function(int index)? onNext;
  final Function(int index)? onSelet;

  int currentIndex;
  bool previous;
  bool next;
  BsPagination(
      {this.items = const [],
      this.style = const [],
      this.previous = true,
      this.onNext,
      super.id,
      this.currentIndex = 0,
      this.onSelet,
      this.onPrevious,
      this.next = true});
  final _page = Element.ul();
  final prevElement = BsPaginationItem(link: Link(label: "Previous"));
  final nextElement = BsPaginationItem(link: Link(label: "Next"));

  @override
  Element create() {
    //prev an next
    prevElement.create();
    nextElement.create();

    _page.className = [bpagination, ...style].join(" ");

    //active fist item
    items.first.active = true;
    //
    final itemElements = items.map((e) => e.create()).toList();

    //event
    for (var i = 0; i < itemElements.length; i++) {
      _addSelectEvent(itemElements, i);
    }
    //on previous and next event
    nextEvent(itemElements);
    preventEvent(itemElements);

    _page.children.addAll([
      if (previous) prevElement.getElement,
      ...itemElements,
      if (next) nextElement.getElement
    ]);

    ///SEt ID
    if (id != null) _page.id = id!;
    return _page;
  }

  void nextEvent(List<Element> itemElements) {
    nextElement.getElement.onClick.listen((event) {
      var isMaxIndex = currentIndex + 1 >= itemElements.length;
      int selectIndex = isMaxIndex ? currentIndex : ++currentIndex;

      onNext?.call(selectIndex);

      _activeOrDisableItem(selectIndex, itemElements);
    });
  }

  void preventEvent(List<Element> itemElements) {
    final eprev = prevElement.getElement;
    eprev.onClick.listen((event) {
      var isMinIndex = currentIndex - 1 < 0;
      int selectIndex = isMinIndex ? currentIndex : --currentIndex;
      //set disable if min
      if (isMinIndex) {
        eprev.className += " $bdisable";
      } else {
        eprev.className = eprev.className.replaceAll("$bdisable", "");
      }
      onPrevious?.call(selectIndex);
      _activeOrDisableItem(
        selectIndex,
        itemElements,
      );
    });
  }

  void _addSelectEvent(List<Element> itemElements, int i) {
    itemElements[i].onClick.listen((event) {
      _activeOrDisableItem(i, itemElements);
    });
  }

  void _activeOrDisableItem(int i, List<Element> itemElements) {
    currentIndex = i;

    ///Active elemnt
    if (!itemElements[i].className.contains("$bactive")) {
      itemElements[i].className += " $bactive";
    }
    //Unset active for every element
    for (var e in itemElements) {
      if (e != itemElements[i]) {
        var disableClass = e.className.replaceAll("$bactive", "");
        e.className = disableClass;
      }
    }
  }

  @override
  // TODO: implement getElement
  Element get getElement => _page;
}

class BsPaginationItem extends Relement {
  Link link;
  List<Bootstrap> style;
  bool active;

  BsPaginationItem(
      {required this.link, this.style = const [], this.active = false,super.id});

  final item = Element.li();
  @override
  Element create() {
    link.create();
    link.getElement.className += " ${bpagination.link}";

    //set item bootstrap class
    item.className =
        [bpagination.item, if (active) bactive, ...style].join(" ");
    item.children.add(link.getElement);
    //SET ID
    if (id != null) item.id = id!;
    return item;
  }

  @override
  // TODO: implement getElement
  Element get getElement => item;
}
