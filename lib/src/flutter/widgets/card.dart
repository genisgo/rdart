part of 'widgets.dart';

class Card extends Relement {
  final Relement? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final List<String> bootstrap; // ex: ['shadow-sm']

  Card({this.child, this.padding, this.margin, this.bootstrap = const [], super.id});

  late final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'card-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-card', ...bootstrap]);
    _ensureCardStyles();
    _root.children.clear();

    if (child != null) {
      final body = DivElement()..classes.add('rd-card-body');
      if (padding != null) body.style.padding = padding!.toCss();
      body.children.add(child!.create());
      _root.children.add(body);
    }

    if (margin != null) _root.style.margin = margin!.toCss();
    return _root;
  }

  @override
  Element get getElement => _root;

  static bool _cssInjected = false;
  static void _ensureCardStyles() {
    if (_cssInjected) return;
    _cssInjected = true;
    final style = StyleElement()
      ..id = 'rdart-card-styles'
      ..text = '''
.rd-card{
  background:#fff; border:1px solid rgba(0,0,0,.06); border-radius:12px;
  box-shadow:0 8px 24px rgba(0,0,0,.06);
}
.rd-card-body{ padding:16px; }
''';
    document.head?.append(style);
  }
}