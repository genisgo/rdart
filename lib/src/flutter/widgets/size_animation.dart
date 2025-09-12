part of 'widgets.dart';

// size_animation.dart — Rdart
// -----------------------------------------------------------------------------
// SizeAnimation : anime la taille d'un composant.
// Deux modes simples :
//  - SCALE : via transform: scale(sx, sy) (sans reflow, fluide)
//  - SIZE  : via width/height en px (reflow contrôlé)
// API : duration/delay/easing, autoplay, loop, yoyo, controller (play/pause/stop/seek)
// Ciblage : applyOn { root, child, both } (où appliquer la taille)
// Démos en bas du fichier
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
// Enums & petits modèles
// -----------------------------------------------------------------------------
enum SizeAnimMode { scale, size }

enum SizeApplyOn { root, child, both }

enum SizeEasing { linear, easeIn, easeOut, easeInOut }

class SizeScale {
  final double sx;
  final double sy;
  const SizeScale(this.sx, [this.sy = 1.0]);
}

class AnimationSizeBox {
  final double? widthPx;
  final double? heightPx;
  const AnimationSizeBox({this.widthPx, this.heightPx});
}

class SizeSnapshot {
  final double? widthPx;
  final double? heightPx;
  final double sx;
  final double sy;
  const SizeSnapshot({
    this.widthPx,
    this.heightPx,
    required this.sx,
    required this.sy,
  });
  @override
  String toString() =>
      'SizeSnapshot(w:${widthPx?.toStringAsFixed(1)}, h:${heightPx?.toStringAsFixed(1)}, sx:${sx.toStringAsFixed(3)}, sy:${sy.toStringAsFixed(3)})';
}

// -----------------------------------------------------------------------------
// Contrôleur externe
// -----------------------------------------------------------------------------
class SizeAnimationController {
  _SizeAnimationState? _state;
  bool get isRunning => _state?._running ?? false;
  double get progress => _state?._t ?? 0.0; // 0..1
  void _attach(_SizeAnimationState s) {
    _state = s;
  }

  void _detach() {
    _state = null;
  }

  void play() => _state?._play();
  void pause() => _state?._pause();
  void stop() => _state?._stop();
  void reverse() => _state?._reverse();
  void seek(double t) => _state?._seek(t.clamp(0.0, 1.0));
}

// -----------------------------------------------------------------------------
// Widget d'animation
// -----------------------------------------------------------------------------
class SizeAnimation extends Relement {
  final Relement child;
  final SizeAnimMode mode;
  final SizeScale? fromScale;
  final SizeScale? toScale;
  final AnimationSizeBox? fromBox;
  final AnimationSizeBox? toBox;
  final int durationMs;
  final int delayMs;
  final bool autoplay;
  final bool loop;
  final bool yoyo;
  final SizeEasing easing;
  final SizeApplyOn applyOn;
  final String transformOrigin; // pour SCALE
  final void Function(SizeSnapshot snap)? onUpdate;
  final void Function()? onComplete;
  final SizeAnimationController? controller;

  // Constructeur principal
  SizeAnimation._internal({
    required this.child,
    required this.mode,
    this.fromScale,
    this.toScale,
    this.fromBox,
    this.toBox,
    this.durationMs = 800,
    this.delayMs = 0,
    this.autoplay = true,
    this.loop = false,
    this.yoyo = false,
    this.easing = SizeEasing.easeInOut,
    this.applyOn = SizeApplyOn.root,
    this.transformOrigin = 'center center',
    this.onUpdate,
    this.onComplete,
    this.controller,
    super.id,
  });

  // Només pour confort
  factory SizeAnimation.scale({
    required Relement child,
    required SizeScale from,
    required SizeScale to,
    int durationMs = 800,
    int delayMs = 0,
    bool autoplay = true,
    bool loop = false,
    bool yoyo = false,
    SizeEasing easing = SizeEasing.easeInOut,
    SizeApplyOn applyOn = SizeApplyOn.root,
    String transformOrigin = 'center center',
    void Function(SizeSnapshot snap)? onUpdate,
    void Function()? onComplete,
    SizeAnimationController? controller,
    String? id,
  }) => SizeAnimation._internal(
    child: child,
    mode: SizeAnimMode.scale,
    fromScale: from,
    toScale: to,
    durationMs: durationMs,
    delayMs: delayMs,
    autoplay: autoplay,
    loop: loop,
    yoyo: yoyo,
    easing: easing,
    applyOn: applyOn,
    transformOrigin: transformOrigin,
    onUpdate: onUpdate,
    onComplete: onComplete,
    controller: controller,
    id: id,
  );

