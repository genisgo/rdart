part of 'rview_bases.dart';

extension Dimenssion on int {
  get px => "${this}px";
  get pr => "$this%";
}

abstract class Style {
  final double width;
  final double height;
  final bool expandHeight;
  final bool expandWidth;
  final double? maxHeight;
  final double? maxWidth;
  final EdgInset margin;
  final EdgInset padding;

  ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
  final bool ratioWidth;

  ///[ratioWidth] make in % *exemple* ratioHeight:true, height:100 (100%)
  final bool ratioHeight;
  const Style(
      {this.height = 1,
      this.width = 1,
      this.maxHeight,
      this.maxWidth,
      this.margin = REdgetInset.zero,
      this.padding = REdgetInset.zero,
      this.ratioHeight = false,
      this.ratioWidth = false,
      this.expandHeight = false,
      this.expandWidth = false});
  Element createStyle(Element e);
}

class RStyle extends Style {
  final bool modeRatio;
  final Decoration? decoration;
  final AlignHorizontal alignHorizontal;
  final AlignVertical alignmentVertical;
  final TextAlign? textAlign;
  final int textSize;
  final Color? backgroundColor;
  const RStyle(
      {this.modeRatio = true,
      super.margin = REdgetInset.zero,
      super.padding = REdgetInset.zero,
      this.alignHorizontal = AlignHorizontal.none,
      this.alignmentVertical = AlignVertical.none,
      this.textSize = 14,
      this.backgroundColor,
      this.textAlign,
      super.height = 0,

      ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
      super.width = 0,
      super.ratioHeight = false,
      super.ratioWidth = false,
      this.decoration,
      super.expandHeight = false,
      super.expandWidth = false,
      super.maxHeight,
      super.maxWidth});
  RStyle copyWith(
      {bool? modeRatio,
      REdgetInset? margin,
      REdgetInset? padding,
      AlignHorizontal? alignHorizontal,
      AlignVertical? alignmentVertical,
      Color? backgroundColor,
      TextAlign? textAlign,
      double? height,

      ///[ratioWidth] make in % width *exemple* ratioWidth:true, width:100 (100%)
      double? width,
      bool? ratioHeight,
      bool? ratioWidth,
      Decoration? decoration,
      bool? expandHeight,
      bool? expandWidth,
      double? maxWidth,
      double? maxHeight}) {
    return RStyle(
        alignmentVertical: alignmentVertical ?? this.alignmentVertical,
        alignHorizontal: alignHorizontal ?? this.alignHorizontal,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        decoration: decoration ?? this.decoration,
        expandHeight: expandHeight ?? this.expandHeight,
        expandWidth: expandWidth ?? this.expandWidth,
        height: height ?? this.height,
        margin: margin ?? this.margin,
        maxHeight: maxHeight ?? this.maxHeight,
        maxWidth: maxWidth ?? this.maxWidth,
        modeRatio: modeRatio ?? this.modeRatio,
        padding: padding ?? this.padding,
        ratioHeight: ratioHeight ?? this.ratioHeight,
        ratioWidth: ratioWidth ?? this.ratioWidth,
        textAlign: textAlign ?? this.textAlign,
        width: width ?? this.width);
  }

  @override
  Element createStyle(element) {
    if (margin != REdgetInset.zero) {
      element
        ..style.marginTop = "${margin.top}px"
        ..style.marginBottom = "${margin.bottom}px"
        ..style.marginLeft = "${margin.left}px"
        ..style.marginRight = "${margin.right}px";
    }

    element
      ..style.width = width != 0
          ? ratioWidth
              ? "$width%"
              : "${width}px"
          : ""
      ..style.height = height != 0
          ? ratioHeight
              ? "$height%"
              : "${height}px"
          : ""
      ..style.justifyContent = alignHorizontal.value
      ..style.alignItems = alignmentVertical.value
      ..style.backgroundColor = backgroundColor?.color ?? ""
      ..style.padding =
          "${padding.top}px ${padding.right}px ${padding.bottom}px ${padding.left}px";

    if (expandHeight) element.style.height = "inherit";
    if (expandWidth) element.style.width = "inherit";

    if (maxHeight != null) element.style.maxHeight = "${maxHeight}px";
    
    if (maxWidth != null) element.style.maxWidth = "${maxWidth}px";

    if (decoration != null) {
      ///backgroundColor for decoration
      if (decoration!.backgroundColor != null) {
        element.style.backgroundColor = decoration!.backgroundColor!.color;
      }

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
    element.style.fontSize = "${textSize}px";
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
  static const none = BoxShadow();
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
