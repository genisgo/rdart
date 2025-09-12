part of 'widgets.dart';

// color_animation.dart — Rdart
// -----------------------------------------------------------------------------
// ColorAnimation : anime une couleur CSS entre `from` et `to` sur un ou
// plusieurs "targets" (background, texte, bordure, outline).
// - API proche Flutter-light: controller.play/pause/stop/seek, loop, yoyo, delay
// - Easing simple: linear, easeIn, easeOut, easeInOut (smoothstep)
// - Autoplay optionnel
// - On applique la couleur sur un wrapper autour de `child` (Relement)
// - Callback onUpdate/onComplete et CSS var --anim-color (utile pour thèmes)
// -----------------------------------------------------------------------------
// color_animation_v2.dart — Rdart
// -----------------------------------------------------------------------------
// Correctifs :
// - Ajout de `ColorApplyOn { root, child, both }` pour appliquer la couleur
//   sur le wrapper (root), sur l'enfant (child) ou sur les deux.
// - Les démos 2 (texte) et 3 (bordure) utilisent `applyOn: ColorApplyOn.child`
//   pour que la couleur remplace bien le style du composant enfant.
// - _DemoCard : n'applique plus une couleur de texte quand textMode=true.
// -----------------------------------------------------------------------------

// Cibles et options
enum ColorTarget { background, text, border, outline }

enum ColorEasing { linear, easeIn, easeOut, easeInOut }

enum ColorApplyOn { root, child, both }

