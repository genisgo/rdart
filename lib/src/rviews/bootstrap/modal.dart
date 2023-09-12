import 'package:rdart/bootstrap.dart';

///Generale constant
const bmodal = BModal.modal;

class BModal extends Bootstrap {
  const BModal._(super.cname);
  static const modal = BModal._("modal");
  Bootstrap get dialog => BModal._("modal-dialog");
  Bootstrap get content => BModal._("modal-content");
  Bootstrap get header => BModal._("modal-header");
  Bootstrap get title => BModal._("modal-title");
  Bootstrap get body => BModal._("modal-body");
  Bootstrap get dialogScrollable => BModal._("modal-dialog-scrollable");
  Bootstrap get dialogCentered => BModal._("modal-dialog-centered");
  
}
