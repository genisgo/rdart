import 'package:rdart/rviews.dart';

class ListTitle extends Rview {
  final Relement? title;
  final Relement? leading;
  final Relement? content;
  ListTitle({this.title, this.leading, this.content});
  @override
  Relement build() {
    return Container(
        child: Column(children: [
      Row(children: [leading ?? SizeBox(), title ?? SizeBox()]),
      Row(children: [content ?? SizeBox()])
    ]));
  }
}
