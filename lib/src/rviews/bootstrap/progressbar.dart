import 'package:rdart/bootstrap.dart';
import 'package:rdart/src/rviews/rview_bases.dart';

class BsProgressBar extends Rview {
  int value;
  int max;
  String label;
  BsProgressBar({this.max = 0, this.value = 100, this.label = ""});
  @override
  Relement build() {
    return BsElement(
        userParent: true,
        attributes: {
          "role": "progressbar",
          "aria-label": "",
          "aria-valuemin": "$value",
          "aria-valuemax": "$max"
        },
        dataset: {},
        child: BsElement(
          bootstrap: [bprogress.bar],
          userParent: true,
          attributes: {"style": "width: $value%"},
        ),
        bootstrap: [
          bprogress,
        ]);
  }

  @override
  void onInitialized() {
    getElement.children.first.innerText = label;

    super.onInitialized();
  }
}
