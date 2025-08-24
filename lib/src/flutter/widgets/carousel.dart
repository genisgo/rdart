part of 'widgets.dart';

// PageView — composant carrousel style Flutter pour Rdart
// ----------------------------------------------------------------------------
// ✓ Nom proche de Flutter : PageView + PageController
// ✓ Défilement horizontal/vertical, swipe (mouse/touch), snapping
// ✓ viewportFraction (cartes partielles visibles)
// ✓ autoplay + loop + pause on hover
// ✓ onPageChanged, controller.jump/animate/next/previous
// ✓ indicateurs (dots) intégrés et cliquables
// ✓ builder ou children statiques
// Base: Rview (haut-niveau), mais utilise DOM pour les gestures & transforms
// -----------------------------------------------------------------------------
// API publique
// -----------------------------------------------------------------------------
// enum Axis { horizontal, vertical }

typedef PageBuilder = Relement Function(int index);

defaultCurve(num t) => t * t * (3 - 2 * t); // easeInOut simple (smoothstep)

class PageController {
  int _page = 0;
  _PageViewState? _state;

  int get page => _page;
  int get itemCount => _state?._itemCount ?? 0;

  void _attach(_PageViewState s) {
    _state = s;
    _page = s.currentIndex;
  }

  void _detach() {
    _state = null;
  }

  void jumpToPage(int index) {
    _page = index;
    _state?._goTo(index, animate: false);
  }

  void animateToPage(int index, {int durationMs = 280}) {
    _page = index;
    _state?._goTo(index, animate: true, durationMs: durationMs);
  }

  void nextPage({int durationMs = 240}) {
    animateToPage((_page + 1) % math.max(1, itemCount), durationMs: durationMs);
  }

  void previousPage({int durationMs = 240}) {
    animateToPage(
      (_page - 1 + itemCount) % math.max(1, itemCount),
      durationMs: durationMs,
    );
  }
}

class IndicatorStyle {
  final double dotSize; // px
  final double spacing; // px
  final String color; // CSS
  final String activeColor; // CSS
  final double activeScale; // eg. 1.4
  final bool clickable;
  const IndicatorStyle({
    this.dotSize = 8,
    this.spacing = 8,
    this.color = '#94a3b8',
    this.activeColor = '#ffffff',
    this.activeScale = 1.25,
    this.clickable = true,
  });
}

class PageView extends Relement {
  final List<Relement>? children;
  final PageBuilder? itemBuilder;
  final int? itemCount;
  final Axis scrollDirection;
  final double viewportFraction; // 0.7..1.0 typique; 1.0 plein écran
  final bool pageSnapping;
  final bool loop; // wrap à 0 après dernier
  final bool autoplay;
  final int autoplayIntervalMs;
  final bool pauseAutoplayOnHover;
  final bool showIndicator;
  final IndicatorStyle indicatorStyle;
  final PageController? controller;
  final void Function(int index)? onPageChanged;

  PageView({
    this.children,
    this.scrollDirection = Axis.horizontal,
    double viewportFraction = 1.0,
    this.pageSnapping = true,
    this.loop = false,
    this.autoplay = false,
    this.autoplayIntervalMs = 3000,
    this.pauseAutoplayOnHover = true,
    this.showIndicator = true,
    this.indicatorStyle = const IndicatorStyle(),
    this.controller,
    this.onPageChanged,
    super.id,
  }) : itemBuilder = null,
       itemCount = children?.length,
       viewportFraction = viewportFraction.clamp(0.2, 1.0);

  PageView.builder({
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.horizontal,
    double viewportFraction = 1.0,
    this.pageSnapping = true,
    this.loop = false,
    this.autoplay = false,
    this.autoplayIntervalMs = 3000,
    this.pauseAutoplayOnHover = true,
    this.showIndicator = true,
    this.indicatorStyle = const IndicatorStyle(),
    this.controller,
    this.onPageChanged,
    super.id,
  }) : children = null,
       viewportFraction = viewportFraction.clamp(0.2, 1.0);

  late final _PageViewState _state;

  // @override
  // Element build() {

  // }

  @override
  Element create() {
    _state = _PageViewState(this);
    controller?._attach(_state);
    return _state.create();
  }

  @override
  Element get getElement => _state.root;
}

// -----------------------------------------------------------------------------
// Implémentation interne
// -----------------------------------------------------------------------------
class _PageViewState {
  final PageView w;
  _PageViewState(this.w);

  late final DivElement root;
  late final DivElement viewport; // masque
  late final DivElement track; // flex container
  late final DivElement indicatorWrap;

  int currentIndex = 0;
  int _itemCount = 0;
  Timer? _autoTimer;
  bool _drag = false;
  double _dragStartX = 0, _dragStartY = 0, _dragOffset = 0;
  double _viewW = 0, _viewH = 0;

