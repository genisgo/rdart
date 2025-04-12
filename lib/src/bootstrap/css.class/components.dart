part of '../bootstrap.dart';

///Click the accordions below to expand/collapse the accordion content.
///Example:
///```dart
///Column( singleBootStrap: true,
///   bootstrap: [
///     Baccordion.header,
///   ]);
///```
class Baccordion extends Bootstrap {
  const Baccordion._(super.cname);
  static const accordion = Baccordion._("accordion");
  static Bootstrap get item => Baccordion._("$accordion-item");
  static Bootstrap get header => Baccordion._("$accordion-header");
  static Bootstrap get body => Baccordion._("$accordion-body");
  static Bootstrap get button => Baccordion._("$accordion-button");
  static Bootstrap get collapsed => Baccordion._("collapsed");
  static Bootstrap get collapse => Baccordion._("$accordion-collapse");
  static Bootstrap get flush => Baccordion._("$accordion-flush");
}

class Bcollapse extends Bootstrap {
  const Bcollapse._(super.cname);

  ///Generally, we recommend using a button with the data-bs-target attribute.
  /// While not recommended from a semantic point of view,
  /// you can also use a link with the href attribute (and a role="button").
  ///  In both cases, the data-bs-toggle="collapse" is required.
  static const collapse = Bcollapse._("collapse");

  ///A <button> or <a> can show and hide multiple elements by referencing
  ///them with a selector in its href or data-bs-target attribute.
  /// Multiple <button> or <a> can show and hide an element if they
  /// each reference it with their href or data-bs-target attribute
  static const multicollapse = Bcollapse._("multi-collapse");
  static const show = Bcollapse._("show");
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
  static const btn = Btn._("btn");
  static const close = Btn._("btn-close");

  const Btn._(String cname) : super(cname);
  Btn get outline {
    var spleted = cname.split("-");
    spleted.insert(1, "outline");
    return Btn._(spleted.toSet().join("-"));
  }
}

///Generale constante
final balert = BAlert.alert;

///Use generale constante [balert.danger] or [ BAlert.alert]
///Example :
///```dart
/// bootstrap: [
///   //generale constante
///   balert.danger
///   //class use
///   BAlert.alert,
///   if (dismissible) BAlert.disimissible,
///   ],
///```
class BAlert extends Bootstrap {
  const BAlert._(super.cname);
  static const alert = BAlert._("alert");

  Bootstrap get primary => BAlert._("alert-primary");

  Bootstrap get success => BAlert._("alert-success");

  Bootstrap get danger => BAlert._("alert-danger");

  Bootstrap get warning => BAlert._("alert-warning");

  Bootstrap get info => BAlert._("alert-info");

  Bootstrap get light => BAlert._("alert-light");

  Bootstrap get dark => BAlert._("alert-dark");

  Bootstrap get link => BAlert._("alert-link");

  Bootstrap get heading => BAlert._("alert-heading");

/***
Be sure you’ve loaded the alert plugin, or the compiled Bootstrap JavaScript.
Add a close button and the .alert-dismissible class, which adds extra padding to the right of the alert and positions the close button.
On the close button, add the data-bs-dismiss="alert" attribute, which triggers the JavaScript functionality. Be sure to use the <button> element with it for proper behavior across all devices.
To animate alerts when dismissing them, be sure to add the .fade and .show classes.
 */

  static const Bootstrap disimissible =
      BAlert._("alert-dismissible alert-dismissible fade show");
}

///Generale constante
final bbage = Bbage.bage;

class Bbage extends Bootstrap {
  const Bbage._(super.cname);
  static const bage = Bbage._("badge");
}

///Generale constante
final bbreadcrumb = Bbreadcrumb.bbreadcrumb;

///Breadcrumb use generale constante [bbreadcrumb] or [Bbreadcrumb.bbreadcrumb]
///Example :
///```dart
/// bbreadcrumb.breadcrumbItem
///```
class Bbreadcrumb extends Bootstrap {
  const Bbreadcrumb._(super.cname);
  static const Bbreadcrumb bbreadcrumb = Bbreadcrumb._("breadcrumb");
  Bootstrap get breadcrumb => Bbreadcrumb._("breadcrumb");
  Bootstrap get breadcrumbItem => Bbreadcrumb._("breadcrumb-item");
  Bootstrap get active => Bbreadcrumb._("active");
}

