part of 'bases.dart';

class Rborder {
  final BorderSide side;
  final Raduis raduis;
  final BorderSide? left;
  final BorderSide? right;
  final BorderSide? top;
  final BorderSide? bottom;

  static const none = Rborder();
  const Rborder(
      {this.raduis = Raduis.zero,
      this.side = BorderSide.none,
      this.bottom,
      this.left,
      this.right,
      this.top});

  const Rborder.all(
      {BorderSide side = BorderSide.none, Raduis raduis = Raduis.zero})
      : this(bottom: side, left: side, right: side, top: side, raduis: raduis);
  @override
  String toString() {
    return side.toString();
  }
}

// bodersid
class BorderSide {
  //Saide
  final double side;
  final Color color;
  final BorderStyle style;
  static const none = BorderSide();
  const BorderSide(
      {this.color = Colors.Black,
      this.side = 1,
      this.style = BorderStyle.none});
  @override
  String toString() {
    return "${color.color} ${side}px ${style.name}";
  }
}

class Raduis {
  final int topLeft;
  final int topRight;
  final int bottomLeft;
  final int bottomRight;
  static const Raduis zero = Raduis();
  const Raduis(
      {this.topRight = 0,
      this.topLeft = 0,
      this.bottomRight = 0,
      this.bottomLeft = 0});

  const Raduis.all(int value)
      : this(
            topRight: value,
            topLeft: value,
            bottomRight: value,
            bottomLeft: value);

  @override
  String toString() {
    // conversion en Text Css
    return "${topRight}px ${topLeft}px ${bottomRight}px ${bottomLeft}px";
  }
}
