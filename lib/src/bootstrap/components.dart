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

class BAlert extends Bootstrap {
  const BAlert._(super.cname);
  static const alert = BAlert._("alert");

  static const primary = BAlert._("alert-primary");

  static const success = BAlert._("alert-success");

  static const danger = BAlert._("alert-danger");

  static const warning = BAlert._("alert-warning");

  static const info = BAlert._("alert-info");

  static const light = BAlert._("alert-light");

  static const dark = BAlert._("alert-dark");

  static const link = BAlert._("alert-link");

  static const heading = BAlert._("alert-heading");

/***
Be sure you’ve loaded the alert plugin, or the compiled Bootstrap JavaScript.
Add a close button and the .alert-dismissible class, which adds extra padding to the right of the alert and positions the close button.
On the close button, add the data-bs-dismiss="alert" attribute, which triggers the JavaScript functionality. Be sure to use the <button> element with it for proper behavior across all devices.
To animate alerts when dismissing them, be sure to add the .fade and .show classes.
 ***/
  static const Bootstrap disimissible =
      BAlert._("alert-dismissible alert-dismissible fade show");
}

class Bbage extends Bootstrap {
  const Bbage._(super.cname);
  static const bage = Bbage._("bage");
}

///Breadcrumb
class Bbreadcrumb extends Bootstrap {
  const Bbreadcrumb._(super.cname);
  static const breadcrumb = Bbreadcrumb._("breadcrumb");
  static const breadcrumbItem = Bbreadcrumb._("breadcrumb-item");
  static const active = Bbreadcrumb._("active");
}
