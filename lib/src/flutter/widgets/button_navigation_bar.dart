part of 'widgets.dart';


/// ------------------- BOTTOM NAVIGATION BAR -------------------

class BottomNavItem {
  final String label;
  final String? iconHtml; // tu peux injecter un <i class="..."></i> si tu veux
  BottomNavItem({required this.label, this.iconHtml});
}

class DefaultBottomNavigationBar extends BottomNavigationBarI {
  final List<BottomNavItem> items;
  @override
  int currentIndex;
  final void Function(int index)? onTap;
  final List<String> bootstrap; // ex: ['nav','nav-pills','justify-content-around']

  DefaultBottomNavigationBar({
    required this.items,
    this.onTap,
    this.currentIndex = 0,
    this.bootstrap = const ['nav', 'nav-pills', 'justify-content-around', 'py-2'],
    super.id,
  }) : assert(items.isNotEmpty, 'BottomNavigationBar requires at least 1 item');

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root.id = id ?? 'bnav-${DateTime.now().microsecondsSinceEpoch}';
    _root.classes.addAll(bootstrap);
    _root.style
      ..display = 'flex'
      ..gap = '4px';

    _root.children.clear();
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      final a = AnchorElement(href: '#')
        ..classes.addAll([
          'nav-link',
          if (i == currentIndex) 'active',
        ])
        ..style.display = 'flex'
        ..style.flexDirection = 'column'
        ..style.alignItems = 'center'
        ..style.gap = '2px';

      if (it.iconHtml != null) {
        final icon = SpanElement()..setInnerHtml(it.iconHtml!, treeSanitizer: NodeTreeSanitizer.trusted);
        a.children.add(icon);
      }
      a.appendText(it.label);

      a.onClick.listen((ev) {
        ev.preventDefault();
        _setActive(i);
        onTap?.call(i);
      });

      _root.children.add(a);
    }
    return _root;
  }

  void _setActive(int i) {
    currentIndex = i;
    final links = _root.querySelectorAll('.nav-link');
    for (var j = 0; j < links.length; j++) {
      links[j].classes.toggle('active', j == i);
    }
  }

  @override
  Element get getElement => _root;
}


/// -------------------- FLOATING ACTION BUTTON -----------------

class DefaultFloatingActionButton extends FloatingActionButtonI {
  @override
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? iconHtml; // ex: '<i class="bi bi-plus"></i>'
  final String? label;    // si tu veux un mini-extended FAB
  final List<String> bootstrap; // ex: ['btn','btn-primary','rounded-circle']

  DefaultFloatingActionButton({
    this.onPressed,
    this.tooltip,
    this.iconHtml = '<span style="font-size:20px;line-height:1;">＋</span>',
    this.label,
    this.bootstrap = const ['btn', 'btn-primary', 'rounded-circle', 'shadow'],
    super.id,
  });

  final ButtonElement _btn = ButtonElement();

  @override
  Element create() {
    _btn
      ..id = id ?? 'fab-${DateTime.now().microsecondsSinceEpoch}'
      ..title = tooltip ?? ''
      ..classes.addAll(bootstrap)
      ..style.width = label == null ? '56px' : 'auto'
      ..style.height = '56px'
      ..style.display = 'inline-flex'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'center'
      ..style.gap = '8px'
      ..style.padding = label == null ? '0' : '0 16px'
      ..onClick.listen((_) => onPressed?.call());

    // contenu : icône + label optionnel (extended FAB)
    final icon = SpanElement();
    if (iconHtml != null) {
      icon.setInnerHtml(iconHtml!, treeSanitizer: NodeTreeSanitizer.trusted);
    }
    _btn.children.add(icon);

    if (label != null) {
      final txt = SpanElement()
        ..text = label!
        ..style.fontWeight = '600';
      _btn.children.add(txt);
    }

    return _btn;
  }

  @override
  Element get getElement => _btn;
}
