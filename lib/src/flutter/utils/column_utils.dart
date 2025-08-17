part of 'utils.dart';

/// =============================================================
/// Enums "Flutter-like"
/// =============================================================
enum MainAxisAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum CrossAxisAlignment {
  start,
  end,
  center,
  stretch, // s'aligne & remplit la largeur dispo
}

enum MainAxisSize {
  min, // ne pas forcer la hauteur
  max, // essayer d'occuper l'axe principal
}

enum VerticalDirection {
  down, // haut -> bas (défaut)
  up,   // bas -> haut (ordre inversé)
}
