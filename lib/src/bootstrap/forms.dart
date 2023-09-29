part of 'bootstrap.dart';

///General const
final bsform = BsInputForm.form;

class BsInputForm extends Bootstrap implements Bscreen {
  const BsInputForm._(super.cname);
  static const form = BsInputForm._("form-control");
  Bootstrap get label => BsInputForm._("form-label");
  Bootstrap get text => BsInputForm._("form-text");
  Bootstrap get plaintext => BsInputForm._("form-control-plaintext");
  Bootstrap get color => BsInputForm._("form-control-color");
  Bootstrap get col => BsInputForm._("col-form-label");

  @override
  Bootstrap addScreen(param) {
    return _defaultAddScreen(param, cname, 2);
  }

  @override
  // TODO: implement lg
  Bootstrap get lg => addScreen("lg");

  @override
  // TODO: implement md
  Bootstrap get md => addScreen("md");

  @override
  // TODO: implement sm
  Bootstrap get sm => addScreen("sm");

  @override
  // TODO: implement xl
  Bootstrap get xl => addScreen("xl");

  @override
  // TODO: implement xxl
  Bootstrap get xxl => addScreen("xxl");
}

///Generale const
final bformSelect = BformSelect.select;

class BformSelect extends Bootstrap {
  const BformSelect._(super.cname);
  static const select = BformSelect._("form-select");
}

///General const
final bformCheck = BformCheck.check;

class BformCheck extends Bootstrap {
  const BformCheck._(super.cname);
  static const check = BformCheck._("form-check");

  Bootstrap get input => BformCheck._("form-check-input");
  Bootstrap get label => BformCheck._("form-check-label");
  Bootstrap get inline => BformCheck._("form-check-inline");
  Bootstrap get reverse => BformCheck._("form-check-reverse");
}
