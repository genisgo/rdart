part of 'bs.components.dart';

class BsToast extends Rview {
  Relement? header;
  Relement body;
  String? id;
  List<Bootstrap> style;
  List<Bootstrap> headerStyle;
  bool showHeader;
  BsToast(
      {this.header,
      required this.body,
      this.id,
      this.style = const [],
      this.showHeader = true,
      this.headerStyle = const []})
      : super(key: id);
  @override
  Relement build() {
    return BsElement(
        attributes: {
          "role": "alert",
          "aria-live": "assertive",
          "aria-atomic": "true",
          if (id != null) "id": "$id"
        },
        bootstrap: [
          btoast,
          ...style
        ],
        child: Column(singleBootStrap: true, children: [
          if (showHeader && header!=null)
            BsElement(
                bootstrap: [btoast.header, ...headerStyle], child: header),
          BsElement(bootstrap: [btoast.body], child: body)
        ]));
  }
}

class BsToastController {
  String targetID;
  BsToastController({required this.targetID});
  bjs.Toast? _controllModal;
  show() {
    _controllModal ??= bjs.Toast('#$targetID', {});
    _controllModal?.show();
  }

  hide() {
    _controllModal ??= bjs.Toast('#$targetID', {});
    _controllModal?.hide();
  }

  getInstance() {
    var element = querySelector('#$targetID');
    bjs.Toast toast = bjs.Toast.getOrCreateInstance(element);
    print(toast.show());
  }
}

class BsToastClose extends Rview {
  Relement? child;
  List<Bootstrap> bootstrap;
  Function(Relement)? onPress;
  BsToastClose({this.child, this.bootstrap = const [], this.onPress});
  @override
  Relement build() {
    var defualtBtn = RButton(
        type: BtnType.button,
        singleBootStrap: true,
        onPress: onPress,
        style: RStyle());

    return BsElement(
        child: child ?? defualtBtn,
        bootstrap: [...bootstrap, Btn.close],
        dataset: {"bs-dismiss": "toast"});
  }

  @override
  void onInitialized() {
    ///Add onclick
    if (child == null) {
      getElement.onClick.listen((event) {
        onPress?.call(this);
      });
    }
    super.onInitialized();
  }
}