///Card constante
///```dart
/// Container(bootstrap: [bcard.header], child: header),
///```
final bcard = Bcard.card;

///Use to creat card a generale constante [bcard] or
///[Bcard.card] Example:
///```dart
/// child: Column(children: [
///   if (header != null)
///     Container(bootstrap: [bcard.header], child: header),
///   if (body != null)
///     Container(bootstrap: [bcard.body,  child: body),
///   if (footer != null)
///     Row(bootstrap: [bcard.footer] children: [Text("footer")])
/// ]),
///```
class Bcard extends Bootstrap {
  Bcard._(super.cname);

  static Bcard get card => Bcard._("card");
  Bootstrap get title => Bcard._("card-title");
  Bootstrap get body => Bcard._("card-body");
  Bootstrap get text => Bcard._("card-text");
  Bootstrap get link => Bcard._("card-link");
  Bootstrap get subtitl => Bcard._("card-subtitl");
  Bootstrap get header => Bcard._("card-header");
  Bootstrap get footer => Bcard._("card-footer");
  Bootstrap get image => Bcard._("card-img");
  Bootstrap get imageTop => Bcard._("card-img-top");
  Bootstrap get imageBottom => Bcard._("card-img-top");
  Bootstrap get imageOverlay => Bcard._("card-img-overlay");
}

///Generale constante
const bcarousel = Bcarousel.carousel;

///For use Carousel, use generale constant [bcarousel] or [Bcarousel.carousel]
///Example:
///```dart
/////use [singleBootStrap]=true
///Column(
/// children: items,
/// singleBootStrap: true,
/// bootstrap: [bcarousel.inner])
///```
class Bcarousel extends Bootstrap {
  const Bcarousel._(super.cname);
  static const carousel = Bcarousel._("carousel");
  Bootstrap get item => Bcarousel._("carousel-item");
  Bootstrap get active => Bcarousel._("active");
  Bootstrap get slide => Bcarousel._("slide");
  Bootstrap get fade => Bcarousel._("carousel-fade");
  Bootstrap get inner => Bcarousel._("carousel-inner");
  Bootstrap get controlPrev => Bcarousel._("carousel-control-prev");
  Bootstrap get controlNext => Bcarousel._("carousel-control-next");
  Bootstrap get controlPrevIcon => Bcarousel._("carousel-control-prev-icon");
  Bootstrap get controlNextIcon => Bcarousel._("carousel-control-next-icon");
  Bootstrap get caption => Bcarousel._("carousel-caption");
  Bootstrap get indicators => Bcarousel._("carousel-indicators");
}

///Generale
const bdropdown = Bdropdown.dropdown;

///Dropdown button
class Bdropdown extends Bootstrap {
  const Bdropdown._(super.cname);

  static const dropdown = Bdropdown._("dropdown");

  Bootstrap get menu => Bdropdown._("dropdown-menu");

  Bootstrap get item => Bdropdown._("dropdown-item");

  Bootstrap get toggle => Bdropdown._("dropdown-toggle");

  Bootstrap get divider => Bdropdown._("dropdown-divider");

  Bootstrap get split => Bdropdown._("dropdown-toggle-split");

  ///Use with [menu]
  Bootstrap get menuDark => Bdropdown._("dropdown-menu-dark");

  Bootstrap get center => Bdropdown._("dropdown-center");

  Bootstrap get dropup => Bdropdown._("dropup");

  Bootstrap get dropend => Bdropdown._("dropend");

  Bootstrap get dropstart => Bdropdown._("dropstart");
  _DropdownMenuAlign get menAlignEnd => _DropdownMenuAlign("dropdown-menu-end");

  _DropdownMenuAlign get menAlignStart =>
      _DropdownMenuAlign("dropdown-menu-start");

  ///You can also create non-interactive dropdown items with
  ///[itemText].Feel free to style further.
  Bootstrap get itemText => Bdropdown._("dropdown-item-text");
  Bootstrap get itemActive => Bdropdown._("active");
  Bootstrap get disabled => Bdropdown._("disabled");
  Bootstrap get header => Bdropdown._("dropdown-header");
}

