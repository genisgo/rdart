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
  String iconUrl;
  Relement? labelChild;
  String? label;
  bool readonly;
  bool singleInput;
  String? name;
  String? placeholder;
  bool multiple;
  InputType type;
  String? fileAccept;
  bool labelFloating;
  bool checkSwitch;
  bool reversed;
  bool groupeMode;
  Relement? invalidMessage;
  Relement? validedMessage;
  void Function(dynamic value)? onChange;
  String? value;
  String? min;
  String? max;
  bool btnCheck;
  int? minLength;
  int? maxLength;
  bool disable;
  String? step;
  List<Bootstrap> labelStyle;
  List<Bootstrap> inputStyle;
  DataList? list;
  bool requred;

  BsInput({
    this.onChange,
    this.iconUrl = "",
    this.requred = false,
    this.groupeMode = false,
    this.labelFloating = false,
    this.singleInput = false,
    this.btnCheck = false,
    this.checkSwitch = false,
    super.id,
    this.reversed = false,
    this.disable = false,
    this.fileAccept,
    this.step,
    this.readonly = false,
    this.label,
    this.invalidMessage,
    this.validedMessage,
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
  var _labelElement = LabelElement();
  var _input = InputElement();
  var _div = Element.div();

  @override
  Element create() {

    _div.children.clear();
    String ids = id ?? "input$generateId";
    //label
    _labelElement.attributes.addAll({
      "for": ids,
    });

    ///set Style
    _labelElement.className = [
      if (groupeMode) binputGroup.text else bform.label,
      ...labelStyle
    ].join(" ");
    _input.className = [bform, ...inputStyle].join(" ");
    _div.className = [if (groupeMode) binputGroup].join(" ");
    //input
    _input.type = type.name;
    _input.id = ids;
    _input.required = requred;
    _input.disabled = disable;
    //set placeholder
    if (placeholder != null) _input.placeholder = placeholder!;

    //attrib readOnly et multiple
    _input.readOnly = readonly;
    _input.multiple = multiple;
    //set name
    if (name != null) _input.name = name;
    _input.attributes.addAll({if (list != null) "list": "${list?.id}"});

    //set color class
    if (type == InputType.color) {
      _input.className += " ${bform.color}";
    }

    //max and mine
    if (maxLength != null) _input.maxLength = maxLength;
    if (minLength != null) _input.minLength = minLength;
    if (min != null) _input.min = min;
    if (max != null) _input.max = max;

    //set input value
    final noUseDefaultValueIf =
        [InputType.file, InputType.image].contains(type);
    if (value != null && !noUseDefaultValueIf) {
      _input.value = value;
    }
    //use floating label mode
    if (labelFloating) {
      _div.className = bform.floating.cname;
      reversed = true; //reversed label and input disposition
    }

    ///[InputType]
    //if type is file
    if (type == InputType.file) {
      _input.accept = fileAccept;
    }
    //if is CheckBox
    if (type == InputType.checkbox) {
      _input.attributes.addAll({if (checkSwitch) "role": "switch"});

      _div.className = [
        bformCheck,
        if (checkSwitch) bform.switchs,
      ].join(" ");

      _input.className = [
        if (btnCheck) bformCheck.btn else bformCheck.input,
        ...inputStyle
      ].join(" ");

      _labelElement.className =
          [if (!btnCheck) bformCheck.label, ...labelStyle].join(" ");
    }
    //if type is
    if (type == InputType.range) {
      _input.className = [bform.range, ...inputStyle].join(" ");
      min ??= "0";
      max ??= "100";
      _input.min = min;
      _input.max = max;
    }

    ///set Step
    _input.step = step;
    //add elements
    if (labelChild != null) _labelElement.children.add(labelChild!.create());
    //create relement
    invalidMessage?.create();
    invalidMessage?.getElement.className += " ${[bform.invalidFeed].join(" ")}";
    validedMessage?.create();
    validedMessage?.getElement.className += " ${[bform.validFeed].join()}";

    //
    if (label != null) _labelElement.innerText = label!;
    var content = [
      _labelElement,
      //Si singleInput est activer _input ne doit pas être ajouter a ce niveau
      //car cela vas provoquer un double ajout en bas line (223 -225)
      if (!singleInput) _input,
      if (invalidMessage != null) invalidMessage!.getElement,
      if (validedMessage != null) validedMessage!.getElement
    ];

    //if is btnCheck mode
    if (btnCheck || reversed) content = content.reversed.toList();

    _div.children.addAll(content);

    if (list != null) _div.children.add(list!.create());

    //set Event
    _input.addEventListener("input", (event) {
      var target = event.target as InputElement;
      switch (type) {
        case InputType.file:
          onChange?.call(target.files);
          break;
        case InputType.checkbox:
          onChange?.call(target.checked);
          break;
        default:
          onChange?.call((event.target as InputElement).value);
      }
    });
    //if label is Null en childLabel is null throw singleInput at true
    if (label == null && labelChild == null) singleInput = true;
    if (singleInput) {
      //_div.children.clear();
      _div = _input;
    }
    //Change icon
    _input.style.setProperty("background-image", "url($iconUrl)");
    return _div;
  }

  Element get labelElement => _labelElement;
  Element get inputElement => _input;

  @override
  // TODO: implement getElement
  Element get getElement => _div;
}
