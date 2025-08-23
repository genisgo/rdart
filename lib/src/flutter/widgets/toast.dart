part of 'widgets.dart';

// Toast élégant — V2
// - Décorable via BoxDecoration
// - title et message sont des Relement
// - Icône de type BsIcon
// - Conserve: positions, auto-dismiss, pause hover, action, close, progress, pile

// Si votre projet expose BsIcon ailleurs, importez-le à la place.
// Ici on assume un Relement simple: BsIcon(String name, {double size, String? color})

// ---------------------- Positions & Types ----------------------
enum ToastType { info, success, warning, error }

enum ToastPosition {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
  topCenter,
  bottomCenter,
}

// ---------------------- Options -------------------------------
class ToastOptions {
  final Relement? title; // widget
  final Relement message; // widget (obligatoire)
  final BsIcon? icon; // widget icône (optionnel)
  final ToastType type;
  final ToastPosition position;
  final int durationMs; // 0 => persistant
  final bool closeOnClick;
  final bool showCloseButton;
  final String? actionLabel;
  final void Function()? onAction;
  final bool showProgress;
  final BoxDecoration? decoration; // Personnalise la carte
  final String? accentColor; // couleur pour barre de progression / icône bg

  const ToastOptions({
    this.title,
    required this.message,
    this.icon,
    this.type = ToastType.info,
    this.position = ToastPosition.topRight,
    this.durationMs = 3500,
    this.closeOnClick = false,
    this.showCloseButton = true,
    this.actionLabel,
    this.onAction,
    this.showProgress = true,
    this.decoration,
    this.accentColor,
  });
}

// ---------------------- Host (pile + API) ---------------------
class ToastHost extends Relement {
  static ToastHost? _instance;
  static ToastHost I() => _instance ??= ToastHost._();
  ToastHost._() : super(id: 'toast-host');

  // API pratique
  static ToastRef show(ToastOptions o) => I()._show(o);
  static ToastRef info(
    Relement message, {
    Relement? title,
    BsIcon? icon,
    ToastPosition pos = ToastPosition.topRight,
    int durationMs = 3500,
    BoxDecoration? decoration,
  }) => show(
    ToastOptions(
      message: message,
      title: title,
      icon: icon,
      type: ToastType.info,
      position: pos,
      durationMs: durationMs,
      decoration: decoration,
    ),
  );
  static ToastRef success(
    Relement message, {
    Relement? title,
    BsIcon? icon,
    ToastPosition pos = ToastPosition.topRight,
    int durationMs = 3000,
    BoxDecoration? decoration,
  }) => show(
    ToastOptions(
      message: message,
      title: title,
      icon: icon,
      type: ToastType.success,
      position: pos,
      durationMs: durationMs,
      decoration: decoration,
    ),
  );
  static ToastRef warning(
    Relement message, {
    Relement? title,
    BsIcon? icon,
    ToastPosition pos = ToastPosition.topRight,
    int durationMs = 4000,
    BoxDecoration? decoration,
  }) => show(
    ToastOptions(
      message: message,
      title: title,
      icon: icon,
      type: ToastType.warning,
      position: pos,
      durationMs: durationMs,
      decoration: decoration,
    ),
  );
  static ToastRef error(
    Relement message, {
    Relement? title,
    BsIcon? icon,
    ToastPosition pos = ToastPosition.topRight,
    int durationMs = 5000,
    BoxDecoration? decoration,
  }) => show(
    ToastOptions(
      message: message,
      title: title,
      icon: icon,
      type: ToastType.error,
      position: pos,
      durationMs: durationMs,
      decoration: decoration,
    ),
  );

  // DOM piles par position
  final _stacks = <ToastPosition, DivElement>{};

