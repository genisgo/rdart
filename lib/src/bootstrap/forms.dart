part of 'bootstrap.dart';

///General const
final bsform = BsForm.form;

class BsForm extends Bootstrap implements Bscreen {
  const BsForm._(super.cname);
  static const form = BsForm._("form-control");
  Bootstrap get label => BsForm._("form-label");
  Bootstrap get text => BsForm._("form-text");
  Bootstrap get plaintext => BsForm._("form-control-plaintext");
  Bootstrap get color => BsForm._("form-control-color");
  Bootstrap get col => BsForm._("col-form-label");

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
