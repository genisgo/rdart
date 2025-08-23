part of 'widgets.dart';

// Courbes d'animation (mapping → cubic-bezier)
enum Curve { ease, easeIn, easeOut, easeInOut, decelerate, fastOutSlowIn }

String _curveCss(Curve c) {
  switch (c) {
    case Curve.ease:
      return 'ease';
    case Curve.easeIn:
      return 'cubic-bezier(.4,0,1,1)';
    case Curve.easeOut:
      return 'cubic-bezier(0,0,.2,1)';
    case Curve.easeInOut:
      return 'cubic-bezier(.4,0,.2,1)';
    case Curve.decelerate:
      return 'cubic-bezier(0,0,.2,1)'; // material-ish
    case Curve.fastOutSlowIn:
      return 'cubic-bezier(.4,0,.2,1)';
  }
}

bool _cssInjectedAnimatedWidgets = false;
void _ensureCssAnimatedWidgets() {
  if (_cssInjectedAnimatedWidgets) return;
  _cssInjectedAnimatedWidgets = true;
  final style =
      StyleElement()
        ..id = 'rdx-animations'
        ..text = r'''
/* === FadeScaleTransition === */
.rdx-fadescale{ display:inline-block; }
.rdx-fadescale .fs-content{ opacity:0; transform: scale(.96); will-change: transform, opacity; }
.rdx-fadescale.in .fs-content{ opacity:1; transform: none; }

/* === AnimatedSwitcher === */
.rdx-switcher{ position:relative; display:inline-block; }
.rdx-switcher .sw-child{ position:absolute; inset:0; }
.rdx-switcher .sw-child.static{ position:static; }
/* states */
.rdx-switcher .enter{ opacity:0; }
.rdx-switcher .enter.fadeScale{ transform: scale(.96); }
.rdx-switcher .enter.slide-left{ transform: translateX(8px); }
.rdx-switcher .enter.slide-right{ transform: translateX(-8px); }
.rdx-switcher .enter.slide-up{ transform: translateY(8px); }
.rdx-switcher .enter.slide-down{ transform: translateY(-8px); }

.rdx-switcher .leave{ opacity:1; }
.rdx-switcher .leave.fadeScale{ transform: none; }
.rdx-switcher .leave.slide-left{ transform: translateX(0); }
.rdx-switcher .leave.slide-right{ transform: translateX(0); }
.rdx-switcher .leave.slide-up{ transform: translateY(0); }
.rdx-switcher .leave.slide-down{ transform: translateY(0); }

/* when animating */
.rdx-switcher.anim .enter, .rdx-switcher.anim .leave{ will-change: transform, opacity; }


''';
  document.head?.append(style);
}

/// ============================================================================
/// 1) FadeScaleTransition – apparition élégante (opacity + scale)
/// ============================================================================
class FadeScaleTransition extends Relement {
  final Relement child;
  bool visible;
  final int durationMs;
  final int delayMs;
  final Curve curve;
  final double initialScale;

  FadeScaleTransition({
    required this.child,
    this.visible = true,
    this.durationMs = 180,
    this.delayMs = 0,
    this.curve = Curve.fastOutSlowIn,
    this.initialScale = .96,
    super.id,
  });

  final _root = DivElement();
  final _content = DivElement();

  @override
  Element create() {
    _ensureCssAnimatedWidgets();
    _root
      ..id = id ?? 'fs-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-fadescale');

    _content
      ..classes.add('fs-content')
      ..style.transition =
          'opacity ${durationMs}ms ${_curveCss(curve)} ${delayMs}ms, '
          'transform ${durationMs}ms ${_curveCss(curve)} ${delayMs}ms'
      ..children.add(child.create());

    _root.children
      ..clear()
      ..add(_content);

    // état initial
    if (visible) {
      // force a reflow then add class
      window.requestAnimationFrame((_) => _root.classes.add('in'));
    }