  factory SizeAnimation.size({
    required Relement child,
    required AnimationSizeBox from,
    required AnimationSizeBox to,
    int durationMs = 800,
    int delayMs = 0,
    bool autoplay = true,
    bool loop = false,
    bool yoyo = false,
    SizeEasing easing = SizeEasing.easeInOut,
    SizeApplyOn applyOn = SizeApplyOn.root,
    void Function(SizeSnapshot snap)? onUpdate,
    void Function()? onComplete,
    SizeAnimationController? controller,
    String? id,
  }) => SizeAnimation._internal(
    child: child,
    mode: SizeAnimMode.size,
    fromBox: from,
    toBox: to,
    durationMs: durationMs,
    delayMs: delayMs,
    autoplay: autoplay,
    loop: loop,
    yoyo: yoyo,
    easing: easing,
    applyOn: applyOn,
    onUpdate: onUpdate,
    onComplete: onComplete,
    controller: controller,
    id: id,
  );

  late final _SizeAnimationState _state;
  @override
  Element create() {
    _state = _SizeAnimationState(this);
    controller?._attach(_state);
    return _state.create();
  }

  @override
  Element get getElement => _state.root;
}

// -----------------------------------------------------------------------------
// Implémentation interne
// -----------------------------------------------------------------------------
class _SizeAnimationState {
  final SizeAnimation w;
  _SizeAnimationState(this.w);
  late final DivElement root;
  late final Element childEl;

  bool _running = false;
  bool _forward = true;
  double _t = 0.0;
  num _startTime = 0;
  late SizeScale _fromScale, _toScale;
  late AnimationSizeBox _fromBox, _toBox;

  Element create() {
    root =
        DivElement()
          ..style.position = 'relative'
          ..style.display =
              w.mode == SizeAnimMode.size ? 'inline-block' : 'block'
          ..style.willChange =
              w.mode == SizeAnimMode.scale ? 'transform' : 'width, height';

    childEl = w.child.create();
    root.append(childEl);

    if (w.mode == SizeAnimMode.scale) {
      _fromScale = w.fromScale ?? const SizeScale(1, 1);
      _toScale = w.toScale ?? const SizeScale(1, 1);
      _applyScale(
        _mixDouble(_fromScale.sx, _toScale.sx, 0.0),
        _mixDouble(_fromScale.sy, _toScale.sy, 0.0),
      );
    } else {
      // SIZE : si from/to partiels, on complète avec mesures actuelles
      final currentW =
          _readPx(childEl, 'width') ?? childEl.getBoundingClientRect().width;
      final currentH =
          _readPx(childEl, 'height') ?? childEl.getBoundingClientRect().height;
      final f =
          w.fromBox ??
          AnimationSizeBox(widthPx: currentW.toDouble(), heightPx: currentH.toDouble());
      final t =
          w.toBox ??
          AnimationSizeBox(widthPx: currentW.toDouble(), heightPx: currentH.toDouble());
      _fromBox = AnimationSizeBox(
        widthPx: f.widthPx ?? currentW.toDouble(),
        heightPx: f.heightPx ?? currentH.toDouble(),
      );
      _toBox = AnimationSizeBox(
        widthPx: t.widthPx ?? currentW.toDouble(),
        heightPx: t.heightPx ?? currentH.toDouble(),
      );
      _applySize(
        _mixDouble(_fromBox.widthPx!, _toBox.widthPx!, 0.0),
        _mixDouble(_fromBox.heightPx!, _toBox.heightPx!, 0.0),
      );
    }

    if (w.autoplay) {
      if (w.delayMs > 0) {
        Future.delayed(Duration(milliseconds: w.delayMs), () => _play());
      } else {
        _play();
      }
    }
    return root;
  }