  @override
  Element create() {
    // Crée un conteneur par position pour éviter reflow
    for (final p in ToastPosition.values) {
      final host =
          DivElement()
            ..style.position = 'fixed'
            ..style.zIndex = '9999'
            ..style.pointerEvents = 'none';
      switch (p) {
        case ToastPosition.topRight:
          host
            ..style.top = '16px'
            ..style.right = '16px';
          break;
        case ToastPosition.topLeft:
          host
            ..style.top = '16px'
            ..style.left = '16px';
          break;
        case ToastPosition.bottomRight:
          host
            ..style.bottom = '16px'
            ..style.right = '16px';
          break;
        case ToastPosition.bottomLeft:
          host
            ..style.bottom = '16px'
            ..style.left = '16px';
          break;
        case ToastPosition.topCenter:
          host
            ..style.top = '16px'
            ..style.left = '50%'
            ..style.transform = 'translateX(-50%)';
          break;
        case ToastPosition.bottomCenter:
          host
            ..style.bottom = '16px'
            ..style.left = '50%'
            ..style.transform = 'translateX(-50%)';
          break;
      }
      final stack =
          DivElement()
            ..style.display = 'flex'
            ..style.flexDirection = 'column'
            ..style.gap = '10px';
      host.append(stack);
      document.body!.append(host);
      _stacks[p] = stack;
    }
    // élément racine minimal pour garder l'instance vivante
    return DivElement();
  }

  ToastRef _show(ToastOptions o) {
    if (getElement.parent == null) {
      document.body!.append(create());
    }
    final stack = _stacks[o.position]!;
    final item = _ToastItem(o);
    final el = item.create();
    stack.append(el);
    // anim entrée
    el.style.transition =
        'transform 220ms cubic-bezier(.2,.7,.2,1), opacity 220ms linear';
    el.style.transform = 'translateY(8px)';
    el.style.opacity = '0';
    window.requestAnimationFrame((_) {
      el.style.transform = 'translateY(0)';
      el.style.opacity = '1';
    });
    return ToastRef(item.close);
  }

  @override
  Element get getElement => document.getElementById(id!) ?? DivElement();
}

class ToastRef {
  final void Function() _close;
  ToastRef(this._close);
  void close() => _close();
}

// ---------------------- Item -------------------------------
class _ToastItem extends Relement {
  final ToastOptions opts;
  _ToastItem(this.opts, {super.id});

  // Eléments DOM pour maj rapides
  late DivElement _root; // container externe
  late DivElement _cardEl; // carte (Container)
  DivElement? _progressFill; // barre de progression
  Timer? _timer;
  int _remaining = 0;
  int _startedAt = 0;
  bool _paused = false;

  // Couleurs par type (accent)
  String get _accent =>
      opts.accentColor ??
      (() {
        switch (opts.type) {
          case ToastType.info:
            return '#38bdf8';
          case ToastType.success:
            return '#22c55e';
          case ToastType.warning:
            return '#f59e0b';
          case ToastType.error:
            return '#ef4444';
        }
      })();

  BoxDecoration get _defaultDecoration => BoxDecoration(
    color: MaterialColor.fromHex('#0f172aF2'),
    borderRadius: BorderRadius.all(Radius.circular(14)),
    border: Border(all: BorderSide(color: MaterialColor(255,255,255,.08))),
  );

  @override
  Element create() {
    _root = DivElement()..style.pointerEvents = 'auto';

    // Icône
    final icon = opts.icon ?? _defaultIconForType();
    final iconWrap =
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: MaterialColor.fromHex(_accent).withAlpha(0.12),
            border: Border(
              all: BorderSide(
                color: MaterialColor.fromHex(_accent).withAlpha(0.12),
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
          alignment: Alignment.center,
          child: icon,
        ).create();

    // Titre + message
    final titleEl = opts.title;
    final messageEl = opts.message;

    final textCol =
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          gap: 4,
          children: [if (titleEl != null) titleEl, messageEl],
        ).create();

    // Actions
    final actionsRow =
        DivElement()
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.gap = '10px'
          ..style.marginLeft = 'auto';
    if (opts.actionLabel != null) {
      final btn =
          TextButton(
            label: opts.actionLabel!,
            onPressed: () {
              opts.onAction?.call();
              close();
            },
          ).create();
      actionsRow.append(btn);
    }
    if (opts.showCloseButton) {
      final x =
          ButtonElement()
            ..text = '×'
            ..style.background = 'transparent'
            ..style.border = 'none'
            ..style.color = '#8aa0b9'
            ..style.cursor = 'pointer'
            ..style.fontSize = '18px';
      x.onClick.listen((_) => close());
      actionsRow.append(x);
    }

    // Ligne principale
    final row = Row(
      gap: 12,
      children: [_asRel(iconWrap), _asRel(textCol), _asRel(actionsRow)],
    );

    // Carte (decorable)
    final card =
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: opts.decoration ?? _defaultDecoration,
          child: row,
        ).create();
    _cardEl = card as DivElement;

