part of 'bs.components.dart';

class BsToast extends Rview {
  Relement? header;
  Relement body;
  bool autohide ;
  String? id;
  int? animatDuration;
  List<Bootstrap> style;
  List<Bootstrap> headerStyle;
  bool showHeader;
  BsToast(
      {this.header,
      this.autohide =true,
      this.animatDuration,
      required this.body,
      this.id,
      this.style = const [],
      this.showHeader = true,
      this.headerStyle = const []})
      : super(id: id);
  @override
  Relement build() {
    return BsElement(
        attributes: {
          "role": "alert",
          "aria-live": "polite",
          "aria-atomic": "true",
          if (id != null) "id": "$id"
        },
        dataset: {
          if (animatDuration != null) "bs-delay": "$animatDuration",
          "bs-autohide": '$autohide'
        },
        bootstrap: [
          btoast,
          ...style
        ],
        child: Column(singleBootStrap: true, children: [
          if (showHeader && header != null)
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

  bjs.Toast getInstance() {
    var element = querySelector('#$targetID');
    bjs.Toast toast = bjs.Toast.getOrCreateInstance(element);
    return toast;
  }
}

class BsToastClose extends Rview {
  Relement? child;
  List<Bootstrap> bootstrap;
  Function(Relement)? onPress;
  BsToastClose({this.child, this.bootstrap = const [], this.onPress, super.id});
  @override
  Relement build() {
    var defualtBtn = RButton(
        type: BtnType.button,
        singleBootStrap: true,
        onPress: onPress,
        style: RStyle());

    return BsElement(id: id,
        child: child ?? defualtBtn,
        bootstrap: [...bootstrap, Btn.close],
        dataset: {"bs-dismiss": "toast"});
  }

  @override
  void initState() {
    ///Add onclick
    if (child == null) {
      getElement.onClick.listen((event) {
        onPress?.call(this);
      });
    }
    super.initState();
  }
}
