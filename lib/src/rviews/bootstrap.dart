part of 'rview_bases.dart';

abstract class Bootstrap {
  final String? cname;
  const Bootstrap(this.cname);
  @override
  String toString() {
    // TODO: implement toString
    return "$cname";
  }
}

abstract class Bscreen {
  Bootstrap get sm;
  Bootstrap get md;
  Bootstrap get lg;
  Bootstrap get xl;
  Bootstrap get xxl;
  Bootstrap _addScreen(param);
}

class Btn extends Bootstrap {
  static const primary = Btn._("btn-primary");
  static const secondary = Btn._("btn-secondary");
  static const success = Btn._("btn-success");
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
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");

//add Goutter
  Bcolumn bg(Bg value) => Bcolumn._("$cname ${value.cname}");

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
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");

  @override
  Brow _addScreen(param) {
    var spleted = cname!.split("-");
    spleted.insert(2, param);
    return Brow._(spleted.toSet().join("-"));
  }
}

///Cloro
class Bcolor extends Bootstrap {
  const Bcolor._(super.cname);
  //Background color
  static const bgBody = Bcolor._("bg-body");
  static const bgPrimary = Bcolor._("bg-primary");
  static const bgSecondary = Bcolor._("bg-secondary");
  static const bgSuccess = Bcolor._("bg-success");
  static const bgDanger = Bcolor._("bg-danger");
  static const bgWarning = Bcolor._("bg-warning");
  static const bgInfo = Bcolor._("bg-info");
  static const bgLight = Bcolor._("bg-light");
  static const bgDark = Bcolor._("bg-dark");
  static const bgBodySecondary = Bcolor._("bg-body-tertiary");
  static const bgBlack = Bcolor._("bg-black");
  static const bgWhite = Bcolor._("bg-white");
  static const bgTransparent = Bcolor._("bg-transparent");
  //Background gradient
  Bcolor get grandient {
    return Bcolor._("$cname bg-gradient");
  }

  Bcolor get subtle {
    return Bcolor._("$cname-subtle");
  }

  Bcolor opacity(Opacity value) {
    return Bcolor._("$cname bg-opacity-${value.value}");
  }
}

//Opacity Value
enum Opacity {
  v75(75),
  v50(50),
  v25(25),
  v10(10);

  const Opacity(this.value);
  final int value;
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
  Bootstrap get y => Bg._(cname!.replaceAll("g", "gy"));

  Bootstrap get x => Bg._(cname!.replaceAll("g", "gx"));
}

///Padding
class Bpadding extends Bootstrap {
  const Bpadding._(super.cname);

  static const p1 = Bpadding._("p-1");
  static const p2 = Bpadding._("p-2");
  static const p3 = Bpadding._("p-3");
  static const p4 = Bpadding._("p-4");
  static const p5 = Bpadding._("p-5");
  static const pauto = Bpadding._("p-auto");

  Bootstrap get y {
    return Bpadding._(cname!.replaceAll("p", "py"));
  }

  Bootstrap get x => Bpadding._(cname!.replaceAll("p", "px"));

  Bootstrap get s => Bpadding._(cname!.replaceAll("p", "ps"));

  Bootstrap get t => Bpadding._(cname!.replaceAll("p", "pt"));

  Bootstrap get b => Bpadding._(cname!.replaceAll("p", "pb"));

  Bootstrap get e => Bpadding._(cname!.replaceAll("p", "pe"));
}

///Margin
class Bmargin extends Bootstrap {
  const Bmargin._(super.cname);
  static const m1 = Bmargin._("m-1");
  static const m2 = Bmargin._("m-2");
  static const m3 = Bmargin._("m-3");
  static const m4 = Bmargin._("m-4");
  static const m5 = Bmargin._("m-5");
  static const mauto = Bmargin._("m-auto");

  Bootstrap get y => Bmargin._(cname!.replaceAll("m", "my"));

  Bootstrap get x => Bmargin._(cname!.replaceAll("m", "mx"));

  Bootstrap get s => Bmargin._(cname!.replaceAll("m", "ms"));

  Bootstrap get t => Bmargin._(cname!.replaceAll("m", "mt"));

  Bootstrap get b => Bmargin._(cname!.replaceAll("m", "mb"));

  Bootstrap get e => Bmargin._(cname!.replaceAll("m", "me"));
}

//Grid
class BGap extends Bootstrap {
  const BGap._(super.cname);
  static const gap0 = BGap._("gap-0");
  static const gap1 = BGap._("gap-1");
  static const gap2 = BGap._("gap-2");
  static const gap3 = BGap._("gap-3");
  static const gap4 = BGap._("gap-4");
  static const gap5 = BGap._("gap-5");
  static const gapAuto = BGap._("gap-auto");

  Bootstrap get row => BGap._("row-$cname");
  Bootstrap get column => BGap._("column-$cname");
}