    return _root;
  }

  void setVisible(bool v) {
    visible = v;
    _root.classes.toggle('in', v);
  }

  @override
  Element get getElement => _root;
}

/// ============================================================================
/// 2) AnimatedSwitcher – transition entre deux enfants
/// ============================================================================
enum SwitcherTransition { fade, fadeScale, slide }

enum AxisDirection { left, right, up, down }

class AnimatedSwitcher extends Relement {
  Relement? child;
  final int durationMs;
  final Curve curve;
  final SwitcherTransition transition;
  final AxisDirection slideDirection;
  final bool
  maintainSize; // si true, le conteneur garde la taille du plus grand

  AnimatedSwitcher({
    this.child,
    this.durationMs = 220,
    this.curve = Curve.fastOutSlowIn,
    this.transition = SwitcherTransition.fadeScale,
    this.slideDirection = AxisDirection.left,
    this.maintainSize = true,
    super.id,
  });

  final _root = DivElement();
  Element? _currentEl;

  @override
  Element create() {
    _ensureCssAnimatedWidgets();
    _root
      ..id = id ?? 'sw-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-switcher');

    if (maintainSize) {
      _root.style.display = 'grid';
    }

    if (child != null) {
      final el = child!.create();
      final wrap =
          DivElement()
            ..classes.addAll(['sw-child', 'enter', _enterClass()])
            ..style.transition = _transitionCss();
      wrap.children.add(el);
      if (maintainSize) {
        wrap.classes.add('static');
      }
      _root.children.add(wrap);
      _currentEl = wrap;
      // remove enter state next tick
      window.requestAnimationFrame((_) {
        wrap.classes.remove('enter');
      });
    }

    return _root;
  }

  void setChild(Relement newChild) {
    final incoming =
        DivElement()
          ..classes.addAll(['sw-child', 'enter', _enterClass()])
          ..style.transition = _transitionCss();
    incoming.children.add(newChild.create());

    _root.classes.add('anim');
    _root.children.add(incoming);

    if (_currentEl != null) {
      final leaving = _currentEl!;
      leaving.classes
        ..remove('enter')
        ..add('leave')
        ..add(_leaveClass());
      (leaving as DivElement).style.transition = _transitionCss();

      // schedule removal at end of transition
      Future.delayed(
        Duration(milliseconds: durationMs + 40),
        () => leaving.remove(),
      );
    }

    // Enter animation start → remove enter flag next tick
    window.requestAnimationFrame((_) {
      incoming.classes.remove('enter');
    });

    _currentEl = incoming;

    // cleanup anim flag
    Future.delayed(
      Duration(milliseconds: durationMs + 60),
      () => _root.classes.remove('anim'),
    );
  }

  String _transitionCss() {
    final t =
        'transform ${durationMs}ms ${_curveCss(curve)}, opacity ${durationMs}ms ${_curveCss(curve)}';
    return t;
  }

  String _enterClass() {
    switch (transition) {
      case SwitcherTransition.fade:
        return 'fadeScale'; // same but scale=none handled by CSS end-state
      case SwitcherTransition.fadeScale:
        return 'fadeScale';
      case SwitcherTransition.slide:
        switch (slideDirection) {
          case AxisDirection.left:
            return 'slide-left';
          case AxisDirection.right:
            return 'slide-right';
          case AxisDirection.up:
            return 'slide-up';
          case AxisDirection.down:
            return 'slide-down';
        }
    }
  }

  String _leaveClass() {
    // same mapping – we animate from neutral to offset on leave
    return _enterClass();
  }

  @override
  Element get getElement => _root;
}




