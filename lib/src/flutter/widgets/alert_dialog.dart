part  of 'widgets.dart';

/// ============================================================================
/// Base (supprime si déjà présent dans ton projet)
/// ============================================================================

// ============================================================================
// AlertController<T> – pilote l'ouverture/fermeture et le résultat
// ============================================================================
class AlertController<T> {
  final _completer = Completer<T?>();
  bool _closed = false;
  DivElement? _overlay;

  Future<T?> get future => _completer.future;

  void _bindOverlay(DivElement overlay) {
    _overlay = overlay;
  }

  void close([T? result]) {
    if (_closed) return;
    _closed = true;
    // petite animation de sortie
    if (_overlay != null) {
      _overlay!.classes.remove('open');
      // retire du DOM après la transition
      Future.delayed(Duration(milliseconds: 150), () {
        _overlay?.remove();
      });
    }
    if (!_completer.isCompleted) _completer.complete(result);
  }
}

// ============================================================================
// Alignement des actions
// ============================================================================
enum ActionsAlignment { start, center, end, spaceBetween }

// ============================================================================
// AlertDialog<T> – composant Flutter-like
// ============================================================================
class AlertDialog<T> extends Relement {
  // Contenu
  final String? title;
  final Relement? titleWidget; // si tu veux un widget au lieu d'une String
  final Relement? content;

  // Actions (liste statique ou via builder pour accéder au controller)
  final List<Relement>? actions;
  final List<Relement> Function(AlertController<T> ctrl)? actionsBuilder;
  final ActionsAlignment actionsAlignment;

  // Style
  final double maxWidth;
  final double? maxHeight; // si null → calcule via CSS (70vh)
  final EdgeInsets? insetPadding;
  final EdgeInsets? titlePadding;
  final EdgeInsets? contentPadding;
  final EdgeInsets? actionsPadding;
  final double borderRadius;
  final String backgroundColor;
  final int elevation; // contrôle l'intensité d'ombre

  // Barrier & comportement
  final bool barrierDismissible;
  final String barrierColor;
  final String? semanticLabel; // aria-label
  final VoidCallback? onDismissed;

  // Animation
  final int transitionDurationMs;

  AlertController<T>? _controller; // injecté par showDialog

  AlertDialog({
    this.title,
    this.titleWidget,
    this.content,
    this.actions,
    this.actionsBuilder,
    this.actionsAlignment = ActionsAlignment.end,
    this.maxWidth = 560,
    this.maxHeight,
    this.insetPadding,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.borderRadius = 14,
    this.backgroundColor = '#ffffff',
    this.elevation = 24,
    this.barrierDismissible = true,
    this.barrierColor = 'rgba(0,0,0,.45)',
    this.semanticLabel,
    this.onDismissed,
    this.transitionDurationMs = 140,
    super.id,
  });

  // Nodes
  final DivElement _overlay = DivElement();
  final DivElement _dialog = DivElement();
  final DivElement _container = DivElement();
  final DivElement _titleEl = DivElement();
  final DivElement _contentEl = DivElement();
  final DivElement _actionsEl = DivElement();

  @override
  Element create() {
    _ensureCssDialog();

    // Overlay
    _overlay
      ..id = id ?? 'alert-overlay-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-dialog-overlay')
      ..style.backgroundColor = barrierColor
      ..setAttribute('role', 'presentation');

    if (barrierDismissible) {
      _overlay.onClick.listen((e) {
        if (e.target == _overlay) {
          _controller?.close();
          onDismissed?.call();
        }
      });
    }

    // Dialog container (centrage)
    _dialog
      ..classes.add('rdx-dialog-wrapper')
      ..onClick.listen((e) {
        // stop la propagation pour éviter de fermer quand on clique dedans
        e.stopPropagation();
      });

    // Card
    _container.classes.add('rdx-dialog');
    _container.style
      ..backgroundColor = backgroundColor
      ..borderRadius = '${borderRadius}px'
      ..maxWidth = '${maxWidth}px'
      ..boxShadow = _shadowFor(elevation)
      ..margin =
          insetPadding?.toCss() ??
          EdgeInsets.symmetric(horizontal: 24, vertical: 24).toCss();

    if (maxHeight != null) {
      _container.style.maxHeight = '${maxHeight}px';
    } else {
      _container.style.maxHeight = '70vh';
    }

    if (semanticLabel != null) {
      _container.setAttribute('aria-label', semanticLabel!);
    }
    _container.setAttribute('role', 'dialog');
    _container.setAttribute('aria-modal', 'true');

    // Title
    _titleEl
      ..classes.add('rdx-dialog-title')
      ..style.padding = titlePadding?.toCss() ?? EdgeInsets.all(20).toCss();

