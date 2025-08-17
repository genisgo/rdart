part of 'widgets.dart';

/// =============================================================
/// 3) RText – mini Text configurable (taille, poids, align, ellipsis)
/// =============================================================


class Text extends Relement {
   String data;

  // Style
  final Color? color;           // ex: '#222' ou 'rgba(...)'
  final double? fontSize;        // px
  final FontWeightCss? fontWeight;
  final FontStyleCss fontStyle;
  final String? fontFamily;
  final double? letterSpacing;   // px
  final double? wordSpacing;     // px
  final double? height;          // line-height (ex: 1.4 => 1.4em)
  final TextDecorationKind decoration;
  final String? decorationColor;

  // Layout
  final TextAlign textAlign;
  final bool softWrap;
  final int? maxLines;           // null = illimité ; 1 = single-line
  final TextOverflowCss overflow;
  final bool selectable;         // true => le texte est sélectionnable
  final List<Bootstrap> bootstrap;

  Text(
    this.data, {
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle = FontStyleCss.normal,
    this.fontFamily,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration = TextDecorationKind.none,
    this.decorationColor,

    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.maxLines,
    this.overflow = TextOverflowCss.visible,
    this.selectable = true,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'text-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-text', ...bootstrap.map((e) => e.cname,)]);

    final s = _root.style;

    // contenu
    _root.text = data;

    // couleur & typo
    if (color != null) s.color = color!.color;
    if (fontSize != null) s.fontSize = '${fontSize}px';
    if (fontWeight != null) s.fontWeight = _cssWeight(fontWeight!);
    if (fontStyle == FontStyleCss.italic) s.fontStyle = 'italic';
    if (fontFamily != null) s.fontFamily = fontFamily!;
    if (letterSpacing != null) s.letterSpacing = '${letterSpacing}px';
    if (wordSpacing != null) s.wordSpacing = '${wordSpacing}px';
    if (height != null) s.lineHeight = height!.toString();

    // décoration
    switch (decoration) {
      case TextDecorationKind.none:
        s.textDecoration = 'none';
        break;
      case TextDecorationKind.underline:
        s.textDecoration = 'underline';
        break;
      case TextDecorationKind.overline:
        s.textDecoration = 'overline';
        break;
      case TextDecorationKind.lineThrough:
        s.textDecoration = 'line-through';
        break;
    }
    if (decorationColor != null) _root.style.setProperty('text-decoration-color', decorationColor!);

    // alignement
    s.textAlign = _cssAlign(textAlign);

    // sélection
    s.userSelect = selectable ? 'text' : 'none';

    // wrapping & overflow
    if (maxLines == null) {
      // multi-lignes libre
      s.whiteSpace = softWrap ? 'pre-wrap' : 'pre';
      s.overflow = _cssOverflowBase(overflow);
      if (overflow == TextOverflowCss.ellipsis) {
        // ellipsis multi-ligne n'a de sens que si on clamp (sinon visible)
        // ici, sans maxLines, ellipsis = single-line
        s.whiteSpace = 'nowrap';
        s.textOverflow = 'ellipsis';
      }
    } else {
      // clamp de lignes
      if (maxLines == 1) {
        s.whiteSpace = 'nowrap';
        s.overflow = 'hidden';
        s.textOverflow = (overflow == TextOverflowCss.ellipsis) ? 'ellipsis' : 'clip';
      } else {
        // multi-lignes avec clamp
        s.display = '-webkit-box';
        s.setProperty('-webkit-line-clamp', '${maxLines!}');
        s.setProperty('-webkit-box-orient', 'vertical');
        s.overflow = 'hidden';
        // pas de vrai ellipsis standard multi-ligne hors -webkit, mais acceptable
      }
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  // helpers
  void setText(String value) {
    _root.text = value;
  }

  // mappings
  String _cssAlign(TextAlign a) {
    switch (a) {
      case TextAlign.start:   return 'start';
      case TextAlign.center:  return 'center';
      case TextAlign.end:     return 'end';
      case TextAlign.justify: return 'justify';
    }
  }

  String _cssWeight(FontWeightCss w) {
    switch (w) {
      case FontWeightCss.normal: return '400';
      case FontWeightCss.bold:   return '700';
      case FontWeightCss.w100:   return '100';
      case FontWeightCss.w200:   return '200';
      case FontWeightCss.w300:   return '300';
      case FontWeightCss.w400:   return '400';
      case FontWeightCss.w500:   return '500';
      case FontWeightCss.w600:   return '600';
      case FontWeightCss.w700:   return '700';
      case FontWeightCss.w800:   return '800';
      case FontWeightCss.w900:   return '900';
    }
  }

  String _cssOverflowBase(TextOverflowCss o) {
    switch (o) {
      case TextOverflowCss.visible: return 'visible';
      case TextOverflowCss.clip:    return 'hidden';
      case TextOverflowCss.ellipsis:return 'hidden'; // géré via textOverflow/line-clamp
    }
  }
}