class _DropdownMenuAlign extends Bootstrap implements Bscreen {
  const _DropdownMenuAlign(String cnames) : super(cnames);

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

///Generale constante
const blist = BList.list;

class BList extends Bootstrap {
  const BList._(super.cname);
  static const list = BList._("list-group");
  Bootstrap get item => BListItem.item;
  Bootstrap get itemAction => BList._("list-group-item-action");
  Bootstrap get groupeFlush => BList._("list-group-flush");
  Bootstrap get groupeNumber => BList._("list-group-numbered");
  _BListGroupeHorizontal get horizontal => _BListGroupeHorizontal.horizontal;
}

///generale constante
const blistItem = BListItem.item;

///BlistItem
class BListItem extends Bootstrap {
  const BListItem._(super.cname);
  static const item = BListItem._("list-group-item");
  Icolor<BListItem> get colors => Icolor._(icname: cname, insertIndex: 2);
  Bootstrap get action => BListItem._("$cname-action");
  Bootstrap get disabled => BList._("disabled");
  Bootstrap get active => BList._("active");
}

///General constant
const blistHorizontal = _BListGroupeHorizontal.horizontal;

///BlistHorizontal
class _BListGroupeHorizontal extends Bootstrap implements Bscreen {
  static const horizontal = _BListGroupeHorizontal._("list-group-horizontal");

  const _BListGroupeHorizontal._(super.cname);

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen("xxl", cname, 3);
  }
}

///Generale constant
///**Use Bootstrap class**
///Use Bootstrap modal plugin to add dialogs to your site for lightboxes,
/// user notifications, or completely custom content.
/// * Use [BsElement] to set bootstrap modal class
/// ``Example:``<br>
/// ```dart
///    BsElement(
///     userParent: true,
///     child: BsElement(
///     userParent: true,
///     child: Column(
///         children: [
///             header(),
///           BsElement(child:Text("Body content"), bootstrap: [bmodal.body]),
///             footer()
///         ],
///         singleBootStrap: true,
///         bootstrap: [bmodal.content]),
///     bootstrap: fulldialogStyle),
///     bootstrap: modalStyle,
///     attributes: {
///     "tabindex": "-1",
///     },
///     dataset: {
///   if (static) ...staticAttribut
///     });
///```
///* You can also create a [modal.dialogScrollable]  that allows scroll the modal body by adding .
///
///**Vertically centered:** <br>
///Add ``modal.dialogCentered`` to Relement or Rview contenning [modal.dialog]
///to vertically center the modal.
///
///**Optional sizes:**<br>
/// User ``modal.{md,sm,xl,xxl}`` Modals have three optional sizes, available via modifier classes to be placed on a
/// Relement or Element containning a [modal.dialog].<br>
/// **Fullscreen Modal:** <br> Another override is the option to pop up a modal that covers the user viewport,
/// available via modifier classes that are placed on a .modal-dialog.
/// ``Class	Availability``<br>
/// [modal.fullscreen]	Always <br>
/// [modal.fullscreen.sm]	576px <br>
/// [modal.fullscreen.md]	768px <br>
/// [modal.fullscreen.lg]	992px <br>
/// [modal.fullscreen.xl]	1200px <br>
/// [modal.fullscreen.xxl]	1400px <br>
const bmodal = BModal.modal;

///**Use Bootstrap class**
///Use Bootstrap modal plugin to add dialogs to your site for lightboxes,
/// user notifications, or completely custom content.
/// * Use [BsElement] to set bootstrap modal class
/// ``Example:``<br>
/// ```dart
///    BsElement(
///     userParent: true,
///     child: BsElement(
///     userParent: true,
///     child: Column(
///         children: [
///             header(),
///           BsElement(child:Text("Body content"), bootstrap: [bmodal.body]),
///             footer()
///         ],
///         singleBootStrap: true,
///         bootstrap: [bmodal.content]),
///     bootstrap: fulldialogStyle),
///     bootstrap: modalStyle,
///     attributes: {
///     "tabindex": "-1",
///     },
///     dataset: {
///   if (static) ...staticAttribut
///     });
///```
class BModal extends Bootstrap implements Bscreen {
  const BModal._(super.cname);
  static const modal = BModal._("modal");
  Bootstrap get dialog => BModal._("modal-dialog");
  Bootstrap get content => BModal._("modal-content");
  Bootstrap get header => BModal._("modal-header");
  Bootstrap get title => BModal._("modal-title");
  Bootstrap get body => BModal._("modal-body");
  Bootstrap get fade => BModal._("fade");

