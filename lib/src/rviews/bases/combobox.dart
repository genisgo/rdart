part of '../rview_bases.dart';

class ComboItem<T> extends Relement {
  Relement title;
  T value;
  ComboItem({required this.title, required this.value});

  final _option = OptionElement();
  @override
  OptionElement create() {
    _option.children.add(title.create());
    _option.value = "$value";
    _option.children.add(title.create());

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
  Function(ComboItem item, int index)? onSelected;
  ComboBox(
      {required this.items,
      this.orientation = Direction.verticale,
      this.bootstraps = const [],
      this.onSelected});
  final _select = SelectElement();
  @override
  SelectElement create() {
    _select.className += bootstraps.join(" ");
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
    return _select;
  }

  @override
  // TODO: implement getElement
  SelectElement get getElement => _select;
}
