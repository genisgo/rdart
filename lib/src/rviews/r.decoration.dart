part of 'rview_bases.dart';
class Decoration {
  final Rborder border;
  final BoxShadow? shadow; 
  const Decoration(
      {this.border = Rborder.none, this.shadow});

  Decoration copyWith({
      Color? backgroundColor, Rborder? border, BoxShadow? shadow}) {
    return Decoration(
        border: border ?? this.border,
        shadow: shadow ?? this.shadow);
  }
}
