import 'dart:html';

import 'package:rdart/bootstrap.dart';
import 'package:rdart/rviews.dart';

enum CarouselMode {
  slide,
  fade;
}

class BsCarousel extends Rview {
  static int _idgenerate = 0;
  String? id;
  BsCarouselIndicators? indicators;
  BsCarouselControler? controler;
  CarouselMode mode;
  final List<BsCarouselItem> items;
  final bool autoPlay;

  BsCarousel(
      {this.indicators,
      this.items = const [],
      this.id,
      this.autoPlay = false,
      this.controler,
      this.mode = CarouselMode.slide}) {
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
            children: [
              indicators!,
              ...items,
            ],
            singleBootStrap: true,
            bootstrap: [bcarousel.inner]),
        bootstrap: [bcarousel, if (mode == CarouselMode.fade) bcarousel.fade],
        dataset: {if (autoPlay) "bs-ride": "carousel"});
  }

  @override
  void onInitialized() {
    ///set indicator parent
    indicators?.parent = this;
    //set parent in controller
    controler?.targetID = id!;
    //Add CarouselController
    getElement.children.add(controler!.controler);
    super.onInitialized();
  }
}

class BsCarouselIndicators extends Rview {
  @override
  Relement build() {
    return BsElement(
        child: Column(singleBootStrap: true, children: []),
        bootstrap: [bcarousel.indicators],
        dataset: {});
  }

  ///Call to carousel onInitialized method
  set parent(BsCarousel carousel) {
    for (var i = 0; i < carousel.items.length; i++) {
      getElement.children.add(indicatorItem(carousel, i));
    }
  }

  Element indicatorItem(BsCarousel carousel, int index) {
    bool isfirst = index == 0;
    return BsElement(child: RButton(type: BtnType.button), bootstrap: [
      if (isfirst) bcarousel.active
    ], dataset: {
      "bs-target": "#${carousel.id}",
      "bs-slide-to": "$index",
      if (isfirst) "aria-current": "true",
    }, attributes: {
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

  Element get controler {
    var btn = RButton(child: Column(children: [])).create();
    btn.children.addAll([
      controlerItem(type: _CarouselControlerType.prev),
      controlerItem(type: _CarouselControlerType.next)
    ]);
    return btn;
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
        child: RButton(type: BtnType.button),
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
  BsCarouselItem(
      {required this.child,
      this.capitation,
      this.active = false,
      this.animationTime});

  @override
  Relement build() {
    return BsElement(
        child: Column(children: [child, if (capitation != null) capitation!]),
        bootstrap: [bcarousel.item, if (active) bcarousel.active],
        dataset: {if (animationTime != null) "bs-interval": "$animationTime"});
  }
}