// ============================================================================
// EXTRA CSS for Shimmer & Hero (injected once)
// ============================================================================
bool _extraCssInjected = false;
void _ensureAnimationsExtraCss(){
  if(_extraCssInjected) return; _extraCssInjected = true;
  final style = StyleElement()
    ..id = 'rdx-animations-extra'
    ..text = r'''
/* === Shimmer =============================================== */
.rdx-shimmer{ position:relative; display:inline-block; overflow:hidden; }
.rdx-shimmer.on::after{
  content:''; position:absolute; inset:0; border-radius: var(--sh-radius, 8px);
  background: linear-gradient(90deg,
      var(--sh-base, #f3f4f6) 0%,
      var(--sh-base, #f3f4f6) 40%,
      var(--sh-hi,   #ffffff) 50%,
      var(--sh-base, #f3f4f6) 60%,
      var(--sh-base, #f3f4f6) 100%);
  background-size: 200% 100%;
  animation: rdx-shimmer-move var(--sh-duration, 1500ms) linear infinite;
}
@keyframes rdx-shimmer-move { 0%{ background-position: -150% 0;} 100%{ background-position: 150% 0;} }

.rdx-shimmer-box{ display:block; width: var(--sh-w, 120px); height: var(--sh-h, 16px); background: var(--sh-base, #f3f4f6); border-radius: var(--sh-radius, 8px); }

/* === Hero =================================================== */
.rdx-hero{ display:inline-block; position:relative; }
.rdx-hero-clone{ position:fixed; left:0; top:0; will-change: transform, opacity; pointer-events:none; z-index: 9999; }
.rdx-hero-stage{ position:fixed; inset:0; }
.rdx-hero-hide{ opacity:0 !important; visibility:hidden !important; }
''';
  document.head?.append(style);
}

/// ============================================================================
/// 4) Shimmer – overlay animé pour loading (skeleton ou par-dessus un child)
/// ============================================================================
class Shimmer extends Relement {
  final Relement? child; // si null -> rectangle (ShimmerBox intégré)
  final bool enabled;
  final int durationMs;         // 800..2500 recommandé
  final String baseColor;       // ex: '#f3f4f6'
  final String highlightColor;  // ex: '#ffffff'
  final double borderRadius;    // px
  final double? width;          // utilisé si child == null
  final double? height;         // utilisé si child == null

  Shimmer({
    this.child,
    this.enabled = true,
    this.durationMs = 1500,
    this.baseColor = '#f3f4f6',
    this.highlightColor = '#ffffff',
    this.borderRadius = 8,
    this.width,
    this.height,
    super.id,
  });

  final _root = DivElement();

  @override
  Element create(){
    _ensureAnimationsExtraCss();
    _root
      ..id = id ?? 'sh-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-shimmer')
      ..classes.toggle('on', enabled)
      ..style.setProperty('--sh-base', baseColor)
      ..style.setProperty('--sh-hi', highlightColor)
      ..style.setProperty('--sh-duration', '${durationMs}ms')
      ..style.setProperty('--sh-radius', '${borderRadius}px');

    if(child != null){
      _root.children.add(child!.create());
    } else {
      final box = DivElement()..classes.add('rdx-shimmer-box');
      if(width != null) box.style.setProperty('--sh-w', '${width}px');
      if(height != null) box.style.setProperty('--sh-h', '${height}px');
      _root.children.add(box);
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  void setEnabled(bool v){ _root.classes.toggle('on', v); }
}


/// ============================================================================
/// 5) Hero – shared element transition (simplifiée)
/// ============================================================================
class Hero extends Relement {
  final String tag;
  final Relement child;
  Hero({required this.tag, required this.child, super.id});

  final _root =DivElement();

  @override
  Element create(){
    _ensureAnimationsExtraCss();
    _root
      ..id = id ?? 'hero-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-hero')
      ..dataset['hero'] = tag;
    _root.children.add(child.create());
    return _root;
  }

  @override
  Element get getElement => _root;
}

