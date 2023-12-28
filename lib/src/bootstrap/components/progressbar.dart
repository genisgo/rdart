part  of'bs.components.dart';
class BsProgressBar extends Rview {
  int value;
  int max;
  String label;
  List<Bootstrap> bootstraps;
  BsProgressBar({this.max = 100, this.value = 50, this.label = "",this.bootstraps=const [], super.id});
  @override
  Relement build() {
    return BsElement(id: id,
        userParent: false,
        attributes: {
          "role": "progressbar",
          "aria-label": "",
          "aria-valuemin": "$value",
          "aria-valuemax": "$max"
        },
        dataset: {
          
        },
        child: BsElement(child: Text(label,singleBootStrap: true),
          bootstrap: [bprogress.bar,...bootstraps],
          userParent: true,
          attributes: {"style": "width: $value%"},
        ),
        bootstrap: [
          bprogress,
        ]);
  }

  @override
  void initState() {
  //  getElement.children.first.innerText = label;

    super.initState();
  }
}
