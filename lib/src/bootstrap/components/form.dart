part of 'bs.components.dart';

class BsFormController {
  final String? controlID;
  FormElement? _form;

  FormElement? get form => _form;

  set form(FormElement? value) {
    _form = value;
  }

  BsFormController({this.controlID});

  bool checkValidity() {
    bool validited = !_form!.checkValidity();
    _form?.classes.add(bform.wasValidated.cname);
    if (validited) {
      //_isValided =false;
      // event.preventDefault();
      // event.stopPropagation();
      return false;
    }

    return true;
  }
}

class BsForm extends Relement {
  BsFormController? controller;
  final bool needsValidat;
  List<Bootstrap> style;
  List<Relement> children;
  BsForm(
      {this.needsValidat = true,
      this.children = const [],
      this.controller,
      super.id,
      this.style = const []});

  var _form = FormElement();
  @override
  Element create() {
    //SET ID
    var ids = id ?? "bsForm$generateId";

    ///Initialise element
    _form.children.clear();
    _form.id = ids;
    //set Controller
    controller?.form = _form;

    _form.className = [bform.needsValidation, ...style].join(" ");
    _form.noValidate = needsValidat;
    var chs = children.map((e) => e.create());

    _form.children.addAll(chs);
    print("ssett ${_form.innerHtml}");

//Validate event
    if (needsValidat) {
      _form.addEventListener("submit", (event) {
        if (!_form.checkValidity()) {
          event.preventDefault();
          event.stopPropagation();
        }
        _form.classes.add(bform.wasValidated.cname);
      }, false);
    }
    return _form;
  }

  FormElement get form => _form;
  @override
  // TODO: implement getElement
  Element get getElement => _form;
}
