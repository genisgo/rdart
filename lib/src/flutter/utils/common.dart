part of 'utils.dart';

enum BorderStyleCss { none, solid, dashed, dotted }

class BorderSide {
  final double width;
  final String color; // CSS color
  final BorderStyleCss style;
  const BorderSide({
    this.width = 1,
    this.color = 'rgba(0,0,0,.15)',
    this.style = BorderStyleCss.solid,
  });

  String toCss() => '${width}px ${_cssStyle(style)} $color';

  String _cssStyle(BorderStyleCss s) {
    switch (s) {
      case BorderStyleCss.none:
        return 'none';
      case BorderStyleCss.solid:
        return 'solid';
      case BorderStyleCss.dashed:
        return 'dashed';
      case BorderStyleCss.dotted:
        return 'dotted';
    }
  }
}
