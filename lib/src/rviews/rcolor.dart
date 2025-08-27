part of 'rview_bases.dart';

base class Color {
  final String color;

  const Color(this.color);
}

base class Colors extends Color {
  static const transparent = Color("#00000000");
  static const none = Color("");
  // static const white = Color("#fff");
  static const black = Color("#000000");
  // static const Blue = Color("#1b87c9");
  // static const Red = Color("red");
  // static const gray = Color("gray");
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
  static const gray = Color("#6c757d");
  static const graydark = Color("#343a40");
  static const primary = Color("#1967D2");
  static const secondary = Color("#6c757d");
  static const success = Color("#28a745");
  static const info = Color("#17a2b8");
  static const warning = Color("#ffc107");
  static const danger = Color("#dc3545");
  static const light = Color("#f8f9fa");
  static const dark = Color("#343a40");
  static const primaryColor = Colors.formRGB(65, 83, 247);
  static const primaryColorLite = Colors.formRGB(65, 83, 247, 0.9);
  static const dodgerblue = Color("dodgerblue");

  const Colors.formRGB(
    final int r,
    final int g,
    final int b, [
    double opacity = 1,
  ]) : super("rgb($r,$g,$b,$opacity)");
}

/// Couleur type-safe (RGBA) – sans dépendre de Bootstrap
base class MaterialColor implements Color {
  final int r;
  final int g;
  final int b;
  final double a;
  const MaterialColor(this.r, this.g, this.b, [this.a = 1.0]);

   factory MaterialColor.fromHex(String hex) {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 3) {
      // #RGB → #RRGGBB
      h = h.split('').map((c) => '$c$c').join();
    }
    if (h.length == 6) {
      final r = int.parse(h.substring(0, 2), radix: 16);
      final g = int.parse(h.substring(2, 4), radix: 16);
      final b = int.parse(h.substring(4, 6), radix: 16);
      return MaterialColor(r, g, b, 1);
    } else if (h.length == 8) {
      final a = int.parse(h.substring(0, 2), radix: 16) / 255.0;
      final r = int.parse(h.substring(2, 4), radix: 16);
      final g = int.parse(h.substring(4, 6), radix: 16);
      final b = int.parse(h.substring(6, 8), radix: 16);
      return MaterialColor(r, g, b, a);
    }
    throw ArgumentError('Hex color invalide: $hex');
  }

  /// to CSS rgba(r,g,b,a)
  String toCss({double opacityMultiplier = 1.0}) {
    final oa = (a * opacityMultiplier).clamp(0.0, 1.0);
    return 'rgba($r,$g,$b,$oa)';
  }

  /// Couleur avec alpha remplacé
  Color withAlpha(double alpha) => MaterialColor(r, g, b, alpha);

  @override
  // TODO: implement color
  String get color => toCss();
}
