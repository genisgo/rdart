part of '../rview_bases.dart';

class ComboItem<T> extends Relement {
  Relement title;
  T value;
  ComboItem({required this.title, super.id, required this.value});

  final _option = OptionElement();
  @override
  OptionElement create() {
    if (id != null) _option.id = id!;
    _option.children.add(title.create());
    _option.value = "$value";
    _option.children.add(title.create());
    //Set id

    return _option;
  }

  @override
  // TODO: implement getElement
  OptionElement get getElement => _option;
}

class ComboBox<T> extends Relement {
  List<ComboItem<T>> items;
  Direction orientation;
  List<Bootstrap> bootstraps;
  Function(ComboItem<T> item, int index)? onSelected;
  ComboBox(
      {required this.items,
      super.id,
      this.orientation = Direction.verticale,
      this.bootstraps = const [],
      this.onSelected});
  final _select = SelectElement();
  @override
  SelectElement create() {
    _select.className = bootstraps.join(" ");

    //Item
    for (var element in items) {
      element.create();
      _select.children.add(element.getElement);
    }

    if (onSelected != null && items.isNotEmpty) {
      _select.addEventListener("change", (event) {
        int selectIndex = _select.selectedIndex ?? 0;
        onSelected!(items[selectIndex], selectIndex);
      });
    }
    //Set id
    if (id != null) _select.id = id!;
    return _select;
  }

  @override
  // TODO: implement getElement
  SelectElement get getElement => _select;
}