    if (titleWidget != null) {
      _titleEl.children.add(titleWidget!.create());
    } else if (title != null && title!.isNotEmpty) {
      final h =
          HeadingElement.h2()
            ..text = title!
            ..classes.add('rdx-dialog-title-text');
      _titleEl.children.add(h);
    }

    // Content
    _contentEl
      ..classes.add('rdx-dialog-content')
      ..style.padding =
          contentPadding?.toCss() ??
          EdgeInsets.symmetric(horizontal: 20, vertical: 16).toCss();

    if (content != null) {
      _contentEl.children.add(content!.create());
    }

    // Actions
    _actionsEl.classes.add('rdx-dialog-actions');
    _actionsEl.style
      ..padding =
          actionsPadding?.toCss() ??
          EdgeInsets.symmetric(horizontal: 12, vertical: 12).toCss()
      ..justifyContent = _actionsAlignToCss(actionsAlignment);

    // actions statiques
    if (actions != null && actions!.isNotEmpty) {
      for (final a in actions!) {
        _actionsEl.children.add(a.create());
      }
    }

    // assemble
    if (_titleEl.children.isNotEmpty) {
      _container.children.add(_titleEl);
    }
    if (_contentEl.children.isNotEmpty) {
      _container.children.add(_contentEl);
    }
    _container.children.add(_actionsEl);

    _dialog.children.add(_container);
    _overlay.children.add(_dialog);

    return _overlay;
  }

  @override
  Element get getElement => _overlay;

  // Utilisée par showDialog pour fournir le controller et construire les actions dynamiques
  void _attachController(AlertController<T> ctrl) {
    _controller = ctrl;
    if (actionsBuilder != null) {
      _actionsEl.children.clear();
      final built = actionsBuilder!(ctrl);
      for (final a in built) {
        _actionsEl.children.add(a.create());
      }
    }
  }

  // Petits helpers
  static String _shadowFor(int elevation) {
    // mapping simple d'élévation → ombre CSS
    final e = elevation.clamp(0, 40);
    if (e <= 1) return '0 1px 2px rgba(0,0,0,.12), 0 1px 1px rgba(0,0,0,.06)';
    if (e <= 6) {
      return '0 10px 15px -3px rgba(0,0,0,.1), 0 4px 6px -4px rgba(0,0,0,.1)';
    }
    if (e <= 12) {
      return '0 20px 25px -5px rgba(0,0,0,.1), 0 10px 10px -5px rgba(0,0,0,.04)';
    }
    return '0 25px 50px -12px rgba(0,0,0,.25)';
  }

  static String _actionsAlignToCss(ActionsAlignment a) {
    switch (a) {
      case ActionsAlignment.start:
        return 'flex-start';
      case ActionsAlignment.center:
        return 'center';
      case ActionsAlignment.end:
        return 'flex-end';
      case ActionsAlignment.spaceBetween:
        return 'space-between';
    }
  }
}

// ============================================================================
// API – showDialog / helpers prêts à l'emploi
// ============================================================================
Future<T?> showDialog<T>({required AlertDialog<T> dialog}) {
  _ensureCssDialog();

  final ctrl = AlertController<T>();
  // build DOM
  final overlay = dialog.create() as DivElement;
  ctrl._bindOverlay(overlay);
  dialog._attachController(ctrl);

  // empilage (z-index)
  final existing = document.querySelectorAll('.rdx-dialog-overlay').length;
  overlay.style.zIndex = '${1000 + existing}';

  document.body?.append(overlay);

  // animation d'entrée
  window.requestAnimationFrame((_) {
    overlay.classes.add('open');
  });

  // ESC pour fermer si dismissible
 void  onKey(Event e) {
    if ((e as KeyboardEvent).key == 'Escape') {
      ctrl.close();
      window.removeEventListener('keydown', onKey);
    }
  }

  if (dialog.barrierDismissible) {
    window.addEventListener('keydown', onKey);
  }

  return ctrl.future;
}

Future<void> showAlert({
  String? title,
  Relement? titleWidget,
  Relement? content,
  String okLabel = 'OK',
  bool barrierDismissible = true,
}) {
  final dlg = AlertDialog<void>(
    title: title,
    titleWidget: titleWidget,
    content: content,
    barrierDismissible: barrierDismissible,
    actionsBuilder:
        (ctrl) => [
          _DialogTextButton(label: okLabel, onPressed: () => ctrl.close()),
        ],
  );
  return showDialog<void>(dialog: dlg);
}

Future<bool> showConfirm({
  String? title,
  Relement? titleWidget,
  Relement? content,
  String cancelLabel = 'Annuler',
  String okLabel = 'OK',
  bool barrierDismissible = true,
}) async {
  final dlg = AlertDialog<bool>(
    title: title,
    titleWidget: titleWidget,
    content: content,
    barrierDismissible: barrierDismissible,
    actionsAlignment: ActionsAlignment.end,
    actionsBuilder:
        (ctrl) => [
          _DialogTextButton(
            label: cancelLabel,
            onPressed: () => ctrl.close(false),
          ),
          _DialogPrimaryButton(
            label: okLabel,
            onPressed: () => ctrl.close(true),
          ),
        ],
  );
  final res = await showDialog<bool>(dialog: dlg);
  return res ?? false;
}

