part of '../rview_bases.dart';

class ListTitle extends Rview {
  final Relement? title;
  final Relement? leading;
  final bool divider;
  final Rborder border;
  final Color separtorColor;
  final Color backgroundColor;
  final Function(Relement itme)? onPress;
  final Color selectedColor;
  final EdgInset margin;
  final double? heigth;
  final EdgInset padding;
  final Relement? content;
  ListTitle(
      {this.title,
      this.leading,
      this.content,
      this.margin = REdgetInset.zero,
      this.border =
          const Rborder.all(raduis: Raduis.all(4), side: BorderSide()),
      this.onPress,
      this.divider = true,
      this.padding = REdgetInset.zero,
      this.selectedColor = const Colors.formRGB(66, 135, 245, 0.50),
      this.separtorColor = const Color("#e8e8e8"),
      this.backgroundColor = Colors.transparent,
      this.heigth}) {
    RStyle(
      textSize: 14,
    ).createStyle(title!.create());
  }
  @override
  Relement build() {
    return Column(children: [
      RButton(
          onMouseEnterColor: selectedColor,
          onPress: onPress,
          style: RStyle(
              margin: margin,
              padding:padding,
              textAlign: TextAlign.start,
              height: heigth ?? 0,
              width: 100,
              ratioWidth: true,
              alignmentVertical: AlignVertical.center,
              backgroundColor: backgroundColor,
              decoration: Decoration(
                border: border,
              )),
          child: Column(children: [
            Row(children: [leading ?? SizeBox(), title ?? SizeBox()]),
            Row(children: [content ?? SizeBox()]),
            
          ])),
      if (divider) Divider(color: separtorColor, height: 0.8)
    ]);
  }
}
