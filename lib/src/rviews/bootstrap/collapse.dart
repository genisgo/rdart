part of 'bs.components.dart';

class BsCollapseBtn extends Rview {
  final List<String> ariaControls;

  final Relement child;

  BsCollapseBtn({
    required String key,
    required this.ariaControls,
    required this.child,
  }) : super(key: key);
  @override
  Relement build() {
    return BsElement(bootstrap: [], dataset: {
      "bs-toggle": "${Bcollapse.collapse}",
      "bs-target": _setTarget()
    }, attributes: {
      "role": "button",
      "aria-expanded": "false",
      "aria-controls": ariaControls.join(" "),
    }, child: child);
  }

  String _setTarget() {
    if (ariaControls.length <= 1) {
      return "#${ariaControls.first}";
    } else {
      return ".${Bcollapse.multicollapse}";
    }
  }
}

class BsCollapseBody extends Rview {
  Relement content;
  bool useMulticollapse;
  BsCollapseBody(
      {required String key,
      required this.content,
      this.useMulticollapse = false})
      : super(key: key);
  @override
  Relement build() {
    return BsElement(userParent: true, child: content, bootstrap: [
      Bcollapse.collapse,
      if (useMulticollapse) Bcollapse.multicollapse,
    ], dataset: {});
  }

  @override
  void onInitialized() {
    super.onInitialized();
    getElement.id = key;
  }
}
