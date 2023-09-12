part of 'bs.components.dart';

class BsModalDialog extends Rview {
  static int _idgenerate = 0;

  String? id;
  Relement? header;
  Relement? body;
  Relement? footer;
  bool transition;
  bool static;
  bool scrollable;
  bool center;
  List<Bootstrap> style;
  BsModalDialog(
      {this.header,
      this.id,
      this.body,
      this.footer,
      this.center = true,
      this.scrollable = false,
      this.static = false,
      this.transition = true,
      this.style = const []}) {
    _idgenerate++;
    id ??= "modal$_idgenerate";
  }
  @override
  Relement build() {
    //set Modal bootstrap style
    final modalStyle = [bmodal, if (transition) bcarousel.fade, ...style];
    //set body class

    final modalContentElements = [
      if (header != null) header!,
      if (body != null) BsElement(child: body!, bootstrap: [bmodal.body]),
      if (footer != null) footer!
    ];

    final dialogStyle = [
      bmodal.dialog,
      if (scrollable) bmodal.dialogScrollable,
      if (center) bmodal.dialogCentered
    ];
    return BsElement(
        userParent: true,
        child: BsElement(
            userParent: true,
            child: Column(
                children: modalContentElements,
                singleBootStrap: true,
                bootstrap: [bmodal.content]),
            bootstrap: dialogStyle),
        bootstrap: modalStyle,
        attributes: {
          "tabindex": "-1",
        },
        dataset: {
          if (static) ...{"bs-backdrop": "static", "bs-keyboard": "false"},
        });
  }

  @override
  void onInitialized() {
    getElement.id = id!;
    super.onInitialized();
  }
}

class BsModalControl extends Rview {
  Relement child;
  String targetID;
  String? data;
  BsModalControl({required this.targetID, required this.child, this.data});
  @override
  Relement build() {
    return BsElement(child: child, bootstrap: [], dataset: {
      "bs-toggle": "modal",
      "bs-target": "#$targetID",
      if (data != null) "bs-whatever": "$data"
    });
  }
}

class BsModalHeader extends Relement {
  Relement title;
  Relement? close;
  bool defaultClose;
  //Style
  List<Bootstrap> headerStye;
  List<Bootstrap> titleStye;

  late final Element header = Element.div();
  BsModalHeader(
      {required this.title,
      this.close,
      this.defaultClose = true,
      this.headerStye = const [],
      this.titleStye = const []});
  @override
  Element create() {
    //creat
    title.create();
    //set default close button
    if (defaultClose && close == null) {
      close = BsElement(
        child: RButton(
            singleBootStrap: true, type: BtnType.button, style: RStyle()),
        bootstrap: [],
      );
    }
    close?.create();
    //Set close btn attrib
    close?.getElement.className += [Btn.close].join(" ");
    close?.getElement.dataset.addAll({"bs-dismiss": "modal"});
    close?.getElement.attributes.addAll({"aria-label": "Close"});
    //Set title attrib
    title.getElement.className = [bmodal.title, ...titleStye].join(" ");
    //div
    header.className += [bmodal.header, ...headerStye].join(" ");
    header.children
        .addAll([title.getElement, if (close != null) close!.getElement]);
    return header;
  }

  @override
  // TODO: implement getElement
  Element get getElement => header;
}

class BsModalFooter extends Rview {
  List<Relement> childreen;
  List<Bootstrap> bootstrap;
  BsModalFooter({this.childreen = const [], this.bootstrap = const []});

  @override
  Relement build() {
    return Column(
        singleBootStrap: true,
        children: childreen,
        bootstrap: [bmodal.footer, ...bootstrap]);
  }
}

class BsModalCloseBtn extends Rview {
  Relement? child;
  List<Bootstrap> bootstrap;
  Function(Relement)? onPress;
  BsModalCloseBtn({this.child, this.bootstrap = const [], this.onPress});
  @override
  Relement build() {
    var defualtBtn =
        RButton(type: BtnType.button, singleBootStrap: true, onPress: onPress);

    return BsElement(
        child: child ?? defualtBtn,
        bootstrap: [],
        dataset: {"bs-dismiss": "modal"});
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
