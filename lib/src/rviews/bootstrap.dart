part of 'rview_bases.dart';

abstract class Bootstrap {
  final String? cname;
  const Bootstrap(this.cname);
}

abstract class Bscreen {
  Bootstrap get sm;
  Bootstrap get md;
  Bootstrap get lg;
  Bootstrap get xl;
  Bootstrap _addScreen(param);
}

class Btn extends Bootstrap {
  static const primary = Btn._("btn-primary");
  static const secondary = Btn._("btn-secondary");
  static const succes = Btn._("btn-succes");
  static const danger = Btn._("btn-danger");
  static const warning = Btn._("btn-warning");
  static const info = Btn._("btn-info");
  static const light = Btn._("btn-light");
  static const dark = Btn._("btn-dark");
  static const lg = Btn._("btn-lg");
  static const sm = Btn._("btn-sm");
  static const active = Btn._("active");
  static const disabled = Btn._("disabled");
  static const group = Btn._("btn-group");
  static const groupVertical = Btn._("btn-group-vertical");
  static const block = Btn._("btn-block");

  const Btn._(String cname) : super(cname);
  Btn get outline {
    var spleted = cname!.split("-");
    spleted.insert(1, "outline");
    return Btn._(spleted.toSet().join("-"));
  }
}

class BContainer extends Bootstrap {
  static const sm = BContainer._("container-sm");
  static const md = BContainer._("container-md");
  static const lg = BContainer._("container-lg");
  static const xl = BContainer._("container-xl");
  static const fluid = BContainer._("container-fluid");
  const BContainer._(String cname) : super(cname);
}

class Bcolumn extends Bootstrap implements Bscreen {
  static const col = Bcolumn._("col");
  static const l2 = Bcolumn._("col-2");
  static const l3 = Bcolumn._("col-3");
  static const l4 = Bcolumn._("col-4");
  static const l5 = Bcolumn._("col-5");
  static const l6 = Bcolumn._("col-6");
  static const l7 = Bcolumn._("col-7");
  static const l8 = Bcolumn._("col-8");
  const Bcolumn._(super.cname);
  const Bcolumn.l(int l) : super("col-$l");

  @override
  Bcolumn get sm => _addScreen("sm");
  @override
  Bcolumn get md => _addScreen("md");
  @override
  Bcolumn get lg => _addScreen("lg");
  @override
  Bcolumn get xl => _addScreen("xl");

  @override
  Bcolumn _addScreen(screen) {
    var spleted = cname!.split("-");
    spleted.insert(1, screen);
    return Bcolumn._(spleted.toSet().join("-"));
  }
}

class Brow extends Bootstrap implements Bscreen {
  static const col1 = Brow._col(1);
  static const col2 = Brow._col(2);
  static const col3 = Brow._col(3);
  static const col4 = Brow._col(4);
  static const col5 = Brow._col(5);
  static const col6 = Brow._col(6);
  static const col7 = Brow._col(7);
  static const col8 = Brow._col(8);
  const Brow._(super.cname);

  const Brow._col(int col) : super("row-cols-$col");

  @override
  // TODO: implement lg
  Brow get lg => _addScreen("lg");

  @override
  Brow get md => _addScreen("md");

  @override
  // TODO: implement sm
  Brow get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Brow get xl => _addScreen("xl");

  @override
  Brow _addScreen(param) {
    var spleted = cname!.split("-");
    spleted.insert(2, param);
    return Brow._(spleted.toSet().join("-"));
  }
}
