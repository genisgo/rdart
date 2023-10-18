part of '../bootstrap.dart';

class BContainer extends Bootstrap {
  static const sm = BContainer._("container-sm");
  static const md = BContainer._("container-md");
  static const lg = BContainer._("container-lg");
  static const xl = BContainer._("container-xl");
  static const fluid = BContainer._("container-fluid");
  static const container = BContainer._("container");
  const BContainer._(String cname) : super(cname);
}

class Bcolumn extends Bootstrap implements Bscreen {
  static const col = Bcolumn._("col");
  static const w2 = Bcolumn._("col-2");
  static const w3 = Bcolumn._("col-3");
  static const w4 = Bcolumn._("col-4");
  static const w5 = Bcolumn._("col-5");
  static const w6 = Bcolumn._("col-6");
  static const w7 = Bcolumn._("col-7");
  static const w8 = Bcolumn._("col-8");
  static const w9 = Bcolumn._("col-9");
  static const w10 = Bcolumn._("col-10");
  static const w11 = Bcolumn._("col-11");
  static const w12 = Bcolumn._("col-12");
  static const auto = Bcolumn._("col-auto");

  const Bcolumn._(super.cname);
  const Bcolumn.l(int l) : super("col-$l");

  @override
  Bcolumn get sm => addScreen("sm");
  @override
  Bcolumn get md => addScreen("md");
  @override
  Bcolumn get lg => addScreen("lg");
  @override
  Bcolumn get xl => addScreen("xl");
  @override
  // TODO: implement xxl
  Bootstrap get xxl => addScreen("xxl");

//add Goutter
  Bcolumn bg(Bg value) => Bcolumn._("$cname ${value.cname}");

  @override
  Bcolumn addScreen(screen) {
    var spleted = cname.split("-");
    spleted.insert(1, screen);
    return Bcolumn._(spleted.toSet().join("-"));
  }
}

final brow = Brow.row;     

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
  static const row = Brow._("row");
  const Brow._col(int col) : super("row-cols-$col");

  @override
  // TODO: implement lg
  Brow get lg => addScreen("lg");

  @override
  Brow get md => addScreen("md");

  @override
  // TODO: implement sm
  Brow get sm => addScreen("sm");

  @override
  // TODO: implement xl
  Brow get xl => addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => addScreen("xxl");

  @override
  Brow addScreen(param) {
    var spleted = cname.split("-");
    spleted.insert(2, param);
    return Brow._(spleted.toSet().join("-"));
  }
}

//Gottier col
class Bg extends Bootstrap {
  const Bg._(super.cname);
  //Full
  static const g1 = Bg._("g-1");
  static const g2 = Bg._("g-2");
  static const g3 = Bg._("g-3");
  static const g4 = Bg._("g-4");
  static const g5 = Bg._("g-5");
  Bootstrap get y => Bg._(cname.replaceAll("g", "gy"));

  Bootstrap get x => Bg._(cname.replaceAll("g", "gx"));
}
