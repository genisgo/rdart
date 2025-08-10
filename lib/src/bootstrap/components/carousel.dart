part of 'bs.components.dart';

enum CarouselMode {
  slide,
  fade;
}

///Carousel use [bcarousel] or [Bcarousel.carousel]
///Example :
///```dart
///BsCarousel(bootstrap: [
///          bwidth.x75,
///          bheight.x50,
///       BAlignSelf.center,
///  ], items: [
///    BsCarouselItem(
///        capitation: Text("Bonjour", color: Colors.White, size: 24),
///        child: RImage(
///          style: RStyle(bootstrap: [
///            bwidth.x100,
///            Bdisplay.block,]),
///          url: "https://image.com",
///        ), active: true)
/// ])
/// ```
class BsCarousel extends Rview {
  static int _idgenerate = 0;
  String? id;
  BsCarouselIndicators? indicators;
  BsCarouselControler? controler;
  CarouselMode mode;
  List<Bootstrap> bootstrap;
  final List<BsCarouselItem> items;
  final bool autoPlay;

  BsCarousel(
      {this.indicators,
      this.items = const [],
      this.id,
      this.autoPlay = false,
      this.controler,
      this.mode = CarouselMode.slide,
      this.bootstrap = const []})
      : super(id: '') {
    _idgenerate++;
    //initialisation
    id ??= "carousel$_idgenerate";
    controler ??= BsCarouselControler();
    indicators ??= BsCarouselIndicators();
  }

  @override
  Relement build() {
    return BsElement(
        userParent: true,
        child: Column(
            children: items,
            singleBootStrap: true,
            bootstrap: [bcarousel.inner]),
        bootstrap: [
          bcarousel,
          bcarousel.slide,
          if (mode == CarouselMode.fade) bcarousel.fade,
          ...bootstrap
        ],
        dataset: {
          if (autoPlay) "bs-ride": "carousel"
        });
  }

  @override
  void initState() {
    ///set indicator parent
    indicators?.parent = this;
    //set parent in controller
    controler?.targetID = id!;
    //add indicator
    indicators?.create();
    getElement.children.add(indicators!.getElement);
    //Add CarouselController
    getElement.children.add(controler!.controler(_CarouselControlerType.prev));
    getElement.children.add(controler!.controler(_CarouselControlerType.next));
    //set carousel id
    getElement.id = id!;
//     var fcarousel = new bootstrap.Carousel(document.querySelector("#carousel1"),{
//   interval: 2000,
//   touch: false
// })
    if (autoPlay) {
      var gcar = bjs.Carousel(getElement);
      gcar.cycle();
    }
    super.initState();
  }
}

class BsCarouselIndicators extends Rview {
  BsCarousel? _parent;

  BsCarouselIndicators({super.id});
  @override
  Relement build() {
    return BsElement(
        child: Column(singleBootStrap: true, children: []),
        bootstrap: [bcarousel.indicators],
        dataset: {});
  }

  ///Call to carousel initState method
  set parent(BsCarousel carousel) {
    _parent = carousel;
  }

  @override
  void initState() {
    if (_parent != null) {
      for (var i = 0; i < _parent!.items.length; i++) {
        getElement.children.add(indicatorItem(_parent!, i));
      }
    }
    super.initState();
  }

  Element indicatorItem(BsCarousel carousel, int index) {
    bool isfirst = index == 0;
    return BsElement(
        child: RButton(
            type: BtnType.button, singleBootStrap: true, style: RStyle()),
        bootstrap: [
          if (isfirst) bcarousel.active
        ],
        dataset: {
          "bs-target": "#${carousel.id}",
          "bs-slide-to": "$index",
          if (isfirst) "aria-current": "true",
        },
        attributes: {
          "aria-label": "Slide $index"
        }).create();
  }
}

class BsCarouselControler {
  BsCarouselControler();
  late String _target;
  set targetID(String id) {
    _target = id;
  }

  Element controler(_CarouselControlerType type) {
    return controlerItem(type: type);
  }

  Element controlerItem({final type = _CarouselControlerType.next}) {
    //
    var spanIcon = Element.span();
    var spanLabel = Element.span();
    //isNext
    bool isNext = type == _CarouselControlerType.next;
    //bootstrap set
    final controBootstrap = [
      isNext ? bcarousel.controlNext : bcarousel.controlPrev
    ];
    final iconBootstrap = [
      isNext ? bcarousel.controlNextIcon : bcarousel.controlPrevIcon
    ];

    //Icon
    spanIcon.className += iconBootstrap.join(" ");
    spanIcon.attributes.addAll({"aria-hidden": "true"});
    //Label
    spanLabel.className += "visually-hidden";
    spanLabel.innerText = isNext ? "Next" : "Prev";

    var controlerElement = BsElement(
        child: RButton(
            type: BtnType.button, singleBootStrap: true, style: RStyle()),
        bootstrap: controBootstrap,
        dataset: {
          "bs-target": "#$_target",
          "bs-slide": isNext ? "next" : "prev",
        });

    controlerElement.create();
    controlerElement.getElement.children.addAll([spanIcon, spanLabel]);
    return controlerElement.getElement;
  }
}

enum _CarouselControlerType { next, prev }

class BsCarouselItem extends Rview {
  Relement? capitation;
  Relement child;
  bool active;
  int? animationTime;
  List<Bootstrap> bootstrap;
  BsCarouselItem(
      {required this.child,
      this.capitation,
      this.active = false,
      this.animationTime,
      this.bootstrap = const [],
      super.id});

  @override
  Relement build() {
    return BsElement(
        id: id,
        child: Column(children: [
          child,
          if (capitation != null)
            BsElement(
              child: capitation!,
              bootstrap: [bcarousel.caption],
            )
        ]),
        bootstrap: [bcarousel.item, ...bootstrap, if (active) bcarousel.active],
        dataset: {if (animationTime != null) "bs-interval": "$animationTime"});
  }
}
