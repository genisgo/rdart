part of 'widgets.dart';

/// Scaffold "Flutter-like" pour rdart.
/// Nom conservé tel que fourni : Scafoled.
/// - appBar : barre supérieure collante
/// - body   : contenu principal (prend toute la hauteur restante)
/// - drawer / endDrawer : panneaux latéraux (gauche/droite) avec scrim
/// - bottomNavigationBar : barre inférieure collante
/// - floatingActionButton : bouton flottant en bas à droite
///
/// Méthodes utiles : openDrawer(), closeDrawer(), openEndDrawer(), closeEndDrawer(), toggleDrawer(), toggleEndDrawer()
class Scaffold extends Relement {
  final AppBarI? appBar;
  final Relement? body;
  final RDrawer? drawer;
  final REndDrawer? endDrawer;
  final BottomNavigationBarI? bottomNavigationBar;
  final FloatingActionButtonI? floatingActionButton;
  final DrawerController? drawerController;

  /// Classes Bootstrap (ou autres) à appliquer sur le conteneur racine
  final List<String> bootstrap;

  /// Couleur de fond (CSS)
  final String? backgroundColor;

  /// Si true, clic sur le scrim (fond assombri) ferme le drawer
  final bool scrimDismissible;

  Scaffold({
    this.appBar,
    this.body,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.bootstrap = const [],
    this.backgroundColor,
    this.drawerController,
    this.scrimDismissible = true,
    super.id,
  });

  // ---------- Elements internes ----------
  final DivElement _root = DivElement();
  final DivElement _appBarHost = DivElement();
  final DivElement _bodyHost = DivElement();
  final DivElement _bottomHost = DivElement();
  final DivElement _fabHost = DivElement();
  final DivElement _leftDrawerHost = DivElement();
  final DivElement _rightDrawerHost = DivElement();
  final DivElement _scrim = DivElement();

  static bool _stylesInjected = false;

  @override
  Element create() {
    _ensureStyles();

    // Racine
    _root.id = id ?? 'scaffold-${DateTime.now().microsecondsSinceEpoch}';
    _root.classes.addAll(['rd-scaffold', ...bootstrap]);
    _root.style
      ..display = 'flex'
      ..flexDirection = 'column'
      ..minHeight = '100vh'
      ..position = 'relative';
    if (backgroundColor != null) {
      _root.style.backgroundColor = backgroundColor!;
    }

    // AppBar
    if (appBar != null) {
      _appBarHost.classes.add('rd-appbar');
      _appBarHost.style
        ..position = 'sticky'
        ..top = '0'
        ..zIndex = '1002'
        ..backgroundColor = 'var(--rd-appbar-bg, #ffffff)'
        ..borderBottom = '1px solid rgba(0,0,0,.08)';
      _appBarHost.children.add(appBar!.create());
      _root.children.add(_appBarHost);
    }

    // Body (flex:1)
    _bodyHost.classes.add('rd-body');
    _bodyHost.style
      ..flex = '1 1 auto'
      ..display = "flex"
      ..position = 'relative';
    //specification pour le widget center
    if (body != null) _bodyHost.children.add(body!.create());
    
    _root.children.add(_bodyHost);

    // Bottom bar
    if (bottomNavigationBar != null) {
      _bottomHost.classes.add('rd-bottombar');
      _bottomHost.style
        ..position = 'sticky'
        ..bottom = '0'
        ..zIndex = '1001'
        ..backgroundColor = 'var(--rd-bottom-bg, #ffffff)'
        ..borderTop = '1px solid rgba(0,0,0,.08)';
      _bottomHost.children.add(bottomNavigationBar!.create());
      _root.children.add(_bottomHost);
    }

    // FAB (fixe)
    if (floatingActionButton != null) {
      _fabHost.classes.add('rd-fab');
      _fabHost.style
        ..position = 'fixed'
        ..right = '16px'
        ..bottom = '16px'
        ..zIndex = '1003';
      _fabHost.children.add(floatingActionButton!.create());
      _root.children.add(_fabHost);
    }

    // Drawers + scrim (fixes)
    if (drawer != null) {
      _leftDrawerHost.classes.addAll(['rd-drawer', 'left']);
      _leftDrawerHost.children.add(drawer!.create());
      _root.children.add(_leftDrawerHost);
    }
    if (endDrawer != null) {
      _rightDrawerHost.classes.addAll(['rd-drawer', 'right']);
      _rightDrawerHost.children.add(endDrawer!.create());
      _root.children.add(_rightDrawerHost);
    }

    if (drawer != null || endDrawer != null) {
      _scrim.classes.add('rd-scrim');
      _scrim.style
        ..position = 'fixed'
        ..left = '0'
        ..top = '0'
        ..right = '0'
        ..bottom = '0'
        ..backgroundColor = 'rgba(0,0,0,.35)'
        ..opacity = '0'
        ..transition = 'opacity .2s ease'
        ..pointerEvents = 'none'
        ..zIndex = '1000';
      _root.children.add(_scrim);

      if (scrimDismissible) {
        _scrim.onClick.listen((_) {
          closeDrawer();
          closeEndDrawer();
        });
      }
    }

    //set DrawerController
    drawerController?.scafoled = this;
    return _root;
  }