class Bborder extends Bootstrap {
  const Bborder._(super.cname);
  static const border = Bborder._("border");
  static const rounded = Bborder._("rounded");
  //Border size
  static const b0 = Bborder._("border border-0");
  static const b1 = Bborder._("border border-1");
  static const b2 = Bborder._("border border-2");
  static const b3 = Bborder._("border border-3");
  static const b4 = Bborder._("border border-4");
  static const b5 = Bborder._("border border-5");
  //rounded const
  static const rounded0 = Bborder._("rounded-0");
  static const rounded1 = Bborder._("rounded-1");
  static const rounded2 = Bborder._("rounded-2");
  static const rounded3 = Bborder._("rounded-3");
  static const rounded4 = Bborder._("rounded-4");
  static const rounded5 = Bborder._("rounded-5");

  //Border Color
  Bcolor get colorPrimary => Bcolor._("$cname border-primary");
  Bcolor get colorSecondary => Bcolor._("$cname border-secondary");
  Bcolor get colorSuccess => Bcolor._("$cname border-success");
  Bcolor get colorDanger => Bcolor._("$cname border-danger");
  Bcolor get colorInfo => Bcolor._("$cname border-info");
  Bcolor get colorWarging => Bcolor._("$cname border-warning");
  Bcolor get colorLight => Bcolor._("$cname border-light");
  Bcolor get colorDark => Bcolor._("$cname border-dark");
  Bcolor get colorBlack => Bcolor._("$cname border-black");
  Bcolor get colorWhite => Bcolor._("$cname border-white");
  //Rounded
  Bborder get roundeds0 => Bborder._("$cname rounded-0");
  Bborder get roundeds1 => Bborder._("$cname rounded-1");
  Bborder get roundeds2 => Bborder._("$cname rounded-2");
  Bborder get roundeds3 => Bborder._("$cname rounded-3");
  Bborder get roundeds4 => Bborder._("$cname rounded-4");
  Bborder get roundeds5 => Bborder._("$cname rounded-5");

  //Static
  static Bcolor get colorPrimarys => Bcolor._("$border border-primary");
  static Bcolor get colorsecondary => Bcolor._("$border border-secondary");
  static Bcolor get colorSuccesss => Bcolor._("$border border-success");
  static Bcolor get colorDangers => Bcolor._("$border border-danger");
  static Bcolor get colorInfos => Bcolor._("$border border-info");
  static Bcolor get colorWargings => Bcolor._("$border border-warning");
  static Bcolor get colorLights => Bcolor._("$border border-light");
  static Bcolor get colorDarks => Bcolor._("$border border-deark");
  static Bcolor get colorBlacks => Bcolor._("$border border-black");
  static Bcolor get colorWhites => Bcolor._("$border border-white");

  //End , Start , Top , Bottom
  Bootstrap get end => Bborder._(_addDisposition("end"));
  Bootstrap get start => Bborder._(_addDisposition("start"));
  Bootstrap get bottom => Bborder._(_addDisposition("bottom"));
  Bootstrap get top => Bborder._(_addDisposition("top"));

  String _addDisposition(String disposition) {
    String endClass = "";
    var regex = RegExp(r"(\w{0,}-\d$)");
    var macher = regex.allMatches(cname!);
    if (macher.isEmpty) {
      endClass = "$cname-$disposition";
    } else {
      var valueList = macher.first[0]?.split("-");
      valueList?.insert(1, disposition);
      endClass = valueList?.join("-") as String;
    }
    return endClass;
  }

  Bootstrap opacity(Opacity opacity) {
    return Bborder._("$cname border-opacity-${opacity.value}");
  }
}

//Text
class Btext extends Bootstrap {
  const Btext._(super.cname);

  ///Text Alignment
  static _TextAlign get alignStart => _TextAlign("text-start");
  static _TextAlign get alignEnd => _TextAlign("text-end");
  static _TextAlign get alignCenter => _TextAlign("text-center");

  ///Text OverFlow
  static const wrap = Btext._("text-wrap");
  static const noWrap = Btext._("text-nowrap");

  ///[Word breack](https://getbootstrap.com/docs/5.3/utilities/text/#word-break)
  static const wordBreak = Btext._("text-wrap");
}

class _TextAlign extends Bootstrap implements Bscreen {
  const _TextAlign(super.cname);

  @override
  Bootstrap _addScreen(param) {
    var spleted = cname!.split("-");
    spleted.insert(1, param);
    return Brow._(spleted.toSet().join("-"));
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => throw UnimplementedError();

  @override
  // TODO: implement sm
  Bootstrap get sm => throw UnimplementedError();

  @override
  // TODO: implement xl
  Bootstrap get xl => throw UnimplementedError();

  @override
  // TODO: implement xxl
  Bootstrap get xxl => throw UnimplementedError();
}
