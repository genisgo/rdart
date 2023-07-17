import 'package:rdart/rdart.dart';
import 'data_themes.dart';

///DataTheme Implementation
class Theme extends DataTheme {
  static const DataTheme defaultTheme = Theme();
  static const RStyle defaultAppbar = RStyle(
    backgroundColor: defaultColor,
  );
  static const Color defaultColor = Colors.blue;
  static const Color defaultBackgroundColor = Colors.white;
  static const int padding = 10;
  static const TextDataTheme defaultTextTheme = TextTheme();
  const Theme(
      {super.appBarStyle = Theme.defaultAppbar,
      super.textTheme = Theme.defaultTextTheme,
      super.primaryColor = Theme.defaultColor,
      super.textFieldTheme = TextFeildTheme.defaultTextFieldTheme,
      super.defaultPadding = Theme.padding,
      super.buttonTheme = DefaultButtonTheme.defaultButtonTheme,
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
class DefaultButtonTheme extends ButtonDataTheme {
  static const ButtonDataTheme defaultButtonTheme = DefaultButtonTheme();
  static const _buttonDefaultStyle = RStyle(
      width: 100,
      height: 45,
      decoration: Decoration(
          backgroundColor: Colors.white,
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(raduis: Raduis.all(8))));

  static const _errorButtonStyle = RStyle(
      width: 100,
      height: 45,
      decoration: Decoration(
          backgroundColor: Colors.white,
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(
              raduis: Raduis.all(8), side: BorderSide(color: Colors.red))));
  static const _successButtonStyle = RStyle(
      width: 100,
      height: 45,
      decoration: Decoration(
          backgroundColor: Colors.white,
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(
              raduis: Raduis.all(8), side: BorderSide(color: Colors.green))));
  static const _disbalbeButtonStyle = RStyle(
      width: 100,
      height: 45,
      decoration: Decoration(
          backgroundColor: Colors.white,
          shadow: BoxShadow(blur: 3, horizontal: 1, vertical: 1),
          border: Rborder(
              raduis: Raduis.all(8), side: BorderSide(color: Colors.green))));
  const DefaultButtonTheme(
      {super.suscessButton = _successButtonStyle,
      super.errorButton = DefaultButtonTheme._errorButtonStyle,
      super.disableButton = DefaultButtonTheme._disbalbeButtonStyle,
      super.defaultStyle = DefaultButtonTheme._buttonDefaultStyle});
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
