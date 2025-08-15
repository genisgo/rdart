part of 'widgets.dart';

/// Entête de drawer avec titre + bouton fermer
class DrawerHeader extends Relement {
  final String title;
  final VoidCallback? onClose;
  List<Bootstrap> bootstrap; // ex: ['p-3','border-bottom','bg-light']

  DrawerHeader({
    required this.title,
    this.onClose,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    if (bootstrap.isEmpty) {
      bootstrap = [
        Bpadding.p3,
        Bborder.border.bottom,
        Bdisplay.flex,
        BAlignItem.center,
        BGap.gap2,
        Bcolor.bgWhite,
      ];
    }
    _root
      ..id = id ?? 'drawer-header-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(bootstrap.map((e) => e.cname));

    final titleEl =
        DivElement()
          ..style.flex = '1 1 auto'
          ..style.fontWeight = '600'
          ..text = title;

    final closeBtn =
        ButtonElement()
          ..classes.addAll(['btn', 'btn-sm', 'btn-outline-secondary'])
          ..title = 'Fermer'
          ..innerHtml = '<span aria-hidden="true">×</span>';
    closeBtn.onClick.listen((_) => onClose?.call());

    _root.children.addAll([titleEl, closeBtn]);
    return _root;
  }

  @override
  Element get getElement => _root;
}

/// Lien/élément cliquable du drawer (style ListTile)
class DrawerListTile extends Relement {
  final String label;
  final BsIcon? icon; // facultatif: '<i class="bi bi-house"></i>'
  final VoidCallback? onTap;
  final bool selected;
  final List<Bootstrap>
  bootstrap; // ex: ['list-group-item','list-group-item-action']

  DrawerListTile({
    required this.label,
    this.icon,
    this.onTap,
    this.selected = false,
    this.bootstrap = const [],
    super.id,
  });

  final AnchorElement _a = AnchorElement(href: '#');

  @override
  Element create() {
    _a
      ..id = id ?? 'drawer-item-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll([
        'list-group-item',
        'list-group-item-action',
        'py-2',
        ...bootstrap.map((e) => e.cname),
      ])
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.gap = '8px';

    if (selected) {
      _a.classes.add('active');
    }

    if (icon != null) {
      var iconText = icon!.create().outerHtml!;
      final iconspan =
          SpanElement()
            ..setInnerHtml(iconText, treeSanitizer: NodeTreeSanitizer.trusted);
      _a.children.add(iconspan);
    }
    _a.appendText(label);

    _a.onClick.listen((ev) {
      ev.preventDefault();
      onTap?.call();
    });

    return _a;
  }

  @override
  Element get getElement => _a;
}

/// ------------------------------------------------------------
/// IMPLÉMENTATIONS PAR DÉFAUT
/// ------------------------------------------------------------

/// Drawer gauche par défaut.
/// NOTE: le conteneur externe (positionné/animé) est créé par Scafoled.
/// Ici, on construit seulement l’intérieur, en prenant 100% hauteur.
class DefaultDrawer extends RDrawer {
  @override
  VoidCallback? onRequestClose;

  /// En-tête (si null, un header minimal peut être généré via [title])
  final DrawerHeader? header;

  /// Titre utilisé si [header] == null
  final String? title;

  /// Corps: liste d’éléments (ex: [DrawerListTile, ...])
  final List<Relement> children;

  /// Pied facultatif (boutons, infos…)
  final Relement? footer;

  /// Classes de layout
  final List<Bootstrap> bootstrap; // ex: ['d-flex','flex-column','h-100']

  /// Si true, le corps scrolle indépendamment
  final bool scrollableBody;

  DefaultDrawer({
    this.header,
    this.title,
    this.children = const [],
    this.footer,
    this.onRequestClose,
    this.bootstrap = const [],
    this.scrollableBody = true,
    super.id,
  });

  final DivElement _root = DivElement();
  final DivElement _bodyHost = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'drawer-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll([
        ...['d-flex', 'flex-column', 'h-100', 'bg-white'],
        ...bootstrap.map((e) => e.cname),
      ]);

    // Header
    if (header != null) {
      // Injecte onClose si manquant
      final h = header!;
      if (h.onClose == null && onRequestClose != null) {
        // On clone un header avec onClose (si tu préfères, passe onClose à la construction)
        final hdr = DrawerHeader(
          title: h.title,
          onClose: onRequestClose,
          bootstrap: h.bootstrap,
        );
        _root.children.add(hdr.create());
      } else {
        _root.children.add(h.create());
      }
    } else if (title != null) {
      _root.children.add(
        DrawerHeader(title: title!, onClose: onRequestClose).create(),
      );
    }

    // Body
    _bodyHost
      ..classes.addAll(['flex-grow-1'])
      ..style.position = 'relative';
    if (scrollableBody) {
      _bodyHost.style
        ..overflowY = 'auto'
        ..overflowX = 'hidden';
    }
    for (final c in children) {
      _bodyHost.children.add(c.create());
    }
    _root.children.add(_bodyHost);

    // Footer
    if (footer != null) {
      final f =
          DivElement()
            ..classes.addAll(['border-top'])
            ..children.add(footer!.create());
      _root.children.add(f);
    }

    return _root;
  }

  @override
  Element get getElement => _root;
}

/// EndDrawer (droite) par défaut.
/// Identique au Drawer gauche, séparé pour personnaliser au besoin.
class DefaultEndDrawer extends REndDrawer {
  @override
  VoidCallback? onRequestClose;

  final DrawerHeader? header;
  final String? title;
  final List<Relement> children;
  final Relement? footer;
  final List<Bootstrap> bootstrap;
  final bool scrollableBody;

  DefaultEndDrawer({
    this.header,
    this.title,
    this.children = const [],
    this.footer,
    this.onRequestClose,
    this.bootstrap = const [Bcolor.bgWhite],
    this.scrollableBody = true,
    super.id,
  });

  final DivElement _root = DivElement();
  final DivElement _bodyHost = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'enddrawer-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll([
        ...['d-flex', 'flex-column', 'h-100'],
        ...bootstrap.map((e) => e.cname),
      ]);

    if (header != null) {
      final h = header!;
      if (h.onClose == null && onRequestClose != null) {
        final hdr = DrawerHeader(
          title: h.title,
          onClose: onRequestClose,
          bootstrap: h.bootstrap,
        );
        _root.children.add(hdr.create());
      } else {
        _root.children.add(h.create());
      }
    } else if (title != null) {
      _root.children.add(
        DrawerHeader(title: title!, onClose: onRequestClose).create(),
      );
    }

    _bodyHost
      ..classes.addAll(['flex-grow-1'])
      ..style.position = 'relative';
    if (scrollableBody) {
      _bodyHost.style
        ..overflowY = 'auto'
        ..overflowX = 'hidden';
    }
    for (final c in children) {
      _bodyHost.children.add(c.create());
    }
    _root.children.add(_bodyHost);

    if (footer != null) {
      final f =
          DivElement()
            ..classes.addAll(['border-top'])
            ..children.add(footer!.create());
      _root.children.add(f);
    }

    return _root;
  }

  @override
  Element get getElement => _root;
}
