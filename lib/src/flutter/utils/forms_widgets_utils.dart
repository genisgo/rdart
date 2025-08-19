part of 'utils.dart';

// =============================================================
// AutovalidateMode (Flutter-like)
// =============================================================
enum AutovalidateMode { disabled, always, onUserInteraction }

// =============================================================
// Contrat minimal pour que le Form pilote ses champs
// =============================================================
abstract class FieldApi {
  bool validate();       // renvoie true si ok
  void save();           // onSaved
  void reset();          // remet à zéro (valeur + erreur visuelle)
}

