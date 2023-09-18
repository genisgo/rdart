part of 'bs.components.dart';

enum BsPosition { start, top, bottom, end }

class BsOffcanvas extends Rview {
  static int _idgenerate = 0;

  String? id;
  Relement? header;
  Relement? body;
  bool transition;
  bool static;
  bool center;
  BsPosition position;
  List<Bootstrap> style;
  List<Bootstrap> dialogStyle;

  bool scrollable;

  BsOffcanvas(
      {this.header,
      this.dialogStyle = const [],
      this.id,
      this.body,
      this.scrollable = true,
      this.position = BsPosition.start,
      this.center = true,
      this.static = false,
      this.transition = true,
      this.style = const []}) {
    _idgenerate++;
    id ??= "modal$_idgenerate";
  }
  @override
  Relement build() {
    //set Modal bootstrap style
    final canvasStyle = [
      boffcanvas,
      if (transition) boffcanvas.fade,
      getposition,
      ...style
    ];
    //set body class

    final modalContentElements = [
      if (header != null) header!,
      if (body != null) BsElement(child: body!, bootstrap: [boffcanvas.body]),
    ];

    ///Attribute if modal is [static] are true
    const staticAttribut = {"bs-backdrop": "static", "bs-keyboard": "false"};

    return BsElement(
        child: Column(
          children: modalContentElements,
          singleBootStrap: true,
        ),
        bootstrap: canvasStyle,
        attributes: {
          "tabindex": "-1",
        },
        dataset: {
          if (static) ...staticAttribut,
          if (scrollable) "data-bs-scroll": "$scrollable"
        });
  }

  @override
  void onInitialized() {
    getElement.id = id!;
    super.onInitialized();
  }

  Bootstrap get getposition => switch (position) {
        BsPosition.top => bcanvasPossition.top,
        BsPosition.end => bcanvasPossition.end,
        BsPosition.bottom => bcanvasPossition.bottom,
        _ => bcanvasPossition.start
      };
}

class BsOffcanvasControl extends Rview {
  Relement child;
  String targetID;
  String? data;
  BsOffcanvasControl({required this.targetID, required this.child, this.data});
  @override
  Relement build() {
    return BsElement(child: child, bootstrap: [], dataset: {
      "bs-toggle": "offcanvas",
      "bs-target": "#$targetID",
      if (data != null) "bs-whatever": "$data"
    });
  }
}

class BsOffcanvasController {
  String targetID;
  BsOffcanvasController({required this.targetID});
  bjs.Offcanvas? _controllModal;
  show() {
    _controllModal ??= bjs.Offcanvas('#$targetID');
    _controllModal?.show();
  }

  hide() {
    _controllModal ??= bjs.Offcanvas('#$targetID');
    _controllModal?.hide();
  }
}

class BsOffcanvasHeader extends Relement {
  Relement title;
  Relement? close;
  bool defaultClose;
  //Style
  List<Bootstrap> headerStye;
  List<Bootstrap> titleStye;

  late final Element header = Element.div();
  BsOffcanvasHeader(
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
    close?.getElement.className += " ${[Btn.close].join(" ")}";
    close?.getElement.dataset.addAll({"bs-dismiss": "offcanvas"});
    close?.getElement.attributes.addAll({"aria-label": "Close"});
    //Set title attrib
    title.getElement.className +=
        " ${[boffcanvas.title, ...titleStye].join(" ")}";
    //div
    header.className += [boffcanvas.header, ...headerStye].join(" ");
    header.children
        .addAll([title.getElement, if (close != null) close!.getElement]);
    return header;
  }

  @override
  // TODO: implement getElement
  Element get getElement => header;
}

class BsoffcanvasCloseBtn extends Rview {
  Relement? child;
  List<Bootstrap> bootstrap;
  Function(Relement)? onPress;
  BsoffcanvasCloseBtn({this.child, this.bootstrap = const [], this.onPress});
  @override
  Relement build() {
    var defualtBtn =
        RButton(type: BtnType.button, singleBootStrap: true, onPress: onPress);

    return BsElement(
        child: child ?? defualtBtn,
        bootstrap: [],
        dataset: {"bs-dismiss": "offcanvas"});
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
