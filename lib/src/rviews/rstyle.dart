part of 'rview_bases.dart';

///set extension ajoute extension px et pr sur toute les int? e
extension Dimenssion on int? {
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

abstract class Style {
  final double? width;
  final double? height;
  final bool expandHeight;
  final bool expandWidth;
  final double? maxHeight;
  final double? maxWidth;
  final FontWeight? fontWeight;
  final EdgInset? margin;
  final EdgInset? padding;
  final OverFlow? overFlow;
  final String? backgroundSize;

  ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
  final bool ratioWidth;

  ///[ratioWidth] make in % *exemple* ratioHeight:true, height:100 (100%)
  final bool ratioHeight;
  const Style(
      {this.height,
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
  Element createStyle(Element e);
}



class RStyle extends Style {
  final bool modeRatio;

  final Decoration? decoration;
  final AlignHorizontal? alignHorizontal;
  final AlignVertical? alignmentVertical;
  final TextAlign? textAlign;
  final int? textSize;
  final List<Bootstrap> bootstrap;
  final Color? background;
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

      ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
      super.width,
      super.ratioHeight = false,
      super.ratioWidth = false,
      this.decoration,
      super.expandHeight = false,
      super.expandWidth = false,
      super.maxHeight,
      super.backgroundSize,
      super.maxWidth});
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

      ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
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
        bootstrap: bootstrap ?? this.bootstrap);
  }

  @override
  Element createStyle(element) {
    if (margin != null) {
      element
        ..style.marginTop = "${margin?.top}px"
        ..style.marginBottom = "${margin?.bottom}px"
        ..style.marginLeft = "${margin?.left}px"
        ..style.marginRight = "${margin?.right}px";
    }

    ///BootStrap active
    if (bootstrap.isNotEmpty) {
      String bootclass = " ${bootstrap.map((e) => e.cname).join(" ")}";
      print(bootclass);

      element.className += bootclass;
    }

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
    if (padding != null) {
      element.style.padding =
          "${padding?.top}px ${padding?.right}px ${padding?.bottom}px ${padding?.left}px";
    }
    if (expandHeight) element.style.height = "inherit";
    if (expandWidth) element.style.width = "inherit";

    if (maxHeight != null) element.style.maxHeight = "${maxHeight}px";

    if (maxWidth != null) element.style.maxWidth = "${maxWidth}px";

    if (decoration != null) {
      ///Set Border in shadow
      element
        ..style.borderRadius = decoration!.border.raduis.toString()
        ..style.boxShadow = decoration!.shadow?.toString() ?? "";

      ///Border
      element.style.borderLeft = decoration?.border.left.toString();
      element.style.borderRight = decoration?.border.right.toString();
      element.style.borderBottom = decoration?.border.bottom.toString();
      element.style.borderTop = decoration?.border.top.toString();
      // if (decoration!.border.left != null) {
      //   element.style.borderLeft = decoration?.border.left.toString();
      // }
      // if (decoration!.border.right != null) {

      // }
      //BoxShadow
    }

    ///TextStyle
    ///Alignement de text
    if (textAlign != null) element.style.textAlign = textAlign!.value;
    element.style.fontSize = textSize.px;
    element.style.fontWeight = fontWeight?.value;

    ///Set overflow or active scroll bar .
    element.style.overflow = overFlow?.name;
    //backgroun size
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
