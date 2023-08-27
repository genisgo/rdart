part of 'bootstrap.dart';

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