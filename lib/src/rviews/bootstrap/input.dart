part of 'bs.components.dart';

enum InputType {
  button,
  checkbox,
  color,
  date,
  email,
  file,
  hidden,
  image,
  month,
  number,
  password,
  radio,
  range,
  reset,
  submit,
  tel,
  text,
  search,
  time,
  url,
  week
//datetime-local
}

class BsInput extends Relement {
  String? id;
  Relement? labelChild;
  String? label;
  bool readonly;
  String? name;
  String? placeholder;
  bool multiple;
  InputType type;
  var value;
  String? min;
  String? max;
  int? minLength;
  int? maxLength;
  List<Bootstrap> labelStyle;
  List<Bootstrap> inputStyle;
  DataList? list;
  BsInput({
    this.id,
    this.readonly = false,
    this.label,
    this.multiple = false,
    this.type = InputType.text,
    this.placeholder,
    this.inputStyle = const [],
    this.labelStyle = const [],
    this.list,
    this.name,
    this.labelChild,
    this.min,
    this.max,
    this.minLength,
    this.maxLength,
    this.value,
  });
  final _labelElement = LabelElement();
  final _input = InputElement();
  var _div = Element.div();

  @override
  Element create() {
    id ??= "input$generateId";
    //label
    _labelElement.attributes.addAll({
      "for": "$id",
    });

    _labelElement.className += [bsform.label, ...labelStyle].join(" ");
    //input
    _input.type = type.name;
    _input.className += [bsform, ...inputStyle].join(" ");
    _input.id = id!;
    //set placeholder
    if (placeholder != null) _input.placeholder = placeholder!;
    //attrib readOnly et multiple
    _input.readOnly = readonly;
    _input.multiple = multiple;
    _input.attributes.addAll({if (list != null) "list": list!.id});
    //set color class
    if (type == InputType.color) {
      _input.className += " ${bsform.color}";
    }

    if (maxLength != null) _input.maxLength = maxLength;
    if (minLength != null) _input.minLength = minLength;
    if (min != null) _input.min = min;
    if (max != null) _input.max = max;

    //div
    if (label != null || labelChild != null) {
      if (labelChild != null) {
        _labelElement.children.add(labelChild!.create());
      } else {
        if (label != null) _labelElement.innerText = label!;
      }

      _div.children.addAll([_labelElement, _input]);
      return _div;
    }
    //if label is null
    _div = _input;
    return _div;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}
