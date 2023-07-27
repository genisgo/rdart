part of '../rview_bases.dart';

class ListTitle extends Rview {
  final Relement? title;
  final Relement? leading;
  final Color separtorColor;
  final Color backgroundColor;
  final Function(Relement itme)? onPress;
  final Color selectedColor;
  final heigth;
  final padding;
  final Relement? content;
  ListTitle(
      {this.title,
      this.leading,
      this.content,
      this.onPress,
      this.padding = Theme.padding,
      this.selectedColor = const Colors.formRGB(0, 0, 0, 0.15),
      this.separtorColor = const Color("#e8e8e8"),
      this.backgroundColor = Colors.transparent,
      this.heigth = 35}) {
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
              padding: REdgetInset.all(padding),
              height: heigth,
              width: 100,
              ratioWidth: true,
              alignmentVertical: AlignVertical.center,
              backgroundColor: backgroundColor,
              decoration: Decoration(
                border: Rborder.all(raduis: Raduis.all(4), side: BorderSide()),
              )),
          child: Column(children: [
            Row(children: [leading ?? SizeBox(), title ?? SizeBox()]),
            Row(children: [content ?? SizeBox()]),
          ])),
      Divider(color: separtorColor, height: 0.8)
    ]);
  }
}
