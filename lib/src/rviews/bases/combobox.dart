part of '../rview_bases.dart';

class ComboItem<T> extends Relement {
  Relement title;
  T value;
  ComboItem({required this.title, required this.value});

  final _option = OptionElement();
  @override
  Element create() {
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
  ComboBox({required this.items, this.orientation = Direction.verticale});
  final _select = SelectElement();
  @override
  Element create() {
    //Item
    _select.options
        .addAll(items.map((e) => e.create() as OptionElement).toList());
    _select.removeEventListener("change", (event) {
      print(_select.selectedIndex);
    });
    return _select;
  }

  @override
  // TODO: implement getElement
  SelectElement get getElement => _select;
}
