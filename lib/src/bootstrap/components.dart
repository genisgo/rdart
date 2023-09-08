part of 'bootstrap.dart';

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
  static const bage = Bbage._("bage");
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
const bdropdown =Bdropdown.dropdown;

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
