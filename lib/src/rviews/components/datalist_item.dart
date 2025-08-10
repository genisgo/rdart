part of '../rview_bases.dart';


class DataListItem extends Relement {
  String data;
  String value;
  DataListItem({required this.data, required this.value, super.id});
  var option = OptionElement();
  @override
  Element create() {
    //Set id
    if (id != null) option.id = id!;
    option.value = value;
    return option;
  }

  @override
  // TODO: implement getElement
  Element get getElement => option;
}