  @override
  Element get getElement => _root;

  // ---------- API publique : contrôle des drawers ----------
  void openDrawer() {
    if (_leftDrawerHost.classes.contains('left')) {
      _leftDrawerHost.classes.add('open');
      _showScrim();
    }
  }

  void closeDrawer() {
    _leftDrawerHost.classes.remove('open');
    _maybeHideScrim();
  }

  void toggleDrawer() {
    if (_leftDrawerHost.classes.contains('open')) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }

  void openEndDrawer() {
    if (_rightDrawerHost.classes.contains('right')) {
      _rightDrawerHost.classes.add('open');
      _showScrim();
    }
  }

  void closeEndDrawer() {
    _rightDrawerHost.classes.remove('open');
    _maybeHideScrim();
  }

  void toggleEndDrawer() {
    if (_rightDrawerHost.classes.contains('open')) {
      closeEndDrawer();
    } else {
      openEndDrawer();
    }
  }

  // ---------- Helpers ----------
  void _showScrim() {
    if (_scrim.parent == null) return;
    _scrim.style
      ..opacity = '1'
      ..pointerEvents = 'auto';
  }

  void _maybeHideScrim() {
    final anyOpen =
        _leftDrawerHost.classes.contains('open') ||
        _rightDrawerHost.classes.contains('open');
    if (!anyOpen) {
      _scrim.style
        ..opacity = '0'
        ..pointerEvents = 'none';
    }
  }

  static void _ensureStyles() {
    if (_stylesInjected) return;
    _stylesInjected = true;

    final style =
        StyleElement()
          ..id = 'rdart-scaffold-styles'
          ..text = '''
/* ----- rdart Scaffold ----- */
.rd-drawer {
  position: fixed;
  top: 0;
  bottom: 0;
  width: 320px;
  max-width: 86vw;
  background: var(--rd-drawer-bg, #ffffff);
  box-shadow: 0 6px 24px rgba(0,0,0,.18);
  transition: transform .25s ease;
  z-index: 1002;
  overflow: auto;
}
.rd-drawer.left { left: 0; transform: translateX(-110%); }
.rd-drawer.right { right: 0; transform: translateX(110%); }
.rd-drawer.left.open { transform: translateX(0); }
.rd-drawer.right.open { transform: translateX(0); }

/* Petites améliorations visuelles optionnelles */
.rd-appbar, .rd-bottombar { backdrop-filter: saturate(1.2) blur(2px); }
.rd-fab > * { pointer-events: auto; }

/* Body remplit bien l'espace */
.rd-scaffold { contain: layout paint style; }
''';
    document.head?.append(style);
  }

  // ---------- Mises à jour dynamiques (optionnel) ----------
  /// Remplace le body à chaud (pratique si vous n'utilisez pas BLoC/setState global)
  void setBody(Relement newBody) {
    _bodyHost.children
      ..clear()
      ..add(newBody.create());
  }

  /// Remplace l'appBar à chaud
  void setAppBar(Relement newAppBar) {
    if (_appBarHost.parent == null) {
      _root.children.insert(0, _appBarHost);
    }
    _appBarHost.children
      ..clear()
      ..add(newAppBar.create());
  }

  /// Remplace la bottom bar à chaud
  void setBottomBar(Relement newBottom) {
    if (_bottomHost.parent == null) _root.children.add(_bottomHost);
    _bottomHost.children
      ..clear()
      ..add(newBottom.create());
  }
}

class DrawerController {
  Scaffold? _scafoled;

  set scafoled(Scaffold scafoled) {
    _scafoled = scafoled;
  }

  void openDrawer() {
    _scafoled?.openDrawer();
  }

  void openEndDrawer() {
    _scafoled?.openEndDrawer();
  }

  void closeDrawer() {
    _scafoled?.closeDrawer();
  }

  void closeEndDrawer() {
    _scafoled?.closeEndDrawer();
  }

  void toggleDrawer() {
    _scafoled?.toggleDrawer();
  }
}