class HeroAnimator {
  static Future<void> transition({
    required Element fromPage,
    required Element toPage,
    required String tag,
    int durationMs = 320,
    Curve curve = Curve.fastOutSlowIn,
    bool fadePages = true,
    bool animateBorderRadius = false,
  }) async {
    _ensureAnimationsExtraCss();

    // 1) Source
    final src = fromPage.querySelector('[data-hero="$tag"]');
    if (src == null) return;

    // 2) Préparer la page cible (mesurable mais hors flux visuel)
    toPage.classes.add('rdx-hero-stage');
    toPage.style
      ..position = 'fixed'
      // ..in = '0'
      ..opacity = '0'
      ..visibility = 'hidden'
      ..pointerEvents = 'none';
    // document.body?.append(toPage);

    // Laisser le layout se stabiliser
    await _nextFrame();

    final dst = toPage.querySelector('[data-hero="$tag"]');
    if (dst == null) { toPage.remove(); return; }

    // 3) Mesures
    final sRect = src.getBoundingClientRect();
    final dRect = dst.getBoundingClientRect();

    // 4) Clone visuel
    final clone = src.clone(true) as Element;
    final host = DivElement()..classes.add('rdx-hero-clone');
    host.style
      ..width = '${sRect.width}px'
      ..height = '${sRect.height}px'
      ..transformOrigin = '0 0'
      ..transform = 'translate(${sRect.left}px, ${sRect.top}px) scale(1,1)'
      ..transition = 'transform ${durationMs}ms ${_curveCss(curve)}, opacity ${durationMs}ms ${_curveCss(curve)}';

    if (animateBorderRadius) {
      final srcRad = src.style.borderRadius;
      final dstRad = dst.style.borderRadius;
      clone.style
        ..borderRadius = (srcRad.isEmpty ? '0px' :srcRad)
        ..overflow = 'hidden'
        ..transition = 'border-radius ${durationMs}ms ${_curveCss(curve)}';
      clone.dataset['__dstRad'] = (dstRad.isEmpty ? '0px' : dstRad);
    }

    host.append(clone);
    document.body?.append(host);

    // 5) Masquer src/dst durant la transition
    src.classes.add('rdx-hero-hide');
    dst.classes.add('rdx-hero-hide');

    // 6) Animer fondu pages (optionnel)
    toPage.style.visibility = 'visible';
    if (fadePages) {
      fromPage.style.transition = 'opacity ${durationMs}ms ${_curveCss(curve)}';
      toPage.style.transition   = 'opacity ${durationMs}ms ${_curveCss(curve)}';
      await _nextFrame();
      fromPage.style.opacity = '0';
      toPage.style.opacity = '1';
    } else {
      toPage.style.opacity = '1';
    }

    // 7) Lancer la transform après un frame
    await _nextFrame();
    final sx = dRect.width == 0 ? 1.0 : dRect.width / sRect.width;
    final sy = dRect.height == 0 ? 1.0 : dRect.height / sRect.height;
    host.style.transform = 'translate(${dRect.left}px, ${dRect.top}px) scale(${sx}, ${sy})';
    if (animateBorderRadius) {
      final dstRad = clone.dataset['__dstRad'];
      if (dstRad != null) clone.style.borderRadius = dstRad;
    }

    // 8) Fin & nettoyage
    await _delay(durationMs + 20);
    host.remove();
    dst.classes.remove('rdx-hero-hide');

    // libère la page cible (redevient normale)
    toPage.style
      ..position = ''
      // ..inset = ''
      ..opacity = ''
      ..visibility = ''
      ..pointerEvents = ''
      ..transition = '';
    toPage.classes.remove('rdx-hero-stage');

    // enlève l'ancienne page
    fromPage.remove();
  }

  // Helpers internes
  static Future<void> _nextFrame() async {
    final c = Completer<void>();
    window.requestAnimationFrame((_) => c.complete());
    return c.future;
  }

  static Future<void> _delay(int ms) async {
    final c = Completer<void>();
    Future.delayed(Duration(milliseconds: ms),() => c.complete());
    return c.future;
  }
}

