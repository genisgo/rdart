import 'package:rdart/rviews.dart';

abstract class DataTheme {
  final RStyle appBarStyle;
  final TextDataTheme textTheme;
  final ButtonDataTheme buttonTheme;
  final Color primaryColor;
  final double defaultPadding;
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
  final double defaultPadding;
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
