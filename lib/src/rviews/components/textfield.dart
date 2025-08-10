part of '../rview_bases.dart';

// //InputText

class TextField extends Relement {
  RStyle? style;
  String hinterText;
  Color focusColor;
  bool obscure;
  RStyle? onFocusStyle;
  Function(String? value)? onChange;
  TextField(
      {this.onChange,
      this.style,
      super.id,
      this.hinterText = "",
      this.onFocusStyle,
      this.obscure = false,
      this.focusColor = Colors.blue});
  var _div = TextInputElement();
  @override
  Element create() {
    _div.placeholder = hinterText;
    _div.className = "textfeild";
    //Set id
    if (id != null) _div.id = id!;
//Style
    style ??= RStyle(
        padding: REdgetInset.all(_currentTheme.defaultPadding),
        decoration: Decoration(
            border: Rborder.all(
                raduis: Raduis.all(4),
                side:
                    BorderSide(color: Colors.gray, style: BorderStyle.solid))));

    _div = style!.createStyle(_div) as TextInputElement;

    ///Events
    if (onChange != null) {
      _div.onInput.listen((event) {
        onChange!(_div.value);
      });
    }
    //
    _div.inputMode;

    ///onFocus
    _div.onFocus.listen((event) {
      _div.style.outline = "none";
      if (onFocusStyle == null) {
        _div.style.borderColor = focusColor.color;
      } else {
        onFocusStyle?.createStyle(_div);
      }
    });

    _div.addEventListener("focusout", (event) {
      style!.createStyle(_div);
    });
    return _div;
  }

  @override
  Element get getElement => _div;
}