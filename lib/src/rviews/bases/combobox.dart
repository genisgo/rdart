part of '../rview_bases.dart';

class ComboItem<T> extends Relement {
  Relement title;
  T value;
  ComboItem({required this.title, required this.value});

  final _option = Element.option();
  @override
  Element create() {
    _option.children.add(title.create());
    _option.attributes.addAll({"value": "$value"});

    return _option;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _option;
}

class ComboBox<T> extends Relement {
  List<ComboItem<T>> items;
  Direction orientation;
  ComboBox({required this.items, this.orientation = Direction.verticale});
  final _select = Element.select();
  @override
  Element create() {
    //Item
    for (var item in items) {
      _select.children.add(item.create());
    }

    return _select;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _select;
}
