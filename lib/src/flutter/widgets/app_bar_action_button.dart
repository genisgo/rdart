part of 'widgets.dart';

/// Un bouton d’action d’appbar par défaut (texte ou icône).
class AppBarActionButton extends Relement {
  final Relement label;
  final String? title; // tooltip
  final VoidCallback? onPressed;
  final List<Bootstrap> bootstrap; // ex: ['btn','btn-sm','btn-link']

  AppBarActionButton({
    required this.label,
    this.title,
    this.onPressed,
    this.bootstrap = const [Btn.btn, Btn.sm],
    super.id,
  });

  late final ButtonElement _btn = ButtonElement();

  @override
  Element create() {
    _btn
      ..id = id ?? 'appbar-action-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(bootstrap.map((e) => e.cname))
      // ..text = label
      ..children.add(label.create())
      ..title = title
      ..onClick.listen((_) => onPressed?.call());

    return _btn;
  }

  @override
  Element get getElement => _btn;
}
