part of 'bootstrap.dart';

class Icolor<T> {
  final String icname;
  final int insertIndex;

  Icolor._({required this.icname, this.insertIndex = 1});
  T get primary {
    return _defaultAddScreen("primary", icname, insertIndex) as T;
  }

  T get secondary {
    return _defaultAddScreen("secondary", icname, insertIndex) as T;
  }

  T get success {
    return _defaultAddScreen("success", icname, insertIndex) as T;
  }

  T get danger {
    return _defaultAddScreen("danger", icname, insertIndex) as T;
  }

  T get warning {
    return _defaultAddScreen("warning", icname, insertIndex) as T;
  }

  T get info {
    return _defaultAddScreen("info", icname, insertIndex) as T;
  }

  T get light {
    return _defaultAddScreen("light", icname, insertIndex) as T;
  }

  T get dark {
    return _defaultAddScreen("dark", icname, insertIndex) as T;
  }

  ///Opacity
  Bootstrap opacity(Opacity opacity) {
    return _defaultAddScreen("opacity-${opacity.value}", icname);
  }

  Bootstrap opacityHover(Opacity opacity) {
    return _defaultAddScreen("opacity-${opacity.value}-hover", icname);
  }
}

///Colors
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

///Padding
class Bpadding extends Bootstrap {
  const Bpadding._(super.cname);
  static const p0 = Bpadding._("p-0");
  static const p1 = Bpadding._("p-1");
  static const p2 = Bpadding._("p-2");
  static const p3 = Bpadding._("p-3");
  static const p4 = Bpadding._("p-4");
  static const p5 = Bpadding._("p-5");
  static const pauto = Bpadding._("p-auto");

  Bootstrap get y {
    return Bpadding._(cname.replaceAll("p", "py"));
  }

  Bootstrap get x => Bpadding._(cname.replaceAll("p", "px"));

  Bootstrap get s => Bpadding._(cname.replaceAll("p", "ps"));

  Bootstrap get t => Bpadding._(cname.replaceAll("p", "pt"));

  Bootstrap get b => Bpadding._(cname.replaceAll("p", "pb"));

  Bootstrap get e => Bpadding._(cname.replaceAll("p", "pe"));
}

///Margin
class Bmargin extends Bootstrap {
  const Bmargin._(super.cname);

  static const m0 = Bmargin._("m-0");
  static const m1 = Bmargin._("m-1");
  static const m2 = Bmargin._("m-2");
  static const m3 = Bmargin._("m-3");
  static const m4 = Bmargin._("m-4");
  static const m5 = Bmargin._("m-5");
  static const mauto = Bmargin._("m-auto");

  Bootstrap get y => Bmargin._(cname.replaceAll("m", "my"));

  Bootstrap get x => Bmargin._(cname.replaceAll("m", "mx"));

  Bootstrap get s => Bmargin._(cname.replaceAll("m", "ms"));

  Bootstrap get t => Bmargin._(cname.replaceAll("m", "mt"));

  Bootstrap get b => Bmargin._(cname.replaceAll("m", "mb"));

  Bootstrap get e => Bmargin._(cname.replaceAll("m", "me"));
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
    var macher = regex.allMatches(cname);
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
  static _TextAlign get alignLeft => _TextAlign("text-left");
  static _TextAlign get alignRight => _TextAlign("text-right");

  ///Text hiden
  static const hiden = Btext._("text-hide");

  ///[Word breack](https://getbootstrap.com/docs/5.3/utilities/text/#word-break)
  static const wordBreak = Btext._("text-wrap");

  ///FontSize
  static const fs = _BFs("");

  ///Font Weight
  static const fw = _Fw("");

  ///Text Overflow
  static const overflow = BTextOverFlow._();
  static const wrap = Btext._("text-wrap");
  static const noWrap = Btext._("text-nowrap");

  ///Text Transform (Capitalisation)
  static const uppercase = Btext._("text-uppercase");
  static const capitalize = Btext._("text-capitalize");
  static const lowercase = Btext._("text-lowercase");
}

///Generale constant use [ textOverFlow.auto] or [Btext.overflow.auto]
const textOverFlow = BTextOverFlow._();

