part of 'bs.components.dart';

/// Container "list-group" façon Bootstrap, pour rdart.
/// - Par défaut, rend un <div class="list-group">.
/// - Si numbered=true, rend un <ol class="list-group list-group-numbered">.
/// - Si horizontal != null, ajoute list-group-horizontal[-{breakpoint}]
///   (ex: '', 'sm', 'md', 'lg', 'xl', 'xxl').
/// - Si itemizeChildren=true, les enfants sans classe 'list-group-item'
///   sont enveloppés automatiquement dans un <div class="list-group-item">.
///
/// Exemple simple:
///   RelementListGroup(
///     children: [
///       DrawerListTile(label: 'Accueil'), // a déjà 'list-group-item' => OK
///       MyPlainRelement(...),             // sera enveloppé si itemizeChildren=true
///     ],
///     flush: true,
///   )
class RelementListGroup extends Relement {
  final List<Relement> children;

  /// Ajoute la classe 'list-group-flush'
  final bool flush;

  /// null = vertical (défaut)
  /// ''   = horizontal tout le temps => 'list-group-horizontal'
  /// 'sm' | 'md' | 'lg' | 'xl' | 'xxl' => 'list-group-horizontal-sm' etc.
  final String? horizontal;

  /// Rend un <ol> + 'list-group-numbered'
  final bool numbered;

  /// Ajoute des classes au conteneur (en plus de 'list-group')
  final List<String> bootstrap;

  /// Si true, on enveloppe les enfants qui n'ont pas 'list-group-item'
  /// dans un <div class="list-group-item"> (pratique pour du contenu brut).
  final bool itemizeChildren;

  /// Si défini, force la balise racine: 'div' | 'ul' | 'ol'
  /// (NOTE: si numbered=true et tag == null, on utilisera 'ol').
  final String? tag;

  /// Rôles/ARIA optionnels
  final String? role;
  final String? ariaLabel;

  RelementListGroup({
    required this.children,
    this.flush = false,
    this.horizontal,
    this.numbered = false,
    this.bootstrap = const [],
    this.itemizeChildren = false,
    this.tag,
    this.role,
    this.ariaLabel,
    super.id,
  });

  Element? _root;

  @override
  Element create() {
    // Choix de la balise
    final String resolvedTag = tag ?? (numbered ? 'ol' : 'div');
    _root = _createRootTag(resolvedTag);

    _root!.id = id ?? 'listgroup-${DateTime.now().microsecondsSinceEpoch}';
    _root!.classes.add('list-group');
    _root!.classes.addAll(bootstrap);
    if (flush) _root!.classes.add('list-group-flush');

    // Horizontal ?
    if (horizontal != null) {
      final bp = horizontal!;
      _root!.classes.add(bp.isEmpty ? 'list-group-horizontal' : 'list-group-horizontal-$bp');
    }

    // Numbered ?
    if (numbered) _root!.classes.add('list-group-numbered');

    // Rôles/ARIA
    if (role != null) _root!.setAttribute('role', role!);
    if (ariaLabel != null) _root!.setAttribute('aria-label', ariaLabel!);

    // Injecte les enfants
    for (final child in children) {
      final el = child.create();

      if (itemizeChildren && !_hasListGroupItemClass(el)) {
        // Enveloppe dans un conteneur list-group-item
        final wrapper = _wrapAsListGroupItem(el, numbered ? 'li' : null);
        _appendItem(wrapper);
      } else {
        // Si le conteneur est un <ul>/<ol> et que l'enfant n'est pas <li>,
        // on l’enveloppe quand même dans <li> pour rester sémantique.
        if ((_root is UListElement || _root is OListElement) && el is! LIElement) {
          final li = LIElement()..classes.add('list-group-item');
          li.children.add(el);
          _appendItem(li);
        } else {
          _appendItem(el);
        }
      }
    }

    return _root!;
  }

  @override
  Element get getElement => _root ?? create();

  // ----------------- API runtime facultative -----------------

  /// Ajoute un enfant après création. Si itemizeChildren=true,
  /// applique les mêmes règles d'enveloppe.
  void addChild(Relement child) {
    final el = child.create();
    if (_root == null) {
      // Pas encore créé: on pousse juste dans children,
      // create() le rendra plus tard.
      children.add(child);
      return;
    }

    if (itemizeChildren && !_hasListGroupItemClass(el)) {
      final wrapper = _wrapAsListGroupItem(el, numbered ? 'li' : null);
      _appendItem(wrapper);
    } else {
      if ((_root is UListElement || _root is OListElement) && el is! LIElement) {
        final li = LIElement()..classes.add('list-group-item');
        li.children.add(el);
        _appendItem(li);
      } else {
        _appendItem(el);
      }
    }
  }

  /// Bascule la classe 'active' sur l’élément d’index [i]
  /// (utile si tes items sont des `.list-group-item`).
  void setActiveIndex(int i) {
    if (_root == null) return;
    final items = _root!.children;
    for (var j = 0; j < items.length; j++) {
      items[j].classes.toggle('active', j == i);
    }
  }

  // ----------------------- Helpers ---------------------------

  Element _createRootTag(String tagName) {
    switch (tagName) {
      case 'ul':
        return UListElement();
      case 'ol':
        return OListElement();
      case 'div':
      default:
        return DivElement();
    }
  }

  bool _hasListGroupItemClass(Element el) =>
      el.classes.contains('list-group-item');

  Element _wrapAsListGroupItem(Element child, [String? liTag]) {
    if (liTag == 'li') {
      final li = LIElement()..classes.add('list-group-item');
      li.children.add(child);
      return li;
    }
    final div = DivElement()..classes.add('list-group-item');
    div.children.add(child);
    return div;
  }

  void _appendItem(Element el) {
    _root!.children.add(el);
  }
}
