part of 'utils.dart';
/// =============================================================
/// Utilitaires "Flutter-like"
/// =============================================================

class EdgeInsets {
  final double top, right, bottom, left;
  const EdgeInsets._(this.top, this.right, this.bottom, this.left);

  factory EdgeInsets.all(double v) => EdgeInsets._(v, v, v, v);
  factory EdgeInsets.symmetric({double vertical = 0, double horizontal = 0}) =>
      EdgeInsets._(vertical, horizontal, vertical, horizontal);
  factory EdgeInsets.only({double top = 0, double right = 0, double bottom = 0, double left = 0}) =>
      EdgeInsets._(top, right, bottom, left);

  String toCss() => '${top}px ${right}px ${bottom}px ${left}px';
}




class Border {
  final BorderSide? top;
  final BorderSide? right;
  final BorderSide? bottom;
  final BorderSide? left;
  final BorderSide? all;

  const Border({this.top, this.right, this.bottom, this.left, this.all});

  void applyTo(CssStyleDeclaration style) {
    if (all != null) {
      style.border = all!.toCss();
      return;
    }
    if (top != null) style.borderTop = top!.toCss();
    if (right != null) style.borderRight = right!.toCss();
    if (bottom != null) style.borderBottom = bottom!.toCss();
    if (left != null) style.borderLeft = left!.toCss();
  }
}

class Radius {
  final double r;
  const Radius.circular(this.r);
}

class BorderRadius {
  final Radius topLeft, topRight, bottomRight, bottomLeft;
  const BorderRadius._(this.topLeft, this.topRight, this.bottomRight, this.bottomLeft);

  factory BorderRadius.all(Radius r) => BorderRadius._(r, r, r, r);
  factory BorderRadius.only({Radius? topLeft, Radius? topRight, Radius? bottomRight, Radius? bottomLeft}) =>
      BorderRadius._(
        topLeft ?? const Radius.circular(0),
        topRight ?? const Radius.circular(0),
        bottomRight ?? const Radius.circular(0),
        bottomLeft ?? const Radius.circular(0),
      );

  String toCss() => '${topLeft.r}px ${topRight.r}px ${bottomRight.r}px ${bottomLeft.r}px';
}

class BoxShadow {
  final double offsetX, offsetY, blurRadius, spreadRadius;
  final String color; // CSS color
  const BoxShadow({
    this.offsetX = 0,
    this.offsetY = 2,
    this.blurRadius = 8,
    this.spreadRadius = 0,
    this.color = 'rgba(0,0,0,.15)',
  });

  String toCss() => '${offsetX}px ${offsetY}px ${blurRadius}px ${spreadRadius}px $color';
}

class LinearGradient {
  final List<String> colors;    // ex: ['#ff6b6b', '#feca57']
  final List<double>? stops;    // 0..1 (optionnel)
  final double angleDeg;        // 0=to right, 90=to bottom (CSS deg)
  const LinearGradient({required this.colors, this.stops, this.angleDeg = 180});

  String toCss() {
    if (stops != null && stops!.length == colors.length) {
      final parts = <String>[];
      for (var i = 0; i < colors.length; i++) {
        final pct = (stops![i] * 100).clamp(0, 100).toStringAsFixed(2);
        parts.add('${colors[i]} $pct%');
      }
      return 'linear-gradient(${angleDeg}deg, ${parts.join(', ')})';
    }
    return 'linear-gradient(${angleDeg}deg, ${colors.join(', ')})';
  }
}

class BoxConstraints {
  final double? minWidth, maxWidth, minHeight, maxHeight;
  const BoxConstraints({this.minWidth, this.maxWidth, this.minHeight, this.maxHeight});

  void applyTo(CssStyleDeclaration s) {
    if (minWidth != null) s.minWidth = '${minWidth}px';
    if (maxWidth != null) s.maxWidth = '${maxWidth}px';
    if (minHeight != null) s.minHeight = '${minHeight}px';
    if (maxHeight != null) s.maxHeight = '${maxHeight}px';
  }
}

enum AlignX { start, center, end, stretch }
enum AlignY { start, center, end, stretch }

class Alignment {
  final AlignX x;
  final AlignY y;
  const Alignment(this.x, this.y);

  static const center = Alignment(AlignX.center, AlignY.center);
  static const topLeft = Alignment(AlignX.start, AlignY.start);
  static const topCenter = Alignment(AlignX.center, AlignY.start);
  static const topRight = Alignment(AlignX.end, AlignY.start);
  static const centerLeft = Alignment(AlignX.start, AlignY.center);
  static const centerRight = Alignment(AlignX.end, AlignY.center);
  static const bottomLeft = Alignment(AlignX.start, AlignY.end);
  static const bottomCenter = Alignment(AlignX.center, AlignY.end);
  static const bottomRight = Alignment(AlignX.end, AlignY.end);
  static const stretch = Alignment(AlignX.stretch, AlignY.stretch);
}

class BoxDecoration {
  final String? color;
  final LinearGradient? gradient;
  final Border? border;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;
  final String? backgroundImageUrl;
  final String backgroundSize;     // 'cover' | 'contain' | 'auto ...'
  final String backgroundPosition; // 'center' | 'top left' ...
  final String backgroundRepeat;   // 'no-repeat' | 'repeat' ...

  const BoxDecoration({
    this.color,
    this.gradient,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.backgroundImageUrl,
    this.backgroundSize = 'cover',
    this.backgroundPosition = 'center',
    this.backgroundRepeat = 'no-repeat',
  });

  void applyTo(CssStyleDeclaration s) {
    if (color != null) s.backgroundColor = color!;
    if (gradient != null) s.backgroundImage = gradient!.toCss();
    if (borderRadius != null) s.borderRadius = borderRadius!.toCss();
    if (boxShadow != null && boxShadow!.isNotEmpty) {
      s.boxShadow = boxShadow!.map((b) => b.toCss()).join(', ');
    }
    if (border != null) border!.applyTo(s);
    if (backgroundImageUrl != null) {
      s.backgroundImage = 'url("$backgroundImageUrl")${gradient != null ? ', ${s.backgroundImage}' : ''}';
      s.backgroundSize = backgroundSize;
      s.backgroundPosition = backgroundPosition;
      s.backgroundRepeat = backgroundRepeat;
    }
  }
}
