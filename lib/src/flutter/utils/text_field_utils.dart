part of 'utils.dart';

class TextEditingController {
  String _text;
  final _listeners = <VoidCallback>[];

  TextEditingController([this._text = '']);

  String get text => _text;
  set text(String v) {
    if (v == _text) return;
    _text = v;
    for (final l in List<VoidCallback>.from(_listeners)) {
      l();
    }
  }

  void addListener(VoidCallback l) => _listeners.add(l);
  void removeListener(VoidCallback l) => _listeners.remove(l);
}
/// ------------------------------------------------------------
/// ------------------------------------------------------------------
/// 1) Types et variantes
/// ------------------------------------------------------------------
enum InputType {
  text, email, number, password, search, tel, url,
  date, time, month, week, datetimeLocal, color,
}
enum InputVariant { outline, underline, filled }
enum FieldSize { small, medium, large }



class OutlineInputBorder extends InputBorder {
  const OutlineInputBorder({double borderRadius = 10, BorderSide borderSide = const BorderSide()})
      : super(borderRadius: borderRadius, borderSide: borderSide);

  @override
  void applyTo(DivElement el) {
    el.style
      ..border = borderSide.toCss()
      ..borderRadius = '${borderRadius}px';
  }
}

class UnderlineInputBorder extends InputBorder {
  const UnderlineInputBorder({BorderSide borderSide = const BorderSide()})
      : super(borderRadius: 0, borderSide: borderSide);

  @override
  void applyTo(DivElement el) {
    el.style
      ..border = 'none'
      ..borderBottom = borderSide.toCss()
      ..borderRadius = '0';
  }
}

class NoInputBorder extends InputBorder {
  const NoInputBorder() : super(borderRadius: 0, borderSide: const BorderSide(color: Color('transparent'), width: 0));

  @override
  void applyTo(DivElement el) {
    el.style
      ..border = 'none'
      ..borderBottom = 'none'
      ..borderRadius = '0';
  }
}

/// ============================================================================
/// 3) InputDecoration (regroupe comme Flutter)
/// ============================================================================
class InputDecoration {
  // Textes
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  // Icônes / textes adjacents
  final BsIcon? prefixIcon;
  final BsIcon? suffixIcon;
  final String? prefixText;
  final String? suffixText;

  // Comportements
  final bool showPasswordToggle;
  final bool showClearButton;

  // Mise en page / fond
  final EdgeInsets? contentPadding;
  final bool filled;
  final String? fillColor;
  final double? borderRadius;

  // Compteur
  final int? maxLength;
  final String? counterText;

  // Autocomplete explicite
  final String? autocomplete;

  // Bordures par état
  final InputBorder? border;         // défaut (enabled)
  final InputBorder? enabledBorder;  // prioritaire quand enabled
  final InputBorder? focusedBorder;  // prioritaire quand focus
  final InputBorder? errorBorder;    // prioritaire quand erreur
  final InputBorder? disabledBorder; // prioritaire quand disabled

  const InputDecoration({
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.showPasswordToggle = false,
    this.showClearButton = false,
    this.contentPadding,
    this.filled = false,
    this.fillColor,
    this.borderRadius,
    this.maxLength,
    this.counterText,
    this.autocomplete,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
  });
}
