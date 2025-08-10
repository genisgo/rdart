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
  BsModalController? _controller;
  List<Bootstrap> style;
  List<Bootstrap> dialogStyle;
  BsModalDialog(
      {this.header,
      this.dialogStyle = const [],
      this.id,
      this.body,
      BsModalController? controller,
      this.footer,
      this.center = true,
      this.scrollable = false,
      this.static = false,
      this.transition = true,
      this.style = const []})
      : _controller = controller,
        super(id: id) {
    _idgenerate++;
    id ??= "modal$_idgenerate${Object.hashAll([this])}";
    _controller?.targetID = id!;
  }
  @override
  Relement build() {
    //set Modal bootstrap style
    var modalStyle = [bmodal, if (transition) bmodal.fade, ...style];
    //set body class

    var fulldialogStyle = [
      bmodal.dialog,
      if (scrollable) bmodal.dialogScrollable,
      if (center) bmodal.dialogCentered,
      ...dialogStyle,
    ];

    ///Attribute if modal is [static] are true
    var staticAttribut = {"bs-backdrop": "static", "bs-keyboard": "false"};

    return BsElement(
        id: id,
        userParent: true,
        child: BsElement(
            userParent: true,
            child: Column(
                children: [
                  if (header != null) header!,
                  if (body != null)
                    BsElement(child: body!, bootstrap: [bmodal.body]),
                  if (footer != null) footer!
                ],
                singleBootStrap: true,
                bootstrap: [bmodal.content]),
            bootstrap: fulldialogStyle),
        bootstrap: modalStyle,
        attributes: {
          "tabindex": "-1",
        },
        dataset: {
          if (static) ...staticAttribut
        });
  }

  @override
  void initState() {
    getElement.id = id!;
    super.initState();
  }
}

class BsModalControl extends Rview {
  Relement child;
  String targetID;
  String? data;
  BsModalControl(
      {required this.targetID, required this.child, this.data, super.id});
  @override
  Relement build() {
    return BsElement(child: child, bootstrap: [], dataset: {
      "bs-toggle": "modal",
      "bs-target": "#$targetID",
      if (data != null) "bs-whatever": "$data"
    });
  }
}

class BsModalController {
  String? targetID;
  BsModalController({this.targetID});
  bjs.Modal? _controllModal;
  show() {
    
   String dartString = '#$targetID';
   print(dartString);
   js.JSAny jsString = dartString.jsify()!; 
   js.JSObject config = {}.toJSBox;
   
    _controllModal ??= bjs.Modal(jsString,config);
    _controllModal?.show();
  }

  hide() {
        String dartString = '#$targetID';

  // Convertir la chaîne Dart en JSString
  JSString jsString = dartString.toJS;
    try {
      _controllModal ??= bjs.Modal(jsString);
      _controllModal?.hide();
    } catch (e) {
      log("Modal.hide is call in no showing Modal",
          error: e, stackTrace: StackTrace.current);
    }
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
      super.id,
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
    close?.getElement.className += " ${[Btn.close].join(" ")}";
    close?.getElement.dataset.addAll({"bs-dismiss": "modal"});
    close?.getElement.attributes.addAll({"aria-label": "Close"});
    //Set title attrib
    title.getElement.className += " ${[bmodal.title, ...titleStye].join(" ")}";
    //div
    header.className += [bmodal.header, ...headerStye].join(" ");
    header.children
        .addAll([title.getElement, if (close != null) close!.getElement]);
    //SET ID
    if (id != null) header.id = id!;
    return header;
  }

  @override
  // TODO: implement getElement
  Element get getElement => header;
}

class BsModalFooter extends Rview {
  List<Relement> childreen;
  List<Bootstrap> bootstrap;
  BsModalFooter(
      {this.childreen = const [], this.bootstrap = const [], super.id});

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
  BsModalCloseBtn(
      {this.child, this.bootstrap = const [], this.onPress, super.id});
  @override
  Relement build() {
    var defualtBtn = RButton(
        type: BtnType.button,
        singleBootStrap: true,
        onPress: onPress,
        style: RStyle());

    return BsElement(
        child: child ?? defualtBtn,
        bootstrap: [],
        dataset: {"bs-dismiss": "modal"});
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
