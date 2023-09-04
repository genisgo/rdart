part of 'bs.components.dart';

class BsAlert extends Rview {
  final Relement? _child;
  List<Bootstrap> bootstrap;
  Relement? get child => _child;
  bool dismissible;
  BAlert? type;
  BsAlert(
      {Relement? child,
      this.dismissible = false,
      this.type,
      this.bootstrap = const []})
      : _child = child;
  @override
  Relement build() {
    return BsElement(
        child: Column(
            singleBootStrap: true,
            children: [if (child != null) child!, if (dismissible) closeBtn()]),
        bootstrap: 
        [
          type ?? balert.info,
          BAlert.alert,
          if (dismissible) BAlert.disimissible,
          ...bootstrap
        ],
        dataset: {},
        attributes: {
          "role": "alert"
        });
  }

  Relement closeBtn() {
    return BsElement(
        child: RButton(
            style: RStyle(),
            child: SizeBox(),
            singleBootStrap: true,
            type: BtnType.button),
        bootstrap: [Btn.close],
        dataset: {"bs-dismiss": "alert"},
        attributes: {"aria-labe": "Close"});
  }
}
