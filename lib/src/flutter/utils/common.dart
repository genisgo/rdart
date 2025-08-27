part of 'utils.dart';

enum BorderStyleCss { none, solid, dashed, dotted }

class BorderSide {
  final double width;
  final Color color; // CSS color
  final BorderStyleCss style;
  const BorderSide({
    this.width = 1,
    this.color =const Color('rgba(0,0,0,.15)'),
    this.style = BorderStyleCss.solid,
  });

  String toCss() => '${width}px ${_cssStyle(style)} ${color.color}';

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

///Convertir [BsIcon] en html
String iconToHtml(BsIcon icon) => icon.create().outerHtml!;