///TextOverFlow
base class BTextOverFlow {
  const BTextOverFlow._();

  ///This is an example of using [Btext.overflow.hidden]
  ///or Use general constante [textOverFlow.auto] on
  ///an element with set width and height dimensions.
  /// By design,this content will vertically scroll.
  Bootstrap get hidden => _BootStrapDefaultImp("overflow-hidden");

  Bootstrap get auto => _BootStrapDefaultImp("overflow-auto");
  Bootstrap get visible => _BootStrapDefaultImp("overflow-visible");
  Bootstrap get scroll => _BootStrapDefaultImp("overflow-scroll");
  Bootstrap get truncate => Btext._("text-truncate");
}

///TextAlignement
class _TextAlign extends Bootstrap implements Bscreen {
  const _TextAlign(super.cname);

  @override
  Bootstrap _addScreen(param) {
    var spleted = cname.split("-");
    spleted.insert(1, param);
    return Brow._(spleted.toSet().join("-"));
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

///Generale constact for [BFs] class quick use
///Example [fontsize.h1]
const fontsize = _BFs("");

///FontSize [BFs] use generale const [fontsize] example [fontsize.h1]
///or [Btext.fs] example [Btext.fs.h1]
base class _BFs extends Bootstrap {
  const _BFs(super.cname);

  ///Direct use [ fontsize.h1]
  Bootstrap get h1 => _BFs("fs-1");
  Bootstrap get h2 => _BFs("fs-2");
  Bootstrap get h3 => _BFs("fs-3");
  Bootstrap get h4 => _BFs("fs-4");
  Bootstrap get h5 => _BFs("fs-5");
  Bootstrap get h6 => _BFs("fs-6");
}

///Font Weight
///Generale constant use [fontweight] quickly example
///[fontweight.bold]
const fontweight = _Fw("");

///
class _Fw {
  final String cname;
  const _Fw(this.cname);

  Bootstrap get bold => _BootStrapDefaultImp("fw-bold");

  Bootstrap get bolder => _BootStrapDefaultImp("fw-bolder");

  Bootstrap get semibold => _BootStrapDefaultImp("fw-semibold");

  Bootstrap get medium => _BootStrapDefaultImp("fw-medium");

  Bootstrap get normal => _BootStrapDefaultImp("fw-normal");

  Bootstrap get light => _BootStrapDefaultImp("fw-light");

  Bootstrap get lighter => _BootStrapDefaultImp("fw-lighter");

  Bootstrap get italic => _BootStrapDefaultImp("fst-italic");

  Bootstrap get fstNormarl => _BootStrapDefaultImp("fst-italic");
}

///Display

base class Bdisplay extends Bootstrap implements Bscreen {
  const Bdisplay._(super.cname);

  static const none = Bdisplay._("d-none");

  static const inline = Bdisplay._("d-inline");

  static const inlineBlock = Bdisplay._("d-inline-block");

  static const block = Bdisplay._("d-block");

  static const table = Bdisplay._("d-table");

  static const tableCell = Bdisplay._("d-table-cell");

  static const tableRow = Bdisplay._("d-table-row");

  static const flex = Bdisplay._("d-flex");

  static const inlineFlex = Bdisplay._("d-inline-flex");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");

  Bootstrap get print => _addScreen("print");
}

///Display Flex
class BFlex extends Bootstrap implements Bscreen {
  const BFlex._(super.cname);
  static const row = BFlex._("flex-row");
  static const column = BFlex._("flex-column");
  static const columnReverse = BFlex._("flex-column-reverse");
  static const rowReverse = BFlex._("flex-row-reverse");
  static const nowrap = BFlex._("flex-nowrap");
  static const wrap = BFlex._("flex-wrap");
  static const wrapReverse = BFlex._("flex-wrap-reverse");
  static const fill = BFlex._("flex-fill");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

///AligneItem
class BAlignItem extends Bootstrap implements Bscreen {
  const BAlignItem._(super.cname);
  static const start = BAlignItem._("align-items-start");
  static const end = BAlignItem._("align-items-end");
  static const center = BAlignItem._("align-items-center");
  static const baseline = BAlignItem._("align-items-baseline");
  static const stretch = BAlignItem._("align-items-stretch");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

///AlignSelft
class BAlignSelf extends Bootstrap implements Bscreen {
  const BAlignSelf._(super.cname);
  static const start = BAlignSelf._("align-self-start");
  static const end = BAlignSelf._("align-self-end");
  static const center = BAlignSelf._("align-self-center");
  static const baseline = BAlignSelf._("align-self-baseline");
  static const stretch = BAlignSelf._("align-self-stretch");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

///Justify-Content
class BJustifyContent extends Bootstrap implements Bscreen {
  const BJustifyContent._(super.cname);
  static const start = BJustifyContent._("justify-content-start");
  static const end = BJustifyContent._("justify-content-end");
  static const center = BJustifyContent._("justify-content-center");
  static const between = BJustifyContent._("justify-content-between");
  static const around = BJustifyContent._("justify-content-around");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

///Align-Content
class BAlinContent extends Bootstrap implements Bscreen {
  const BAlinContent._(super.cname);
  static const start = BAlinContent._("align-content-start");
  static const end = BAlinContent._("align-content-end");
  static const center = BAlinContent._("align-content-center");
  static const between = BAlinContent._("align-content-between");
  static const around = BAlinContent._("align-content-around");
  static const stretch = BAlinContent._("align-content-stretch");

  @override
  Bootstrap _addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => _addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _addScreen("xxl");
}

class Bposition extends Bootstrap {
  Bposition._(super.cname);

  ///Add top position example [top.p0]
  static const top = _Position("top");

  ///Add top position example [bottom.p0]
  static const bottom = _Position("bottom");

  ///Add top position example [start.p0] start=left
  static const start = _Position("start");

  ///Add top position example [end.p0] end=right
  static const end = _Position("end");

  ///
  static Bootstrap get static => Bposition._("position-static");
  static Bootstrap get relative => Bposition._("position-relative");
  static Bootstrap get absolute => Bposition._("position-absolute");
  static Bootstrap get fixed => Bposition._("position-fixed");
  static Bootstrap get sticky => Bposition._("position-sticky");

  ///translate-middle classes elements can be positioned only in horizontal
  ///or vertical direction
  static Bootstrap get translateMiddle => Bposition._("translate-middle");
  static Bootstrap get translateMiddleX => Bposition._("translate-middle-x");
  static Bootstrap get translateMiddleY => Bposition._("translate-middle-y");
}

class _Position {
  final String cname;
  const _Position(this.cname);
  Bootstrap get p0 => _BootStrapDefaultImp("$cname-0");
  Bootstrap get p50 => _BootStrapDefaultImp("$cname-50");
  Bootstrap get p100 => _BootStrapDefaultImp("$cname-100");
}

///Generale constante
const BSize bheight = BSize._("h");
const BSize bwidth = BSize._("w");
const BSize bmaxWidth = BSize._("mw");
const BSize bmaxHeight = BSize._("mh");
const BSize bvh = BSize._("vh");
const BSize bvw = BSize._("vw");
const BSize bminvh = BSize._("min-vh");
const BSize bminvw = BSize._("min-vw");

///Sizing
class BSize {
  final String cname;
  const BSize._(this.cname);
  static const height = BSize._("h");
  static const width = BSize._("w");
  static const BSize maxWidth = BSize._("mw");
  static const BSize maxHeight = BSize._("mh");
  static const BSize vh = BSize._("vh");
  static const BSize vw = BSize._("vw");
  static const BSize minvh = BSize._("min-vh");
  static const BSize minvw = BSize._("min-vw");

  ///getter
  Bootstrap get x25 => _BootStrapDefaultImp("$cname-25");
  Bootstrap get x50 => _BootStrapDefaultImp("$cname-50");
  Bootstrap get x75 => _BootStrapDefaultImp("$cname-75");
  Bootstrap get x100 => _BootStrapDefaultImp("$cname-100");
  Bootstrap get auto => _BootStrapDefaultImp("$cname-auto");
}

///Generale constante
const bshadow = Bshadow._("shadow");

///Shadow
class Bshadow extends Bootstrap implements Bscreen {
  const Bshadow._(super.cname);
  static const shadow = Bshadow._("shadow");

  @override
  Bootstrap _addScreen(param) {
    // TODO: implement _addScreen
    throw UnimplementedError();
  }

  Bootstrap get none => _BootStrapDefaultImp("$cname-none");
  @override
  // TODO: implement lg
  Bootstrap get lg => _BootStrapDefaultImp("$cname-lg");

  @override
  // TODO: implement md
  Bootstrap get md => _BootStrapDefaultImp("$cname-md");

  @override
  // TODO: implement sm
  Bootstrap get sm => _BootStrapDefaultImp("$cname-sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => _BootStrapDefaultImp("$cname-xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _BootStrapDefaultImp("$cname-xxl");
}

///Generale constante
const Bvisibility bvisibility = Bvisibility._();

///Visibility Use generale constante [bvisibility]
///Example [bvisibility.invisible]
class Bvisibility {
  const Bvisibility._();

  ///getter values
  Bootstrap get visible => _BootStrapDefaultImp("visibility");
  Bootstrap get invisible => _BootStrapDefaultImp("invisible");
}

///General constante
final blink = Blink.link.colors;

final bunderlineLink = Blink.underline.colors;

///Link
class Blink extends Bootstrap {
  const Blink._(super.cname);
  static const link = Blink._("link");
  static const underline = BUnderlineLink._("link-underline");

  // static const primary = Blink._("link-primary");
  // static const secondary = Blink._("link-secondary");

  // static const success = Blink._("link-success");

  // static const warning = Blink._("link-warning");

  // static const info = Blink._("link-info");

  // static const light = Blink._("link-light");
  // static const dark = Blink._("link-dark");
  // static const body = Blink._("link-body-emphasis");
  // static const underlines = Blink._("link-underline");
  Icolor<Bootstrap> get colors => Icolor<Bootstrap>._(
        icname: cname,
      );
}

base class BUnderlineLink extends Bootstrap {
  const BUnderlineLink._(super.cname);
  static const underline = BUnderlineLink._("link-underline");
  Icolor<Bootstrap> get colors => Icolor._(icname: cname, insertIndex: 2);
}

///Generale constante
final bpointer = BpointerEvent.pointer;

///Pointer Event Interactions
///Utility classes that change how users interact
/// with contents of a website.
class BpointerEvent extends Bootstrap {
  const BpointerEvent._(super.cname);
  //Text
  static const pointer = BpointerEvent._("");

  ///Change the way in which the content
  /// is selected when the user interacts with it.
  Bootstrap get selectAuto => BpointerEvent._("user-select-auto");
  Bootstrap get selectNone => BpointerEvent._("user-select-none");
  Bootstrap get selectAll => BpointerEvent._("user-select-all");

  ///Bootstrap provides .pe-none and .pe-auto
  ///classes to prevent or add element interactions.
  Bootstrap get none => BpointerEvent._("pe-none");
}

///Object fit
class BfitBox extends Bootstrap implements Bscreen {
  const BfitBox._(super.cname);
  static BfitBox get contain => BfitBox._("object-fit-contain");
  static BfitBox get cover => BfitBox._("object-fit-cover");
  static BfitBox get fill => BfitBox._("object-fit-fill");
  static BfitBox get scale => BfitBox._("object-fit-scale");
  static BfitBox get none => BfitBox._("object-fit-none");

  @override
  Bootstrap _addScreen(param) {
    // TODO: implement _addScreen
    throw UnimplementedError();
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => _defaultAddScreen("lg", cname, 2);

  @override
  // TODO: implement md
  Bootstrap get md => _defaultAddScreen("md", cname, 2);

  @override
  // TODO: implement sm
  Bootstrap get sm => _defaultAddScreen("sm", cname, 2);

  @override
  // TODO: implement xl
  Bootstrap get xl => _defaultAddScreen("xl", cname, 2);

  @override
  // TODO: implement xxl
  Bootstrap get xxl => _defaultAddScreen("xxl", cname, 2);
}
