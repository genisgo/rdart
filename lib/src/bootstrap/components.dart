part of 'bootstrap.dart';

///Click the accordions below to expand/collapse the accordion content.
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
 ***/
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
final bcard = Bcard.card;

///Use to creat card a generale constante [bcard] or
///[Bcard.card]
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
