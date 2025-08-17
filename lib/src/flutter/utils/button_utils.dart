part of 'utils.dart';

/// ------------------------------------------------------------
/// Utilitaires
/// ------------------------------------------------------------
enum ButtonSize { small, medium, large }
///
String buttonSizeClass(ButtonSize s) {
  switch (s) {
    case ButtonSize.small:
      return 'btn-sm';
    case ButtonSize.medium:
      return ''; // taille par défaut
    case ButtonSize.large:
      return 'btn-lg';
  }
}

///Utiliser pour les Buttons
void buttonEnsureSpinnerStyles() {
  // Si Bootstrap n'est pas chargé, on met un fallback spinner minimal.
  if (document.getElementById('rdart-btn-spinner-styles') != null) return;
  final style =
      StyleElement()
        ..id = 'rdart-btn-spinner-styles'
        ..text = '''
.rdart-spinner {
  display:inline-block;width:1rem;height:1rem;border:.15em solid rgba(0,0,0,.2);
  border-top-color: rgba(0,0,0,.6); border-radius:50%; animation:rdart-spin .6s linear infinite;
  vertical-align:-.125em;
}
@keyframes rdart-spin { to{ transform: rotate(360deg); } }
''';
  document.head?.append(style);
}

/// ------------------------------------------------------------
/// ElevatedButton – bouton avec relief/filled
/// ------------------------------------------------------------
enum ElevatedVariant { primary, secondary, success, warning, danger, info, light, dark }

String buttonElevClass(ElevatedVariant v) {
  switch (v) {
    case ElevatedVariant.primary:   return 'btn-primary';
    case ElevatedVariant.secondary: return 'btn-secondary';
    case ElevatedVariant.success:   return 'btn-success';
    case ElevatedVariant.warning:   return 'btn-warning';
    case ElevatedVariant.danger:    return 'btn-danger';
    case ElevatedVariant.info:      return 'btn-info';
    case ElevatedVariant.light:     return 'btn-light';
    case ElevatedVariant.dark:      return 'btn-dark';
  }
}

// ============================================================
// 1) IconButton – icône seule (filled / outlined / ghost)
// ============================================================
enum IconButtonStyle { filled, outlined, ghost }

// ============================================================
// 3) ButtonGroup – groupement horizontal/vertical + toggle
// ============================================================
enum ButtonGroupToggle { none, single, multi }

/// =============================================================
/// SegmentedControl – indicateur animé (Flutter-like)
/// =============================================================

class SegmentItem {
  final String label;
  final BsIcon? icon;
  SegmentItem({required this.label, this.icon});
}

/// =============================================================
/// ToggleButton tri-état – off / on / indeterminate
/// =============================================================

enum TriState { off, on, indeterminate }
