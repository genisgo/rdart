part of 'rview_bases.dart';
class Color {
  final String color;
  const Color(this.color);
}

class Colors extends Color {
  static const transparent =Color("#00000000");
  static const none =Color("");
  static const White = Color("White");
  static const Black = Color("Black");
  static const Blue = Color("Blue");
  static const Red = Color("red");
  static const gray = Color("gray");
  static const blue = Color("#1b87c9");
  static const indigo = Color("#6610f2");
  static const purple = Color("#6f42c1");
  static const pink = Color("#e83e8c");
  static const red = Color("#dc3545");
  static const orange = Color("#fd7e14");
  static const yellow = Color("#ffc107");
  static const green = Color(" #28a745");
  static const teal = Color("#1FBAAC");
  static const cyan = Color("#17a2b8");
  static const white = Color("#fff");
  static const grays = Color("#6c757d");
  static const graydark = Color("#343a40");
  static const primary = Color("#1967D2");
  static const secondary = Color("#6c757d");
  static const success = Color("#28a745");
  static const info = Color("#17a2b8");
  static const warning = Color("#ffc107");
  static const danger = Color("#dc3545");
  static const light = Color("#f8f9fa");
  static const dark = Color("#343a40");
  static const primaryColor =  Colors.formRGB(65, 83, 247,);
  static const primaryColorLite =  Colors.formRGB(65, 83, 247,0.9);
  static const dodgerblue = Color("dodgerblue");
  
  const Colors.formRGB(final int r, final int g, final int b,[double opacity=1])
      : super("rgb($r,$g,$b,$opacity)");
}
