part of 'bs.components.dart';

enum BsTooltipDicrection { top, right, bottom, left }

class BsTooltip extends Rview {
  Relement child;
  String title;
  BsPopoverDicrection dicrection;
  BsPopoversType type;
  BsTooltip(
      {required this.child,
      required this.title,
      this.type = BsPopoversType.focus,
      this.dicrection = BsPopoverDicrection.top,
      super.id});
  @override
  Relement build() {
    return BsElement(id: id, child: child, bootstrap: [], dataset: {
      "bs-title": title,
      "bs-placement": dicrection.name,
      "bs-toggle": "tooltip",
    });
  }

  @override
  void initState() {
    bjs.Tooltip(getElement, {});
    super.initState();
  }
}
