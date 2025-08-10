part of 'rview_bases.dart';

///set extension ajoute extension px et pr sur toute les int? e
extension Dimenssion on num? {
  String? get px => _getStringValue();
  String? get pr => "$this%";
//
  String? _getStringValue() {
    if (this != null) return "${this}px";
    return null;
  }
}

//FontText
enum FontWeight {
  t200("200"),
  t300("300"),
  t400("400"),
  t500("500"),
  t700("600"),
  t800("300"),
  bold("bold");

  const FontWeight(this.value);
  final String value;
}

/// Classe abstraite représentant le style d'un élément.
/// Permet de définir les dimensions, marges, couleurs, etc.
abstract class Style {
  /// Largeur de l'élément (en pixels).
  final double? width;

  /// Hauteur de l'élément (en pixels).
  final double? height;

  /// Si vrai, l'élément prend toute la hauteur disponible.
  final bool expandHeight;

  /// Si vrai, l'élément prend toute la largeur disponible.
  final bool expandWidth;

  /// Hauteur maximale de l'élément (en pixels).
  final double? maxHeight;

  /// Largeur maximale de l'élément (en pixels).
  final double? maxWidth;

  /// Poids de la police du texte.
  final FontWeight? fontWeight;

  /// Marge extérieure de l'élément.
  final EdgInset? margin;

  /// Padding intérieur de l'élément.
  final EdgInset? padding;

  /// Gestion du débordement du contenu (overflow).
  final OverFlow? overFlow;

  /// Taille de l'arrière-plan (background-size).
  final String? backgroundSize;

  /// Couleur du texte.
  final Color? color;

  /// Si vrai, la largeur est exprimée en pourcentage.
  /// Exemple : ratioWidth=true, width=100 => 100%
  final bool ratioWidth;

  /// Si vrai, la hauteur est exprimée en pourcentage.
  /// Exemple : ratioHeight=true, height=100 => 100%
  final bool ratioHeight;

  /// Constructeur de la classe Style.
  const Style(
      {this.height,
      this.color,
      this.width,
      this.maxHeight,
      this.maxWidth,
      this.margin,
      this.padding,
      this.backgroundSize,
      this.ratioHeight = false,
      this.ratioWidth = false,
      this.expandHeight = false,
      this.overFlow,
      this.fontWeight,
      this.expandWidth = false});

  /// Méthode à implémenter pour appliquer le style à un élément.
  Element createStyle(Element e);
}

/// Classe représentant un style enrichi pour les éléments.
/// Permet de gérer l'alignement, la décoration, le texte, le fond, etc.
class RStyle extends Style {
  /// Indique si le mode ratio (%) est activé pour les dimensions.
  final bool modeRatio;

  /// Décoration de l'élément (bordures, ombres, etc.).
  final Decoration? decoration;

  /// Alignement horizontal du contenu.
  final AlignHorizontal? alignHorizontal;

  /// Alignement vertical du contenu.
  final AlignVertical? alignmentVertical;

  /// Alignement du texte.
  final TextAlign? textAlign;

  /// Taille du texte (en pixels).
  final double? textSize;

  /// Liste des classes Bootstrap à appliquer.
  final List<Bootstrap> bootstrap;

  /// Couleur de fond de l'élément.
  final Color? background;

  /// Constructeur de la classe RStyle.
  const RStyle(
      {this.modeRatio = true,
      this.bootstrap = const [],
      super.margin,
      super.padding,
      this.alignHorizontal,
      this.alignmentVertical,
      this.textSize,
      this.background,
      this.textAlign,
      super.overFlow,
      super.height,
      super.fontWeight,
      super.color,
      /// [ratioWidth] permet d'utiliser la largeur en pourcentage.
      super.width,
      super.ratioHeight = false,
      super.ratioWidth = false,
      this.decoration,
      super.expandHeight = false,
      super.expandWidth = false,
      super.maxHeight,
      super.backgroundSize,
      super.maxWidth});

