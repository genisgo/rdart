part of 'rview_bases.dart';
class Decoration {
  final Color? backgroundColor;
  final Rborder border;
  final BoxShadow? shadow;
  const Decoration(
      {this.border = Rborder.none, this.backgroundColor, this.shadow});

  Decoration copyWith(
      Color? backgroundColor, Rborder? border, BoxShadow? shadow) {
    return Decoration(
        backgroundColor: backgroundColor ?? this.backgroundColor,
        border: border ?? this.border,
        shadow: shadow ?? this.shadow);
  }
}