    // Progress bar
    if (opts.showProgress && opts.durationMs > 0) {
      final bar =
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: MaterialColor(255, 255, 255, .12),
              borderRadius: BorderRadius.all(Radius.circular(999)),
            ),
            child: RelementSlot((div) {
              _progressFill = div;
              _progressFill!
                ..style.height = '100%'
                ..style.width = '100%'
                ..style.background = _accent
                ..style.borderRadius = '999px';
            }),
          ).create();
      _cardEl.append(bar);
      _cardEl.style.display = 'flex';
      _cardEl.style.flexDirection = 'column';
      _cardEl.style.gap = '10px';
    }

    // Interactions
    if (opts.closeOnClick) {
      _cardEl.onClick.listen((_) => close());
    }
    _cardEl.onMouseEnter.listen((_) => _pauseTimer());
    _cardEl.onMouseLeave.listen((_) => _resumeTimer());

    // Auto-dismiss
    if (opts.durationMs > 0) {
      _startTimer(opts.durationMs);
    }

    _root.append(_cardEl);
    return _root;
  }

  // Utilitaire pour insérer un Element externe dans un Relement child tree
  Relement _asRel(Element el) => _HtmlSlot(el);
  Element _wrap(Element el, {bool bold = false}) {
    if (bold) {
      el.style.fontWeight = '800';
    }
    return el;
  }

  BsIcon _defaultIconForType() {
    switch (opts.type) {
      case ToastType.info:
        return BsIcon(icon: Bicon.infoCircle);
      case ToastType.success:
        return BsIcon(icon: Bicon.checkCircle);
      case ToastType.warning:
        return BsIcon(icon: Bicon.exclamationTriangle);
      case ToastType.error:
        return BsIcon(icon: Bicon.xCircle);
    }
  }

  // String _hexWithAlpha(String hex, double alpha) {
  //   // accepte #rrggbb ou #rgb, ajoute alpha via rgba()
  //   try {
  //     final h = hex.replaceAll('#', '');
  //     int r, g, b;
  //     if (h.length == 3) {
  //       r = int.parse(h[0] + h[0], radix: 16);
  //       g = int.parse(h[1] + h[1], 16);
  //       b = int.parse(h[2] + h[2], 16);
  //     } else {
  //       r = int.parse(h.substring(0, 2), 16);
  //       g = int.parse(h.substring(2, 4), 16);
  //       b = int.parse(h.substring(4, 6), 16);
  //     }
  //     return 'rgba($r,$g,$b,${alpha.toStringAsFixed(2)})';
  //   } catch (_) {
  //     return hex;
  //   }
  // }

  void _startTimer(int ms) {
    _remaining = ms;
    _startedAt = DateTime.now().millisecondsSinceEpoch;
    _paused = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (t) {
      if (_paused) return;
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsed = now - _startedAt;
      final left = (_remaining - elapsed).clamp(0, _remaining);
      if (_progressFill != null) {
        final pct = _remaining == 0 ? 0 : (left / _remaining);
        _progressFill!.style.width = '${(pct * 100).toStringAsFixed(3)}%';
      }
      if (left <= 0) {
        t.cancel();
        close();
      }
    });
  }

  void _pauseTimer() {
    if (_timer == null) return;
    if (_paused) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - _startedAt;
    _remaining = (_remaining - elapsed).clamp(0, _remaining);
    _paused = true;
  }

  void _resumeTimer() {
    if (_timer == null) return;
    if (!_paused) return;
    _startedAt = DateTime.now().millisecondsSinceEpoch;
    _paused = false;
  }

  void close() {
    _timer?.cancel();
    _root.style.transition =
        'transform 220ms cubic-bezier(.2,.7,.2,1), opacity 160ms linear';
    _root.style.transform = 'translateY(-6px)';
    _root.style.opacity = '0';
    _root.onTransitionEnd.first.then((_) => _root.remove());
  }

  @override
  Element get getElement => _root;
}

// Petit helper pour insérer un Element arbitraire dans l'arbre Relement
class RelementSlot extends Relement {
  final void Function(DivElement mount) builder;
  RelementSlot(this.builder,{super.id});
  late DivElement _el;
  @override
  Element create() {
    _el = DivElement();
    builder(_el);
    return _el;
  }

  @override
  Element get getElement => _el;
}

class _HtmlSlot extends Relement {
  final Element el;
  _HtmlSlot(this.el,{super.id});
  @override
  Element create() => el;
  @override
  Element get getElement => el;
}
