import 'package:rdart/rviews.dart';
import 'data_themes.dart';

///DataTheme Implementation
class Theme extends DataTheme {
  static const DataTheme defaultTheme = Theme();
  static const RStyle defaultAppbar = RStyle(
    backgroundColor: defaultColor,
  );
  static const Color defaultColor = Colors.blue;
  static const Color defaultBackgroundColor = Colors.white;
  static const double padding = 10;
  static const TextDataTheme defaultTextTheme = TextTheme();
  const Theme(
      {super.appBarStyle = Theme.defaultAppbar,
      super.textTheme = Theme.defaultTextTheme,
      super.primaryColor = Theme.defaultColor,
      super.textFieldTheme = TextFeildTheme.defaultTextFieldTheme,
      super.defaultPadding = Theme.padding,
      super.buttonTheme = ButtonTheme.defaultButtonTheme,
      super.backgroundColor = Theme.defaultBackgroundColor});
}

///TextTheme
class TextTheme extends TextDataTheme {
  const TextTheme(
      {super.header1 = const RStyle(textSize: 22),
      super.header2 = const RStyle(textSize: 20),
      super.header3 = const RStyle(textSize: 18),
      super.headerDefaulColor = Colors.Black,
      super.body1 = const RStyle(textSize: 14),
      super.body2 = const RStyle(textSize: 12)});
}

///ButtonStyle
class ButtonTheme extends ButtonDataTheme {
  static const ButtonDataTheme defaultButtonTheme = ButtonTheme();
  static const _buttonDefaultStyle = RStyle(
      height: 45,
      width: 100,
      padding: REdgetInset.all(10),
      backgroundColor: Theme.defaultColor,
      decoration: Decoration(
        border: Rborder.all(raduis: Raduis.all(4), side: BorderSide()),
      ));

  static const _errorButtonStyle = RStyle(
      height: 45,
      width: 100,
      padding: REdgetInset.all(10),
      backgroundColor: Colors.danger,
      decoration: Decoration(
        border: Rborder.all(raduis: Raduis.all(4), side: BorderSide()),
      ));
  static const _successButtonStyle = RStyle(
      height: 45,
      width: 100,
      padding: REdgetInset.all(10),
      backgroundColor: Colors.success,
      decoration: Decoration(
        border: Rborder.all(raduis: Raduis.all(4), side: BorderSide()),
      ));
  static const _disbalbeButtonStyle = RStyle(
      width: 100,
      height: 45,
      backgroundColor: Colors.white,
      decoration: Decoration(
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(
              raduis: Raduis.all(8), side: BorderSide(color: Colors.green))));
  const ButtonTheme(
      {super.suscessButton = _successButtonStyle,
      super.errorButton = ButtonTheme._errorButtonStyle,
      super.disableButton = ButtonTheme._disbalbeButtonStyle,
      super.defaultStyle = ButtonTheme._buttonDefaultStyle});
}

///TextFieldDataTheme

class TextFeildTheme extends TextFieldDataTheme {
  static const TextFieldDataTheme defaultTextFieldTheme = TextFeildTheme();
  static const RStyle _textFieldDefaultStyle = RStyle(
      padding: REdgetInset.all(Theme.padding),
      decoration: Decoration(
          border: Rborder.all(
              raduis: Raduis.all(4),
              side: BorderSide(color: Colors.gray, style: BorderStyle.solid))));
  const TextFeildTheme(
      {super.defaultPadding = Theme.padding,
      super.style = TextFeildTheme._textFieldDefaultStyle});
}
