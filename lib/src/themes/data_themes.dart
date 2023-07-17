import 'package:rdart/rdart.dart';

abstract class DataTheme {
  final RStyle appBarStyle;
  final TextDataTheme textTheme;
  final ButtonDataTheme buttonTheme;
  final Color primaryColor;
  final int defaultPadding;
  final Color backgroundColor;
  final TextFieldDataTheme textFieldTheme;

  const DataTheme(
      {required this.appBarStyle,
      required this.textTheme,
      required this.buttonTheme,
      required this.primaryColor,
      required this.textFieldTheme,
      required this.defaultPadding,
      required this.backgroundColor});
}

abstract class ButtonDataTheme {
  final RStyle suscessButton;
  final RStyle errorButton;
  final RStyle disableButton;
  final RStyle defaultStyle;
  const ButtonDataTheme(
      {required this.suscessButton,
      required this.errorButton,
      required this.disableButton,
      required this.defaultStyle});
}

abstract class TextFieldDataTheme {
  final int defaultPadding;
  final RStyle style;
  const TextFieldDataTheme({required this.defaultPadding, required this.style});
}

abstract class TextDataTheme {
  final RStyle header1;
  final RStyle header2;
  final RStyle header3;
  final Color headerDefaulColor;
  final RStyle body1;
  final RStyle body2;
  static const double size = 10;

  const TextDataTheme({
    required this.header1,
    required this.header2,
    required this.header3,
    required this.headerDefaulColor,
    required this.body1,
    required this.body2,
  });

  //
}

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
