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
  String? fileAccept;

  void Function(dynamic value)? onChange;
  String? value;
  String? min;
  String? max;
  int? minLength;
  int? maxLength;
  List<Bootstrap> labelStyle;
  List<Bootstrap> inputStyle;
  DataList? list;
  BsInput({
    this.onChange,
    this.id,
    this.fileAccept,
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
  final _div = Element.div();

  @override
  Element create() {
    id ??= "input$generateId";
    //label
    _labelElement.attributes.addAll({
      "for": "$id",
    });

    ///set Style
    _labelElement.className += [bsform.label, ...labelStyle].join(" ");
    _input.className += [bsform, ...inputStyle].join(" ");

    //input
    _input.type = type.name;
    _input.id = id!;

    //set placeholder
    if (placeholder != null) _input.placeholder = placeholder!;

    //attrib readOnly et multiple
    _input.readOnly = readonly;
    _input.multiple = multiple;
    //set name
    if (name != null) _input.name = name;
    _input.attributes.addAll({if (list != null) "list": list!.id});

    //set color class
    if (type == InputType.color) {
      _input.className += " ${bsform.color}";
    }

    //max and mine
    if (maxLength != null) _input.maxLength = maxLength;
    if (minLength != null) _input.minLength = minLength;
    if (min != null) _input.min = min;
    if (max != null) _input.max = max;

    //set input value
    final noUseDefaultValueIf =
        [InputType.file, InputType.image, InputType].contains(type);
    if (value != null && noUseDefaultValueIf) {
      _input.value = value;
    }

    ///[InputType]
    //if type is file
    if (type == InputType.file) {
      _input.accept = fileAccept;
    }
    //if is CheckBox
    if (type == InputType.checkbox) {
      _div.className = [bformCheck].join(" ");
      _input.className = [bformCheck.input, ...inputStyle].join(" ");
      _labelElement.className = [bformCheck.label, ...labelStyle].join(" ");
    }

    //add elements
    if (labelChild != null) _labelElement.children.add(labelChild!.create());

    if (label != null) _labelElement.innerText += label!;

    _div.children.addAll([_labelElement, _input]);

    if (list != null) _div.children.add(list!.create());
    //set Event
    _input.addEventListener("input", (event) {
      var target = event.target as InputElement;
      if (type == InputType.file) {
        onChange?.call(target.files);
        return;
      }
      if (type == InputType.checkbox) {
        onChange?.call(target.checked);
        return;
      }
      onChange?.call((event.target as InputElement).value);
    });
    //
    return _div;
  }

  Element get labelElement => _labelElement;
  Element get inputElement => _input;
  @override
  // TODO: implement getElement
  Element get getElement => _div;
}
