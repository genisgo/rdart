part of 'widgets.dart';

class RListTile extends Relement {
  final Relement? leading;
  final String? title;
  final Relement? titleWidget;
  final String? subtitle;
  final Relement? subtitleWidget;
  final Relement? trailing;

  final bool dense;
  final bool selected;
  final VoidCallback? onTap;
  final List<Bootstrap> bootstrap;

  RListTile({
    this.leading,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.trailing,
    this.dense = false,
    this.selected = false,
    this.onTap,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _ensureTileCss();

    _root
      ..id = id ?? 'tile-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll([
        'rd-list-tile',
        'list-group-item',
        'list-group-item-action',
        ...bootstrap.map((e) => e.cname).toList(),
      ]);

    if (selected) _root.classes.add('active');

    // Layout de base
    _root.style
      ..display = 'grid'
      ..gridTemplateColumns = 'auto 1fr auto'
      ..columnGap = '12px'
      ..rowGap = dense ? '2px' : '4px'
      ..alignItems = dense ? 'center' : 'start'
      ..padding = dense ? '8px 12px' : '12px 16px'
      ..cursor = onTap != null ? 'pointer' : 'default';

    // leading
    if (leading != null) {
      final host = DivElement()..classes.add('rd-tile-leading');
      host.children.add(leading!.create());
      _root.children.add(host);
    } else {
      _root.children.add(DivElement()); // placeholder grid
    }

    // center (title/subtitle)
    final center = DivElement()..classes.add('rd-tile-center');
    if (titleWidget != null) {
      center.children.add(titleWidget!.create());
    } else if (title != null) {
      center.children.add(
        Text(title!, fontWeight: FontWeightCss.w600).create(),
      );
    }
    if (subtitleWidget != null) {
      center.children.add(subtitleWidget!.create());
    } else if (subtitle != null) {
      center.children.add(
        Text(subtitle!, color:Color( '#6c757d'), fontSize: 13).create(),
      );
    }
    _root.children.add(center);

    // trailing
    if (trailing != null) {
      final host =
          DivElement()
            ..classes.add('rd-tile-trailing')
            ..style.justifySelf = 'end'
            ..style.alignSelf = 'center';
      host.children.add(trailing!.create());
      _root.children.add(host);
    } else {
      _root.children.add(DivElement());
    }

    if (onTap != null) {
      _root.onClick.listen((_) => onTap!.call());
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  static bool _cssInjected = false;
  static void _ensureTileCss() {
    if (_cssInjected) return;
    _cssInjected = true;
    final style =
        StyleElement()
          ..id = 'rdart-listtile-styles'
          ..text = '''
.rd-list-tile:hover{ background: rgba(0,0,0,.03); }
''';
    document.head?.append(style);
  }
}
