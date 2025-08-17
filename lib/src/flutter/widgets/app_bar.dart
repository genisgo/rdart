part of 'widgets.dart';
class AppBar extends AppBarI {
  final String title;
  final Relement? leading;
  final List<Relement> actions;
  final List<Bootstrap> bootstrap; // ex: ['navbar','navbar-light','bg-light']
  final String? backgroundColor; // override CSS rapide
  final bool elevated;

  AppBar({
    required this.title,
    this.leading,
    this.actions = const [],
    this.bootstrap = const [Bcolor.bgWhite] ,
    this.backgroundColor, 
    this.elevated = true,
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root.id = id ?? 'appbar-${DateTime.now().microsecondsSinceEpoch}';
    _root.classes.addAll([
      ...['navbar', 'navbar-expand',
      if(elevated) bshadow.cname
      ],
      ...bootstrap.map((e) => e.cname,)
    ]);
    _root.style
      ..display = 'flex'
      ..alignItems = 'center'
      ..gap = '8px'
      ..padding = '8px 12px';
    if (backgroundColor != null) _root.style.backgroundColor = backgroundColor!;
    // if (!elevated) _root.style.boxShadow = 'none';

    // leading
    if (leading != null) {
      final host = DivElement()..classes.add('rd-appbar-leading');
      host.children.add(leading!.create());
      _root.children.add(host);
    }

    // title (prend l'espace)
    final titleEl = DivElement()
      ..classes.add('rd-appbar-title')
      ..style.flex = '1 1 auto'
      ..style.fontWeight = '600'
      ..style.fontSize = '1.05rem'
      ..text = title;
    _root.children.add(titleEl);

    // actions
    if (actions.isNotEmpty) {
      final row = DivElement()
        ..classes.add('rd-appbar-actions')
        ..style.display = 'flex'
        ..style.gap = '6px';
      for (final a in actions) {
        row.children.add(a.create());
      }
      _root.children.add(row);
    }

    return _root;
  }

  @override
  Element get getElement => _root;
}
