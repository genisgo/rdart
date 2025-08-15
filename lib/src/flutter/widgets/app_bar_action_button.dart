part of 'widgets.dart';

/// Un bouton d’action d’appbar par défaut (texte ou icône).
class AppBarActionButton extends Relement {
  final String label;
  final String? title; // tooltip
  final VoidCallback? onPressed;
  final List<String> bootstrap; // ex: ['btn','btn-sm','btn-link']

  AppBarActionButton({
    required this.label,
    this.title,
    this.onPressed,
    this.bootstrap = const ['btn', 'btn-sm', 'btn-link'],
    super.id,
  });

  late final ButtonElement _btn = ButtonElement();

  @override
  Element create() {
    _btn
      ..id = id ?? 'appbar-action-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(bootstrap)
      ..text = label
      ..title = title ?? label
      ..onClick.listen((_) => onPressed?.call());
    return _btn;
  }

  @override
  Element get getElement => _btn;
}