class ColorAnimationController {
  _ColorAnimationState? _state;
  bool get isRunning => _state?._running ?? false;
  double get progress => _state?._t ?? 0.0; // 0..1
  void _attach(_ColorAnimationState s) {
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

class ColorAnimation extends Relement {
  final Relement child;
  final String from; // '#RRGGBB' | 'rgb(...)' | 'rgba(...)' | css color
  final String to; // idem
  final List<ColorTarget> targets; // où appliquer
  final ColorApplyOn applyOn; // root/child/both
  final int durationMs;
  final int delayMs;
  final bool autoplay;
  final bool loop;
  final bool yoyo;
  final ColorEasing easing;
  final void Function(String cssColor)? onUpdate;
  final void Function()? onComplete;
  final ColorAnimationController? controller;

  ColorAnimation({
    required this.child,
    required this.from,
    required this.to,
    this.targets = const [ColorTarget.background],
    this.applyOn = ColorApplyOn.root,
    this.durationMs = 800,
    this.delayMs = 0,
    this.autoplay = true,
    this.loop = false,
    this.yoyo = false,
    this.easing = ColorEasing.easeInOut,
    this.onUpdate,
    this.onComplete,
    this.controller,
    super.id,
  });

  late final _ColorAnimationState _state;
  @override
  Element create() {
    _state = _ColorAnimationState(this);
    controller?._attach(_state);
    return _state.create();
  }

  @override
  Element get getElement => _state.root;
}

class _ColorAnimationState {
  final ColorAnimation w;
  _ColorAnimationState(this.w);
  late final DivElement root; // wrapper
  late final Element childEl; // élément enfant (où on peut aussi appliquer)

  bool _running = false;
  bool _forward = true;
  double _t = 0.0;
  num _startTime = 0;
  late final _RGBA _from;
  late final _RGBA _to;

  Element create() {
    root =
        DivElement()
          ..style.position = 'relative'
          ..style.display = 'block';
    childEl = w.child.create();
    root.append(childEl);

    _from = _parseColor(w.from);
    _to = _parseColor(w.to);
    _applyColor(_mix(0.0));

    if (w.autoplay) {
      if (w.delayMs > 0) {
        Future.delayed(Duration(milliseconds: w.delayMs), () => _play());
      } else {
        _play();
      }
    }
    return root;
  }

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
    _applyColor(_mix(_t));
  }

  void _reverse() {
    _forward = !_forward;
    if (!_running) _play();
  }

  void _seek(double t) {
    _t = t;
    _applyColor(_mix(_t));
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
      final col = _mix(eased);
      _applyColor(col);
      w.onUpdate?.call(col.toCss());

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

  void _applyColor(_RGBA c) {
    final css = c.toCss();
    // Détermine les éléments à affecter
    final targetsEl = <Element>[];
    if (w.applyOn == ColorApplyOn.root || w.applyOn == ColorApplyOn.both) {
      targetsEl.add(root);
    }
    if (w.applyOn == ColorApplyOn.child || w.applyOn == ColorApplyOn.both) {
      targetsEl.add(childEl);
    }

    for (final el in targetsEl) {
      el.style.setProperty('--anim-color', css);
      for (final t in w.targets) {
        switch (t) {
          case ColorTarget.background:
            el.style.backgroundColor = css;
            break;
          case ColorTarget.text:
            el.style.color = css;
            break;
          case ColorTarget.border:
            el.style.borderColor = css;
            if ((el.style.borderStyle ?? '').isEmpty) {
              el.style.borderStyle = 'solid';
            }
            if ((el.style.borderWidth ?? '').isEmpty) {
              el.style.borderWidth = '2px';
            }
            break;
          case ColorTarget.outline:
            el.style.outlineColor = css;
            if (el.style.outlineStyle.isEmpty) {
              el.style.outlineStyle = 'solid';
            }
            if ((el.style.outlineWidth ?? '').isEmpty) {
              el.style.outlineWidth = '2px';
            }
            break;
        }
      }
    }
  }

  _RGBA _mix(double t) {
    double lerp(double a, double b) => a + (b - a) * t;
    return _RGBA(
      lerp(_from.r, _to.r),
      lerp(_from.g, _to.g),
      lerp(_from.b, _to.b),
      lerp(_from.a, _to.a),
    );
  }

  double _ease(ColorEasing e, double t) {
    switch (e) {
      case ColorEasing.linear:
        return t;
      case ColorEasing.easeIn:
        return t * t;
      case ColorEasing.easeOut:
        return 1 - (1 - t) * (1 - t);
      case ColorEasing.easeInOut:
        return t * t * (3 - 2 * t); // smoothstep
    }
  }

  _RGBA _parseColor(String s) {
    final x = s.trim();
    if (x.startsWith('#')) return _parseHex(x);
    if (x.startsWith('rgb')) return _parseRgb(x);
    final tmp = DivElement();
    tmp.style.color = x;
    final css = tmp.getComputedStyle().color ?? 'rgba(0,0,0,1)';
    return _parseRgb(css);
  }

  _RGBA _parseHex(String h) {
    var s = h.replaceFirst('#', '');
    if (s.length == 3) {
      s = s.split('').map((c) => c + c).join();
    }
    if (s.length == 6) s = s + 'ff';
    final r = int.parse(s.substring(0, 2), radix: 16);
    final g = int.parse(s.substring(2, 4), radix: 16);
    final b = int.parse(s.substring(4, 6), radix: 16);
    final a = int.parse(s.substring(6, 8), radix: 16) / 255.0;
    return _RGBA(r.toDouble(), g.toDouble(), b.toDouble(), a);
  }

  _RGBA _parseRgb(String rgb) {
    final nums = rgb.replaceAll(RegExp(r'[^0-9.,]'), '').split(',');
    if (nums.length < 3) return _RGBA(0, 0, 0, 1);
    final r = double.tryParse(nums[0]) ?? 0;
    final g = double.tryParse(nums[1]) ?? 0;
    final b = double.tryParse(nums[2]) ?? 0;
    final a = nums.length > 3 ? (double.tryParse(nums[3]) ?? 1) : 1;
    return _RGBA(r, g, b, a.toDouble());
  }
}

class _RGBA {
  final double r, g, b, a;
  _RGBA(this.r, this.g, this.b, this.a);
  String toCss() =>
      'rgba(${r.round()}, ${g.round()}, ${b.round()}, ${a.toStringAsFixed(3)})';
}
