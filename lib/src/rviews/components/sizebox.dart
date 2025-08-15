part of '../rview_bases.dart';

/// Compatibilité rétro : l’ancien nom `SizeBox` pointe vers la nouvelle `SizedBox`.
@Deprecated('Utilise plutôt SizedBox')
typedef SizeBox = SizedBox;

/// Un conteneur flexible avec largeur/hauteur optionnelles, alignements,
/// et support d’un ratio (CSS `aspect-ratio`).
///
/// Règles de style :
/// - Si `bootstrap` est vide, on applique un style inline (flex + alignements + width/height/ratio).
/// - Si `bootstrap` n’est pas vide, on **n’ajoute aucun style inline** (pour te laisser
///   la main via les classes).
class SizedBox extends Relement {
  /// Hauteur/largeur en pixels (ou autre selon ton extension `.px`).
  final double? height;
  final double? width;

  /// Ratio largeur/hauteur (ex: 1.5 pour 3:2, 1.0 pour carré).
  /// Utilise la propriété CSS `aspect-ratio`.
  /// - Si `ratio` est défini et que **seule** `width` ou `height` est fournie,
  ///   le navigateur calcule l’autre dimension.
  /// - Si `ratio` + `width` + `height` sont tous définis, le ratio n’aura pas d’effet visible.
  final double? ratio;

  /// Classes Bootstrap (ou utilitaires) à appliquer.
  final List<Bootstrap> bootstrap;

  /// Alignement du contenu quand on gère le style inline.
  final AlignHorizontal alignHorizontal;
  final AlignVertical alignVertical;

  /// Enfant unique optionnel.
  final Relement? child;

  /// Div rendue par ce composant.
  final Element _div = Element.div();

  /// Génération d’ID par défaut si `id` (hérité de Relement) est nul.
  /// On évite le compteur global au profit d’un timestamp pour réduire les collisions.
  String get _autoId => 'sizedbox_${DateTime.now().microsecondsSinceEpoch}';

  SizedBox({
    this.height,
    this.width,
    this.ratio,
    this.child,
    super.id, // conserve la compatibilité avec Relement
    this.bootstrap = const [],
    this.alignHorizontal = AlignHorizontal.center,
    this.alignVertical = AlignVertical.center,
  });

  @override
  Element create() {
    // Ajoute l’enfant si présent
    if (child != null) {
      _div.children.add(child!.create());
    }

    // Assigne un id si absent
    _div.id = id ?? _autoId;

    // Ajoute les classes (si tu en fournis)
    _div.className = bootstrap.join(' ');

    // Si tu n’as PAS donné de classes, on applique les styles par défaut
    if (bootstrap.isEmpty) {
      _div
        ..style.display = 'flex'
        ..style.justifyContent = alignHorizontal.value
        ..style.alignItems = alignVertical.value
        ..style.padding = 0.px;

      // Largeur/hauteur seulement si définies
      if (width != null)  _div.style.width  = width!.px;
      if (height != null) _div.style.height = height!.px;

      // Aspect ratio si fourni
      if (ratio != null) {
        // CSS moderne : accepte une valeur numérique (ex: "1.5") ou "w / h".
        // Ici on passe une valeur simple : "1.5"
        _div.style.aspectRatio = ratio!.toString();
      }
    }

    return _div;
  }

  @override
  Element get getElement => _div;
}