// ============================================================================
// Boutons de secours (si tu as déjà TextButton/ElevatedButton, remplace ces deux-là)
// ============================================================================
class _DialogTextButton extends Relement {
  final String label;
  final VoidCallback onPressed;
  _DialogTextButton({required this.label, required this.onPressed, super.id});

  @override
  Element create() {
    final b =
        ButtonElement()
          ..text = label
          ..classes.add('rdx-dialog-btn');
    b.onClick.listen((_) => onPressed());
    return b;
  }

  @override
  Element get getElement => create();
}

class _DialogPrimaryButton extends _DialogTextButton {
  _DialogPrimaryButton({required super.label, required super.onPressed});
  @override
  Element create() {
    final el = super.create();
    el.classes.add('primary');
    return el;
  }
}

// ============================================================================
// CSS (injecté 1x)
// ============================================================================
bool _cssInjectedDialog = false;
void _ensureCssDialog() {
  if (_cssInjectedDialog) return;
  _cssInjectedDialog = true;
  final style =
      StyleElement()
        ..id = 'rdx-dialog-styles'
        ..text = '''
.rdx-dialog-overlay{
  position: fixed; inset: 0; display:flex; align-items:center; justify-content:center;
  background: rgba(0,0,0,.45); opacity: 0; transition: opacity .14s ease;
}
.rdx-dialog-overlay.open{ opacity: 1; }

.rdx-dialog-wrapper{ width: 100%; height: 100%; display:flex; align-items:center; justify-content:center; padding: 12px; }

.rdx-dialog{
  width: 100%; max-width: 560px; max-height: 70vh; overflow: hidden; background:#fff; border-radius: 14px;
  transform: translateY(12px) scale(.98); transition: transform .14s ease, box-shadow .14s ease;
}
.rdx-dialog-overlay.open .rdx-dialog{ transform: none; }

.rdx-dialog-title{ padding: 20px; border-bottom: 1px solid rgba(0,0,0,.06); }
.rdx-dialog-title-text{ margin: 0; font-size: 18px; font-weight: 600; color: #111827; }

.rdx-dialog-content{ padding: 16px 20px; overflow: auto; max-height: calc(70vh - 120px); color:#0f172a; }

.rdx-dialog-actions{ display:flex; align-items:center; gap:8px; padding: 12px; border-top: 1px solid rgba(0,0,0,.06); }

.rdx-dialog-btn{
  padding: 8px 14px; border-radius: 10px; border: 1px solid rgba(0,0,0,.12); background: #fff; color:#111827;
  cursor: pointer; font-weight: 500;
}
.rdx-dialog-btn:hover{ background: #f8fafc; }
.rdx-dialog-btn.primary{ background: #0d6efd; color:#fff; border-color: #0d6efd; }
.rdx-dialog-btn.primary:hover{ filter: brightness(.95); }
''';
  document.head?.append(style);
}

// ============================================================================
// EXEMPLES D'UTILISATION (à titre indicatif)
// ============================================================================
class _SimpleText extends Relement {
  final String text;
  _SimpleText(this.text,{ super.id});
  @override
  Element create() => ParagraphElement()..text = text;
  @override
  Element get getElement => create();
}

void exampleAlert() {
  showAlert(
    title: 'Information',
    content: _SimpleText('Votre session va expirer dans 5 minutes.'),
  );
}

void exampleConfirm() async {
  final ok = await showConfirm(
    title: 'Supprimer',
    content: _SimpleText(
      'Confirmer la suppression ? Cette action est irréversible.',
    ),
    cancelLabel: 'Annuler',
    okLabel: 'Supprimer',
  );
  if (ok) {
    // ... action
  }
}

// Exemple complet avec actions personnalisées et builder
void exampleCustom() {
  final dlg = AlertDialog<int>(
    title: 'Choisir une option',
    content: _SimpleText('Sélectionne une des réponses ci-dessous.'),
    actionsAlignment: ActionsAlignment.spaceBetween,
    actionsBuilder:
        (ctrl) => [
          _DialogTextButton(label: '1', onPressed: () => ctrl.close(1)),
          _DialogTextButton(label: '2', onPressed: () => ctrl.close(2)),
          _DialogPrimaryButton(label: '3', onPressed: () => ctrl.close(3)),
        ],
  );
  showDialog<int>(dialog: dlg).then((value) {
    // value ∈ {1,2,3} ou null si fermé
  });
}
