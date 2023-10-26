part of 'bs.components.dart';

class BsCollapseBtn extends Rview {
  final List<String> ariaControls;

  final Relement child;

  BsCollapseBtn({
    required String id,
    required this.ariaControls,
    required this.child,
  }) : super(id: id);
  @override
  Relement build() {
    return BsElement(
        id: id,
        bootstrap: [],
        dataset: {
          "bs-toggle": "${Bcollapse.collapse}",
          "bs-target": _setTarget()
        },
        attributes: {
          "role": "button",
          "aria-expanded": "false",
          "aria-controls": ariaControls.join(" "),
        },
        child: child);
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
      {required String id,
      required this.content,
      this.useMulticollapse = false})
      : super(id: id);
  @override
  Relement build() {
    return BsElement(id: id, userParent: true, child: content, bootstrap: [
      Bcollapse.collapse,
      if (useMulticollapse) Bcollapse.multicollapse,
    ], dataset: {});
  }

}
