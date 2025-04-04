part of 'bs.components.dart';

enum BsPopoverDicrection { top, right, bottom, left }

enum BsPopoversType {
  hover("hover focus"),
  focus("focus");

  const BsPopoversType(this.value);
  final String value;
}

class BsPopoersController {
  String targetID;
  BsPopoersController({required this.targetID});
  bjs.Popover? _controllModal;
  show()
  {
    js.JSString elementOrSelector = '#$targetID'.toJS;
    js.JSObject config  = {}.toJSBox;
    _controllModal ??= bjs.Popover(elementOrSelector, config);
    _controllModal?.show();
  }

  hide()
  {
    js.JSString elementOrSelector = '#$targetID'.toJS;
    js.JSObject config  = {}.toJSBox;
    _controllModal ??= bjs.Popover(elementOrSelector, config); 
       _controllModal?.hide();
  }
}

class BsPopovers extends Rview {
  Relement child;
  String? title;
  String content;
  BsPopoverDicrection dicrection;
  BsPopoversType type;
  bool onhover;
  BsPopovers(
      {required this.child,
      this.title,
      required this.content,
      this.onhover = true,
      this.type = BsPopoversType.focus,
      this.dicrection = BsPopoverDicrection.top, super.id});
  @override
  Relement build() {
    return BsElement(id: id, child: child, bootstrap: [], dataset: {
      "bs-title": "$title",
      "bs-content": content,
      "bs-placement": dicrection.name,
      "bs-toggle": "popover",
      if (onhover) "bs-trigger": type.value
    });
  }

  @override
  void initState() {
    js.JSObject config  = {}.toJSBox;
    bjs.Popover(getElement.toJSBox, config);
    super.initState();
  }
}
