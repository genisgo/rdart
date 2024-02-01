part of 'bs.components.dart';

class BsTable extends Relement {
  BsTableHeader header;
  List<Bootstrap> style;
  List<BsTableRow> rows;
  BsTable(
      {required this.header,
      required this.rows,
      this.style = const [],
      super.id});

  var table = Element.table();
  var body = Element.tag("tbody");

  @override
  Element create() {
    table.children.clear();
    body.children.clear();

    ///Body prepare
    var el = rows.map((e) => e.create());

    body.children.addAll(el);
    table.children.addAll([
      header.create(),
      body,
    ]);
    //applique style
    table.className = [btable, ...style].join(" ");
    table.style.setProperty("--bs-table-bg", "none");
    //SET ID
    if (id != null) table.id = id!;
    return table;
  }

  @override
  // TODO: implement getElement
  Element get getElement => table;
}

class BsTableRow extends Relement {
  List<BsTableCell> cells;
  List<Bootstrap> style;
  RStyle? rstyle;
  BsTableRow(
      {required this.cells, this.rstyle, this.style = const [], super.id});
  var _row = Element.tr();
  @override
  Element create() {
    _row.children.clear();

    _row.className = style.join(" ");
    _row.children.addAll(cells.map((e) {
      return e.create();
    }));
    //SET ID
    if (id != null) _row.id = id!;
    if (rstyle != null) {
      _row = rstyle!.createStyle(_row);
    }
    return _row;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _row;
}

class BsTableCell extends Relement {
  Relement child;
  bool scope;
  List<Bootstrap> style;

  BsTableCell(
      {required this.child,
      this.scope = false,
      this.style = const [],
      super.id});
  var _td = Element.td();
  @override
  Element create() {
    _td.children.clear();
    if (scope) {
      _td = Element.th();
      _td.attributes.addAll({"scope": "row"});
    }
    _td.className = [...style].join(" ");
    _td.children.add(child.create());
    //SET ID
    if (id != null) _td.id = id!;
    return _td;
  }
  

  @override
  // TODO: implement getElement
  Element get getElement => _td;

}

class BsTableHeader extends Relement {
  List<Relement> cols;
  List<Bootstrap> style;
  BsTableHeader({required this.cols, this.style = const [], super.id});

  final _header = Element.tag("thead");

  @override
  Element create() {
    _header.children.clear();
    //th
    var tr = Element.tr();
    //tr
    tr.children.addAll(cols.map((e) {
      var th = Element.th();
      th.attributes.addAll({"scope": "col"});
      th.children.add(e.create());
      //SET ID
      if (id != null) th.id = id!;
      return th;
    }));
//header
    //_header.innerHtml = "  <thead> ${tr.innerHtml} </thead>";
    _header.children.add(tr);
    _header.className = [...style].join(" ");
    return _header;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _header;
}