  // RAF loop
  void _play() {
    if (_running) return;
    _running = true;
    if (_t >= 1.0 && !w.loop && !w.yoyo) {
      _running = false;
      return;
    }
    _startTime = 0;
    _animate();
  }

  void _pause() {
    _running = false;
  }

  void _stop() {
    _running = false;
    _t = 0.0;
    _forward = true;
    _applyAt(_t);
  }

  void _reverse() {
    _forward = !_forward;
    if (!_running) _play();
  }

  void _seek(double t) {
    _t = t;
    _applyAt(_t);
  }

  void _animate([num? ts]) {
    if (!_running) return;
    window.requestAnimationFrame((timestamp) {
      if (!_running) return;
      if (_startTime == 0) _startTime = timestamp;
      final elapsed = timestamp - _startTime;
      final d = w.durationMs.toDouble();
      var raw = (elapsed / d).clamp(0.0, 1.0);
      _t = _forward ? raw : (1.0 - raw);
      final eased = _ease(w.easing, _t);
      _applyAt(eased);

      final end = elapsed >= d - 0.0001;
      if (end) {
        if (w.yoyo) {
          _forward = !_forward;
          _startTime = timestamp;
          _animate(timestamp);
          return;
        }
        if (w.loop) {
          _forward = true;
          _startTime = timestamp;
          _animate(timestamp);
          return;
        }
        _running = false;
        w.onComplete?.call();
        return;
      }
      _animate(timestamp);
    });
  }

  void _applyAt(double t) {
    if (w.mode == SizeAnimMode.scale) {
      final sx = _mixDouble(_fromScale.sx, _toScale.sx, t);
      final sy = _mixDouble(_fromScale.sy, _toScale.sy, t);
      _applyScale(sx, sy);
      w.onUpdate?.call(
        SizeSnapshot(sx: sx, sy: sy, widthPx: null, heightPx: null),
      );
    } else {
      final wpx = _mixDouble(_fromBox.widthPx!, _toBox.widthPx!, t);
      final hpx = _mixDouble(_fromBox.heightPx!, _toBox.heightPx!, t);
      _applySize(wpx, hpx);
      w.onUpdate?.call(SizeSnapshot(sx: 1, sy: 1, widthPx: wpx, heightPx: hpx));
    }
  }

  // Application concrète
  void _applyScale(double sx, double sy) {
    final els = <Element>[];
    if (w.applyOn == SizeApplyOn.root || w.applyOn == SizeApplyOn.both) {
      els.add(root);
    }
    if (w.applyOn == SizeApplyOn.child || w.applyOn == SizeApplyOn.both) {
      els.add(childEl);
    }
    for (final el in els) {
      el.style.transformOrigin = w.transformOrigin;
      el.style.transform =
          'scale(${sx.toStringAsFixed(5)}, ${sy.toStringAsFixed(5)})';
    }
  }

  void _applySize(double widthPx, double heightPx) {
    final els = <Element>[];
    if (w.applyOn == SizeApplyOn.root || w.applyOn == SizeApplyOn.both) {
      els.add(root);
    }
    if (w.applyOn == SizeApplyOn.child || w.applyOn == SizeApplyOn.both) {
      els.add(childEl);
    }
    for (final el in els) {
      el.style.width = '${widthPx.toStringAsFixed(2)}px';
      el.style.height = '${heightPx.toStringAsFixed(2)}px';
    }
  }

  // Utils
  double _mixDouble(double a, double b, double t) => a + (b - a) * t;
  double _ease(SizeEasing e, double t) {
    switch (e) {
      case SizeEasing.linear:
        return t;
      case SizeEasing.easeIn:
        return t * t;
      case SizeEasing.easeOut:
        return 1 - (1 - t) * (1 - t);
      case SizeEasing.easeInOut:
        return t * t * (3 - 2 * t);
    }
  }

  double? _readPx(Element el, String prop) {
    final v = el.getComputedStyle().getPropertyValue(prop);
    if (v.isEmpty || v == 'auto') return null;
    final num = double.tryParse(v.replaceAll('px', '').trim());
    return num;
  }
}
