part of 'bs.components.dart';

class BsForm extends Relement {
  String? id;
  final _form = FormElement();
  final bool needsValidat;
  List<Relement> children;
  BsForm({this.needsValidat = true, this.children = const [], this.id});

  @override
  Element create() {
    id ??= "bsForm$generateId";
    _form.id = id!;

    _form.className = [bform.needsValidation].join(" ");
    _form.noValidate = needsValidat;
    _form.children.addAll(children.map((e) => e.create()));

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

  @override
  // TODO: implement getElement
  Element get getElement => _form;
}