  Element create() {
    _itemCount = w.itemCount ?? w.children?.length ?? 0;
    root = DivElement();
    viewport = DivElement();
    track = DivElement();
    indicatorWrap = DivElement();

    // styles
    root.style
      ..position = 'relative'
      ..overflow = 'hidden'
      ..touchAction = 'pan-y'
      // ..height="100%"
      ..userSelect = 'none';
    viewport.style
      ..overflow = 'hidden'
      ..width = '100%'
      ..height = '100%'
      ..position = 'relative';
    track.style
      ..display = 'flex'
      ..flexDirection =
          (w.scrollDirection == Axis.horizontal) ? 'row' : 'column'
      ..gap = '0'
      ..willChange = 'transform'
      ..transition = 'transform 0ms';

    // pages
    if (_itemCount == 0) {
      track.children.add(DivElement()..text = '(PageView vide)');
    } else {
      for (int i = 0; i < _itemCount; i++) {
        final child = _buildItem(i);
        final slide =
            DivElement()
              ..style.flex =
                  (w.scrollDirection == Axis.horizontal)
                      ? '0 0 ${w.viewportFraction * 100}%'
                      : '0 0 ${w.viewportFraction * 100}%'
              ..style.maxWidth =
                  (w.scrollDirection == Axis.horizontal)
                      ? '${w.viewportFraction * 100}%'
                      : '100%'
              ..style.maxHeight =
                  (w.scrollDirection == Axis.vertical)
                      ? '${w.viewportFraction * 100}%'
                      : '100%'
              ..style.display = 'block';
        slide.children.add(child);
        track.children.add(slide);
      }
    }

    // indicateurs
    if (w.showIndicator && _itemCount > 1) {
      indicatorWrap.style
        ..position = 'absolute'
        ..left = '0'
        ..right = '0'
        ..bottom = '10px'
        ..display = 'flex'
        ..justifyContent = 'center'
        ..gap = '${w.indicatorStyle.spacing}px';
      _rebuildDots();
    }

    viewport.children.add(track);
    root.children.addAll([
      viewport,
      if (w.showIndicator && _itemCount > 1) indicatorWrap,
    ]);

    // mesures & position
    // _measure();
    // _goto(currentIndex, animate: false);

    // // événements
    // _wireGestures();
    // if (w.autoplay && _itemCount > 1) _startAutoplay();
    // if (w.pauseAutoplayOnHover) {
    //   root.onMouseOver.listen((_) {
    //     _stopAutoplay();
    //   });
    //   root.onMouseOut.listen((_) {
    //     if (w.autoplay) _startAutoplay();
    //   });
    // }
    // événements (gestures + hover)
_wireGestures();
if (w.pauseAutoplayOnHover) {
  root.onMouseOver.listen((_) => _stopAutoplay());
  root.onMouseOut.listen((_) { if (w.autoplay) _startAutoplay(); });
}
window.onResize.listen((_) => _measure());

// ⚠️ Mesure différée : attendre que le widget soit attaché et peint
_deferFirstLayout();

return root;

  }

  Element _buildItem(int i) {
    final r = (w.children != null) ? w.children![i] : w.itemBuilder!(i);
    // chaque item doit s'étirer à la taille du slide
    final wrap =
        DivElement()
          ..style.width = '100%'
          ..style.height = '100%';
    wrap.children.add(r.create());
    return wrap;
  }

  void _rebuildDots() {
    indicatorWrap.children.clear();
    for (int i = 0; i < _itemCount; i++) {
      final dot =
          DivElement()
            ..style.width = '${w.indicatorStyle.dotSize}px'
            ..style.height = '${w.indicatorStyle.dotSize}px'
            ..style.borderRadius = '999px'
            ..style.backgroundColor =
                (i == currentIndex)
                    ? w.indicatorStyle.activeColor
                    : w.indicatorStyle.color
            ..style.transform =
                (i == currentIndex)
                    ? 'scale(${w.indicatorStyle.activeScale})'
                    : 'scale(1)'
            ..style.transition =
                'transform 160ms ease, background-color 160ms ease';
      if (w.indicatorStyle.clickable) {
        dot.style.cursor = 'pointer';
        dot.onClick.listen((_) {
          _goTo(i, animate: true);
        });
      }
      indicatorWrap.children.add(dot);
    }
  }

  void _measure() {
    final rect = root.getBoundingClientRect();
    _viewW = rect.width.toDouble();
    _viewH =
        rect.height.toDouble() > 0
            ? rect.height.toDouble()
            : rect.width * 0.56; // défaut 16:9
    viewport.style.height = '${_viewH}px';
    _applyTransform();
  }