  /// Crée une copie du style en modifiant certaines propriétés.
  RStyle copyWith(
      {bool? modeRatio,
      REdgetInset? margin,
      REdgetInset? padding,
      AlignHorizontal? alignHorizontal,
      AlignVertical? alignmentVertical,
      Color? background,
      TextAlign? textAlign,
      double? height,
      OverFlow? overFlow,
      List<Bootstrap>? bootstrap,
      Color? color,
      double? width,
      bool? ratioHeight,
      bool? ratioWidth,
      Decoration? decoration,
      bool? expandHeight,
      bool? expandWidth,
      double? maxWidth,
      String? backgroundSize,
      FontWeight? fontWeight,
      double? maxHeight}) {
    return RStyle(
        alignmentVertical: alignmentVertical ?? this.alignmentVertical,
        alignHorizontal: alignHorizontal ?? this.alignHorizontal,
        background: background ?? this.background,
        decoration: decoration ?? this.decoration,
        expandHeight: expandHeight ?? this.expandHeight,
        expandWidth: expandWidth ?? this.expandWidth,
        backgroundSize: backgroundSize ?? this.backgroundSize,
        height: height ?? this.height,
        margin: margin ?? this.margin,
        fontWeight: fontWeight ?? this.fontWeight,
        maxHeight: maxHeight ?? this.maxHeight,
        maxWidth: maxWidth ?? this.maxWidth,
        modeRatio: modeRatio ?? this.modeRatio,
        padding: padding ?? this.padding,
        ratioHeight: ratioHeight ?? this.ratioHeight,
        ratioWidth: ratioWidth ?? this.ratioWidth,
        textAlign: textAlign ?? this.textAlign,
        overFlow: overFlow ?? this.overFlow,
        width: width ?? this.width,
        color: color ?? this.color,
        bootstrap: bootstrap ?? this.bootstrap);
  }

  /// Applique le style à un élément HTML.
  @override
  Element createStyle(element) {
    // Applique les marges si définies
    if (margin != null) {
      element
        ..style.marginTop = "${margin?.top}px"
        ..style.marginBottom = "${margin?.bottom}px"
        ..style.marginLeft = "${margin?.left}px"
        ..style.marginRight = "${margin?.right}px";
    }

    // Ajoute les classes Bootstrap si présentes
    if (bootstrap.isNotEmpty) {
      String bootclass = " ${bootstrap.map((e) => e.cname).join(" ")}";
      element.className += bootclass;
    }

    // Applique les dimensions et alignements
    element
      ..style.width = width != null
          ? ratioWidth
              ? "$width%"
              : "${width}px"
          : ""
      ..style.height = height != 0
          ? ratioHeight
              ? "$height%"
              : "${height}px"
          : ""
      ..style.justifyContent = alignHorizontal?.value ?? ""
      ..style.alignItems = alignmentVertical?.value ?? ""
      ..style.background = background?.color ?? "";

    // Applique le padding si défini
    if (padding != null) {
      element.style.padding =
          "${padding?.top}px ${padding?.right}px ${padding?.bottom}px ${padding?.left}px";
    }

    // Si expandHeight ou expandWidth sont activés, prend toute la place disponible
    if (expandHeight) element.style.height = "inherit";
    if (expandWidth) element.style.width = "inherit";

    // Applique les dimensions maximales si définies
    if (maxHeight != null) element.style.maxHeight = "${maxHeight}px";
    if (maxWidth != null) element.style.maxWidth = "${maxWidth}px";

    // Applique la décoration (bordures, ombres, etc.) si définie
    if (decoration != null) {
      element
        ..style.borderRadius = decoration!.border.raduis.toString()
        ..style.boxShadow = decoration!.shadow?.toString() ?? "";
      element.style.borderLeft = decoration?.border.left.toString();
      element.style.borderRight = decoration?.border.right.toString();
      element.style.borderBottom = decoration?.border.bottom.toString();
      element.style.borderTop = decoration?.border.top.toString();
    }

    // Applique le style du texte
    if (textAlign != null) element.style.textAlign = textAlign!.value;
    element.style.fontSize = textSize.px;
    element.style.fontWeight = fontWeight?.value;
    element.style.color = color?.color;

    // Applique l'overflow et la taille de fond
    element.style.overflow = overFlow?.name;
    element.style.backgroundSize = backgroundSize ?? "";
    return element;
  }
}
// Shadow Box

class BoxShadow {
  /// Couleur de l'ombre
  final Color color;

  ///Decalage Horizontal de l'ombre
  final int horizontal;

  ///Decalage verticale
  final int vertical;

  /// La dispersion de lombre
  final int blur;
  static const none = BoxShadow(blur: 0, horizontal: 0, vertical: 0);
  const BoxShadow(
      {this.color = Colors.gray,
      this.horizontal = 1,
      this.vertical = 1,
      this.blur = 1});

  @override
  String toString() {
    return "${color.color} ${horizontal}px ${vertical}px ${blur}px";
  }
}
