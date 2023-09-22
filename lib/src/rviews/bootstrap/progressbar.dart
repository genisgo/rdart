part  of'bs.components.dart';
class BsProgressBar extends Rview {
  int value;
  int max;
  String label;
  List<Bootstrap> bootstraps;
  BsProgressBar({this.max = 100, this.value = 50, this.label = "",this.bootstraps=const []});
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
        dataset: {
          
        },
        child: BsElement(
          bootstrap: [bprogress.bar,...bootstraps],
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