  ///* You can also create a [modal.dialogScrollable]  that allows scroll the modal body by adding .
  Bootstrap get dialogScrollable => BModal._("modal-dialog-scrollable");

  ///**Vertically centered:** <br>
  ///Add ``modal.dialogCentered`` to Relement or Rview contenning [modal.dialog]
  ///to vertically center the modal.
  Bootstrap get dialogCentered => BModal._("modal-dialog-centered");
  Bootstrap get footer => BModal._("modal-footer");

  /// **Fullscreen Modal:** <br> Another override is the option to pop up a modal that covers the user viewport,
  /// available via modifier classes that are placed on a .modal-dialog.
  /// ``Class	Availability``<br>
  /// [modal.fullscreen]	Always <br>
  /// [modal.fullscreen.sm]	576px <br>
  /// [modal.fullscreen.md]	768px <br>
  /// [modal.fullscreen.lg]	992px <br>
  /// [modal.fullscreen.xl]	1200px <br>
  /// [modal.fullscreen.xxl]	1400px <br>
  _BsModalScreen get fullscreen => _BsModalScreen.fullscreen;
  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");
  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

class _BsModalScreen extends Bootstrap implements Bscreen {
  const _BsModalScreen(super.cname);
  static const fullscreen = _BsModalScreen("modal-fullscreen");

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  Bootstrap get lg => addScreen("lg-down");

  @override
  Bootstrap get md => addScreen("md-down");

  @override
  Bootstrap get sm => addScreen("sm-down");

  @override
  Bootstrap get xl => addScreen("xl-down");

  @override
  Bootstrap get xxl => addScreen("xxl-down");
}

///General const
final bnavbar = Bnavbar.navbar;

///Navbar
class Bnavbar extends Bootstrap {
  const Bnavbar._(super.cname);

  static const navbar = Bnavbar._("navbar");

  Bootstrap get brand => Bnavbar._("navbar-brand");
  BnavbarExpand get expand => BnavbarExpand.expand;
  Bootstrap get dark => Bnavbar._("navbar-dark");
  Bootstrap get light => Bnavbar._("navbar-light");
  Bootstrap get toggler => Bnavbar._("navbar-toggler");
  Bootstrap get text => Bnavbar._("navbar-text");
  Bootstrap get nav => Bnavbar._("navbar-nav");
  Bootstrap get collapse => Bnavbar._("navbar-collapse");
  Bootstrap get togglerIcon => Bnavbar._("navbar-toggler-icon");
  Bootstrap get scroll => Bnavbar._("navbar-nav-scroll");
}

///General const
final bnavbarExpand = BnavbarExpand.expand;

class BnavbarExpand extends Bootstrap implements Bscreen {
  const BnavbarExpand._(super.cname);
  static const expand = BnavbarExpand._("navbar-expand");
  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

///Generale const
///
final bnav = Bnav.nav;

class Bnav extends Bootstrap {
  const Bnav._(super.cname);
  static const nav = Bnav._("nav");
  static const navbar = Bnavbar._("navbar");
  Bootstrap get item => Bnavbar._("nav-item");
  Bootstrap get link => Bnavbar._("nav-link");
  Bootstrap get tabs => Bnav._("nav-tabs");
  Bootstrap get underline => Bnav._("nav-underline");
  Bootstrap get fills => Bnav._("nav-fills");
  Bootstrap get pills => Bnav._("nav-pills");
  Bootstrap get justified => Bnav._("nav-justified");
}

final btabs = BTabs.btabs;

class BTabs extends Bootstrap {
  const BTabs._(super.cname);
  static const btabs = BTabs._("nav-tabs");
  Bootstrap get content => BTabs._("tab-content");
  Bootstrap get panel => BTabs._("tab-pane");
}

//-----------------------OFFCANVASE-------------------/
///```
///General const
final boffcanvas = BoffCanvas.offcanvas;

class BoffCanvas extends Bootstrap implements Bscreen {
  const BoffCanvas._(super.cname);
  static const offcanvas = BoffCanvas._("offcanvas");
  Bootstrap get header => BoffCanvas._("offcanvas-header");
  Bootstrap get title => BoffCanvas._("offcanvas-title");
  Bootstrap get body => BoffCanvas._("offcanvas-body");
  Bootstrap get fade => BoffCanvas._("fade");

