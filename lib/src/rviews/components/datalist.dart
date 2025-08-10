part of '../rview_bases.dart';

/// DataList : composant pour afficher une liste de données
class DataList extends Relement {
  List<DataListItem> options;
  DataList({required this.options, super.id});
  var datalist = DataListElement();
  @override
  Element create() {
    ///Set id
    if (id != null) datalist.id = id!;
    datalist.options?.addAll(options.map((e) => e.create()).toList());
    return datalist;
  }

  @override
  // TODO: implement getElement
  Element get getElement => datalist;
}

  