  void _wireGestures() {
    // souris
    root.onMouseDown.listen((e) {
      _drag = true;
      _dragStartX = e.client.x.toDouble();
      _dragStartY = e.client.y.toDouble();
      _dragOffset = 0;
      track.style.transition = 'transform 0ms';
    });
    document.onMouseMove.listen((e) {
      if (!_drag) return;
      _onDrag(
        deltaX: e.client.x - _dragStartX,
        deltaY: e.client.y - _dragStartY,
      );
    });
    document.onMouseUp.listen((_) {
      if (!_drag) return;
      _endDrag();
    });
    // tactile
    root.onTouchStart.listen((e) {
      if (e.touches!.isEmpty) return;
      final t = e.touches!.first;
      _drag = true;
      _dragStartX = t.client.x.toDouble();
      _dragStartY = t.client.y.toDouble();
      _dragOffset = 0;
      track.style.transition = 'transform 0ms';
    });
    root.onTouchMove.listen((e) {
      if (!_drag || e.touches!.isEmpty) return;
      final t = e.touches!.first;
      _onDrag(
        deltaX: t.client.x - _dragStartX,
        deltaY: t.client.y - _dragStartY,
      );
    });
    root.onTouchEnd.listen((_) {
      if (!_drag) return;
      _endDrag();
    });
  }
void _deferFirstLayout() {
  int tries = 0;
  void tick(num _) {
    final rect = root.getBoundingClientRect();
    if (rect.width > 0) {
      _measure();                       // calcule _viewW/_viewH et fixe la hauteur
      _goto(currentIndex, animate: false);
      if (w.autoplay && _itemCount > 1) _startAutoplay(); // démarrer après layout
    } else if (tries < 12) {            // ~ 12 frames ≈ 200ms
      tries++;
      window.requestAnimationFrame(tick);
    } else {
      // dernier recours : mesure quand même (ex: parent hidden/display:none)
      _measure();
      _goto(currentIndex, animate: false);
      if (w.autoplay && _itemCount > 1) _startAutoplay();
    }
  }
  window.requestAnimationFrame(tick);
}

  void _onDrag({required num deltaX, required num deltaY}) {
    if (w.scrollDirection == Axis.horizontal) {
      _dragOffset = deltaX.toDouble();
      _applyTransform(offsetPx: -_pageToPx(currentIndex) + _dragOffset);
    } else {
      _dragOffset = deltaY.toDouble();
      _applyTransform(offsetPx: -_pageToPx(currentIndex) + _dragOffset);
    }
  }

  void _endDrag() {
    _drag = false;
    final size =
        (w.scrollDirection == Axis.horizontal) ? _pageWidth() : _pageHeight();
    final thr = size * 0.25; // seuil 25%
    int target = currentIndex;
    if (_dragOffset.abs() > thr) {
      target =
          (w.scrollDirection == Axis.horizontal)
              ? (_dragOffset < 0 ? currentIndex + 1 : currentIndex - 1)
              : (_dragOffset < 0 ? currentIndex + 1 : currentIndex - 1);
    }
    _goTo(target, animate: true);
  }

  double _pageWidth() => _viewW * w.viewportFraction;
  double _pageHeight() => _viewH * w.viewportFraction;

  double _pageToPx(int index) {
    final size =
        (w.scrollDirection == Axis.horizontal) ? _pageWidth() : _pageHeight();
    return index * size;
  }

  void _applyTransform({double? offsetPx}) {
    final off = offsetPx ?? -_pageToPx(currentIndex);
    if (w.scrollDirection == Axis.horizontal) {
      track.style.transform = 'translate3d(${off}px,0,0)';
    } else {
      track.style.transform = 'translate3d(0,${off}px,0)';
    }
  }

  void _goto(int index, {bool animate = true, int durationMs = 280}) {
    currentIndex = index.clamp(0, math.max(0, _itemCount - 1));
    track.style.transition =
        animate
            ? 'transform ${durationMs}ms cubic-bezier(.2,.7,.2,1)'
            : 'transform 0ms';
    _applyTransform();
    _rebuildDots();
    w.controller?._page = currentIndex;
    w.onPageChanged?.call(currentIndex);
  }

  void _goTo(int index, {required bool animate, int durationMs = 280}) {
    if (_itemCount == 0) {
      return;
    }
    if (w.loop) {
      if (index < 0) index = _itemCount - 1;
      if (index >= _itemCount) index = 0;
    } else {
      index = index.clamp(0, _itemCount - 1);
    }
    _goto(index, animate: animate, durationMs: durationMs);
  }

  void _startAutoplay() {
    // _stopAutoplay();
    _autoTimer = Timer.periodic(Duration(milliseconds: w.autoplayIntervalMs), (
      timer,
    ) {
      _goTo(currentIndex + 1, animate: true);
    });
  }

  void _stopAutoplay() {
    if (_autoTimer != null && _autoTimer!.isActive) {
      _autoTimer?.cancel();
    }
  }
}