  /// **Fullscreen Modal:** <br> Another override is the option to pop up a modal that covers the user viewport,
  /// available via modifier classes that are placed on a .modal-dialog.
  /// ``Class	Availability``<br>
  /// [offcanvas.position.start] left<br>
  /// [offcanvas.position.end]	right<br>
  /// [offcanvas.position.top]	top <br>
  /// [offcanvas.position.bottom] bottom <br>
  BoffCanvasPosition get position => bcanvasPossition;
  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");
  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

///General const
final bcanvasPossition = BoffCanvasPosition.position;

class BoffCanvasPosition {
  final String cname;
  const BoffCanvasPosition(this.cname);
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  static const position = BoffCanvasPosition("offcanvas");

  Bootstrap get start => addScreen("start");

  // TODO: implement md
  Bootstrap get end => addScreen("end");

  Bootstrap get top => addScreen("top");

  Bootstrap get bottom => addScreen("bottom");
}

////--------------------------Pagination-----------///
///genral const
final bpagination = Bpagination.pagination;

class Bpagination extends Bootstrap implements Bscreen {
  const Bpagination._(super.cname);
  static const pagination = Bpagination._("pagination");
  Bootstrap get item => Bpagination._("page-item");
  Bootstrap get link => Bpagination._("page-link");
  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

////--------------------------PlaceHolder---------------------------////
final bplacehorder = BPlaceHolder.placeholder;

class BPlaceHolder extends Bootstrap implements Bscreen {
  const BPlaceHolder._(super.cname);
  static const placeholder = BPlaceHolder._("placeholder");
  Bootstrap get grow => BPlaceHolder._("placeholder-glow");
  Bootstrap get wave => BPlaceHolder._("placeholder-wav");

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

///------------------ProgressBar--------------------///
final bprogress = Bprogress.progress;

class Bprogress extends Bootstrap {
  const Bprogress._(super.cname);
  static const progress = Bprogress._("progress");
  Bootstrap get bar => Bprogress._("progress-bar");
  Bootstrap get stacked => Bprogress._("progress-stacked");
  Bootstrap get striped => Bprogress._(" progress-bar-striped");
}

///Generale const
final bspinnerBorder = Bspinner.border;
final bspinnerGrow = Bspinner.grow;

///------------------Spinners-----------------------///
final class Bspinner extends Bootstrap implements Bscreen {
  const Bspinner._(super.cname);

  static const border = Bspinner._("spinner-border");
  static const grow = Bspinner._("spinner-grow");
  static const none = Bspinner._("");

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  Bootstrap get sm => addScreen("sm");

  @override
  Bootstrap get xl => addScreen("xl");

  @override
  Bootstrap get xxl => addScreen("xxl");
}

/////--------------------Toasts------------///
final btoast = Btoast.toast;

class Btoast extends Bootstrap {
  const Btoast._(super.cname);
  static const toast = Btoast._("toast");
  Bootstrap get header => Btoast._("toast-header");
  Bootstrap get container => Btoast._("toast-container");

  Bootstrap get body => Btoast._("toast-body");
}

mixin BScreenMixin {
  String get param;
  int get insert => 1;
  Bootstrap get sx => _defaultAddScreen("sx", param, insert);
  Bootstrap get sm => _defaultAddScreen("sm", param, insert);
  Bootstrap get md => _defaultAddScreen("md", param, insert);
  Bootstrap get lg => _defaultAddScreen("lg", param, insert);
  Bootstrap get xl => _defaultAddScreen("xl", param, insert);
  Bootstrap get xxl => _defaultAddScreen("xxl", param, insert);
}

//////---------------Table------------------///
final btable = Btable.table;
final btableresponsive = Btable.tableResponsive;

final class Btable extends Bootstrap with BScreenMixin {
  const Btable._(super.cname);
  static const table = Btable._("table");
  static const tableResponsive = Btable._("table-responsive");
  Bootstrap get headLight => Btable._("thead-light");
  Bootstrap get headDark => Btable._("thead-dark");
  Bootstrap get striped => Btable._("table-striped");
  Bootstrap get bordered => Btable._("table-bordered");
  Bootstrap get hover => Btable._("table-hover");
  Bootstrap get active => Btable._("table-active");
  Btable get tableResponsivei => Btable._("table-responsive");
  @override
  // TODO: implement param
  String get param => cname;
}
