part of 'widgets.dart';

// ============================================================================
// Helpers existants attendus :
//
// - abstract class Relement { String? id; Relement({this.id}); Element create(); Element get getElement; }
// - enum AutovalidateMode { disabled, always, onUserInteraction }
// - abstract class FieldApi { bool validate(); void save(); void reset(); }
// - class FormController { AutovalidateMode autovalidateMode; void _register(FieldApi f); void _unregister(FieldApi f); ... }
// - class InputDecoration { labelText, helperText, errorText, prefixIconHtml/suffixIconHtml, ... border, enabledBorder, focusedBorder, errorBorder, disabledBorder, filled, fillColor, contentPadding, borderRadius, ... }
// - abstract class InputBorder { void applyTo(DivElement el); } (et ses variantes)
// - class EdgeInsets { String toCss(); }
// - enum FieldSize { small, medium, large }
//
// ============================================================================
// CSS générique pour les champs “non-TextField”
// ============================================================================
bool _ffCssInjected = false;
void _ensureFormFieldCss() {
  if (_ffCssInjected) return;
  _ffCssInjected = true;
  final style =
      StyleElement()
        ..id = 'rdx-form-fields'
        ..text = '''
.ff{ display:block; font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Arial; }
.ff-wrap{ display:grid; grid-template-columns:auto 1fr auto; align-items:center; background: var(--ff-fill, transparent); border-radius: var(--ff-radius, 10px); }
.ff-side{ display:inline-flex; align-items:center; gap:6px; padding:0 6px; color: var(--ff-hint, #94a3b8); }
.ff-center{ position:relative; }
.ff-input, .ff-select, .ff-textarea{
  width:100%; background:transparent; border:0; outline:none; color: var(--ff-text, #0f172a);
  font-size:14px; transition: background .12s ease, color .12s ease;
}
.ff.sm .ff-input, .ff.sm .ff-select, .ff.sm .ff-textarea{ font-size:13px; }
.ff.lg .ff-input, .ff.lg .ff-select, .ff.lg .ff-textarea{ font-size:16px; }
.ff-label{ position:absolute; left:12px; top:4px; color: var(--ff-hint, #94a3b8); font-size:11px; pointer-events:none; }
.ff-helper{ font-size:12px; color:#6b7280; margin-top:6px; }
.ff-helper.is-error{ color: var(--ff-error, #dc3545); }
.ff-meta{ display:flex; justify-content:space-between; align-items:center; margin-top:6px; }

/* boutons icône (clear…) */
.ff-icon-btn{ display:inline-flex; align-items:center; justify-content:center; border:0; background:transparent; color: var(--ff-hint, #94a3b8); border-radius:6px; cursor:pointer; }
.ff-icon-btn:hover{ background: rgba(0,0,0,.06); }

/* Select / Textarea - bordure retirée, gérée par InputBorder sur le wrap */
.ff-select{ appearance:none; background:transparent; padding-right: 28px; }
.ff-select-arrow{ pointer-events:none; margin-right:8px; color: var(--ff-hint, #94a3b8); }

.ff-textarea{ resize: vertical; min-height: 80px; }

/* Error flag sur le container */
.ff.is-error .ff-wrap{ /* la bordure sera appliquée via InputBorder(error) côté code */ }
''';
  document.head?.append(style);
}

// =============================================================
// Form – conteneur logique (pas de <form> natif pour éviter conflits).
// Tu peux déclencher controller.validate()/save() depuis un bouton.
// =============================================================
class Form extends Relement {
  final FormController controller;
  final Relement child; // ton layout de champs (Column, etc.)
  final void Function()? onValidSubmit; // optionnel: appelé si validate()==true

  Form({
    required this.controller,
    required this.child,
    this.onValidSubmit,
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'form-${DateTime.now().microsecondsSinceEpoch}'
      ..setAttribute('role', 'form');

    _root.children
      ..clear()
      ..add(child.create());

    // (Optionnel) capter "Enter" pour soumettre
    _root.onKeyDown.listen((e) {
      if (e.key == 'Enter' && (e.target is InputElement)) {
        final ok = controller.validate();
        if (ok) onValidSubmit?.call();
      }
    });

    return _root;
  }

  @override
  Element get getElement => _root;
}

// =============================================================
// FormController – centralise validate/save/reset + auto-validate
// =============================================================
class FormController {
  AutovalidateMode autovalidateMode;
  final List<FieldApi> _fields = [];

  FormController({this.autovalidateMode = AutovalidateMode.disabled});

  void _register(FieldApi f) {
    if (!_fields.contains(f)) _fields.add(f);
  }

  void _unregister(FieldApi f) {
    _fields.remove(f);
  }

  bool validate() {
    var ok = true;
    for (final f in List<FieldApi>.from(_fields)) {
      ok = f.validate() && ok;
    }
    return ok;
  }

  void save() {
    for (final f in List<FieldApi>.from(_fields)) {
      f.save();
    }
  }

  void reset() {
    for (final f in List<FieldApi>.from(_fields)) {
      f.reset();
    }
  }
}

// ============================================================================
// Utilitaires communs aux champs décorés (bordure, états, helper/error)
// ============================================================================
mixin _DecoratedHost on Relement {
  // Thème (CSS vars)
  Color fill = const Color('transparent');
  Color focusColor = const Color('#0d6efd');
  Color errorColor = const Color('#dc3545');
  Color textColor = const Color('#0f172a');
  Color hintColor = const Color('#94a3b8');
  Color disabledColor = const Color('rgba(0,0,0,.38)');
  double radius = 10;

  // Décoration
  InputDecoration decoration = const InputDecoration();
  FieldSize size = FieldSize.medium;

  // État UI
  bool enabled = true;
  bool isFocused = false;
  String? externalError; // erreur injectée par la validation

  // Nodes
  final DivElement ffRoot = DivElement();
  final DivElement ffWrap = DivElement();
  final DivElement ffLeft = DivElement();
  final DivElement ffRight = DivElement();
  final DivElement ffCenter = DivElement();
  final DivElement ffHelper = DivElement();

  void initHost({required String kindClass}) {
    _ensureFormFieldCss();

    ffRoot
      ..classes.addAll(['ff', kindClass, _sizeToken(size)])
      ..style.setProperty(
        '--ff-fill',
        decoration.filled
            ? (decoration.fillColor ?? 'transparent')
            : 'transparent',
      )
      ..style.setProperty('--ff-text', textColor.color)
      ..style.setProperty('--ff-hint', hintColor.color)
      ..style.setProperty('--ff-error', errorColor.color)
      ..style.setProperty(
        '--ff-radius',
        '${decoration.borderRadius ?? radius}px',
      );

    if (!enabled) ffRoot.classes.add('is-disabled');

    ffWrap.classes.add('ff-wrap');
    ffLeft.classes.add('ff-side');
    ffRight.classes.add('ff-side');
    ffCenter.classes.add('ff-center');

    // Prefix/Suffix icons from decoration
    if (decoration.prefixIcon != null) {
      final icon =
          SpanElement()
            ..classes.add('ff-affix')
            ..setInnerHtml(
              decoration.prefixIcon?.create().outerHtml!,
              treeSanitizer: NodeTreeSanitizer.trusted,
            );
      ffLeft.children.add(icon);
    }
    if (decoration.suffixIcon != null) {
      final icon =
          SpanElement()
            ..classes.add('ff-affix')
            ..setInnerHtml(
              decoration.suffixIcon?.create().outerHtml!,
              treeSanitizer: NodeTreeSanitizer.trusted,
            );
      ffRight.children.add(icon);
    }

    // Helper/Error
    ffHelper.className = 'ff-helper';
    final err = _errorEffective();
    if (err != null && err.isNotEmpty) {
      ffRoot.classes.add('is-error');
      ffHelper
        ..text = err
        ..classes.add('is-error');
    } else if (decoration.helperText != null &&
        decoration.helperText!.isNotEmpty) {
      ffHelper.text = decoration.helperText!;
    }
  }

  void assembleHost(List<Element> centerChildren) {
    ffCenter.children
      ..clear()
      ..addAll(centerChildren);
    ffWrap.children
      ..clear()
      ..addAll([ffLeft, ffCenter, ffRight]);
    ffRoot.children
      ..clear()
      ..addAll([
        ffWrap,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(ffHelper),
      ]);
    _applyBorder();
  }

  void setErrorText(String? msg) {
    externalError = (msg != null && msg.isNotEmpty) ? msg : null;
    final has = externalError != null;
    ffRoot.classes.toggle('is-error', has);
    ffHelper.classes.toggle('is-error', has);
    if (has) {
      ffHelper.text = externalError!;
    } else {
      ffHelper.text = decoration.helperText ?? '';
    }
    _applyBorder();
  }

  String? _errorEffective() => externalError ?? decoration.errorText;

  void _applyBorder() {
    final b = _effectiveBorder();
    b.applyTo(ffWrap);
  }

  InputBorder _effectiveBorder() {
    // priorités : disabled > error > focus > enabled > default
    if (!enabled) {
      return decoration.disabledBorder ??
          decoration.enabledBorder ??
          decoration.border ??
          OutlineInputBorder(borderRadius: decoration.borderRadius ?? radius);
    }
    final hasError = _errorEffective() != null && _errorEffective()!.isNotEmpty;
    if (hasError) {
      return decoration.errorBorder ??
          decoration.focusedBorder ??
          decoration.enabledBorder ??
          decoration.border ??
          OutlineInputBorder(
            borderRadius: decoration.borderRadius ?? radius,
            borderSide: BorderSide(color: errorColor.color, width: 2),
          );
    }
    if (isFocused) {
      return decoration.focusedBorder ??
          decoration.enabledBorder ??
          decoration.border ??
          OutlineInputBorder(
            borderRadius: decoration.borderRadius ?? radius,
            borderSide: BorderSide(color: focusColor.color, width: 2),
          );
    }
    return decoration.enabledBorder ??
        decoration.border ??
        OutlineInputBorder(borderRadius: decoration.borderRadius ?? radius);
  }

  String _sizeToken(FieldSize s) => switch (s) {
    FieldSize.small => 'sm',
    FieldSize.medium => 'md',
    FieldSize.large => 'lg',
  };
}

// ============================================================================
// 1) Dropdown (Select) + DropdownFormField<T>
// ============================================================================
class DropdownMenuItem<T> {
  final T value;
  final String label;
  final bool disabled;
  DropdownMenuItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

class DropdownField<T> extends Relement with _DecoratedHost {
  final List<DropdownMenuItem<T>> items;
  T? value;
  final void Function(T? v)? onChanged;

  DropdownField({
    required this.items,
    this.value,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FieldSize size = FieldSize.medium,
    bool enabled = true,
    double radius = 10,
    Color textColor = const Color('#0f172a'),
    Color hintColor = const Color('#94a3b8'),
    Color focusColor = const Color('#0d6efd'),
    Color errorColor = const Color('#dc3545'),
    Color disabledColor = const Color('rgba(0,0,0,.38)'),
    Color fill = const Color('transparent'),
    super.id,
  }) {
    this.decoration = decoration;
    this.size = size;
    this.enabled = enabled;
    this.radius = radius;
    this.textColor = textColor;
    this.hintColor = hintColor;
    this.focusColor = focusColor;
    this.errorColor = errorColor;
    this.disabledColor = disabledColor;
    this.fill = fill;
  }

  final SelectElement _select = SelectElement();
  final SpanElement _arrow =
      SpanElement()
        ..classes.add('ff-select-arrow')
        ..text = '▾';

  @override
  Element create() {
    initHost(kindClass: 'dropdown');

    _select
      ..classes.add('ff-select')
      ..disabled = !enabled;

    // Padding
    final pad =
        decoration.contentPadding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    _select.style.padding = pad.toCss();

    // Label (non flottant -> juste en haut)
    if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
      final lab =
          LabelElement()
            ..classes.add('ff-label')
            ..text = decoration.labelText!;
      ffCenter.children.add(lab);
    }

    // Options
    _select.children.clear();
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      final opt = OptionElement(data: it.label, value: '$i')
        ..disabled = it.disabled;
      _select.children.add(opt);
      if (value != null && it.value == value) _select.selectedIndex = i;
    }

    _select.onChange.listen((_) {
      final idx = _select.selectedIndex ?? -1;
      final v = (idx >= 0 && idx < items.length) ? items[idx].value : null;
      value = v;
      onChanged?.call(v);
    });

    _select.onFocus.listen((_) {
      isFocused = true;
      _applyBorder();
    });
    _select.onBlur.listen((_) {
      isFocused = false;
      _applyBorder();
    });

    assembleHost([_select]);
    // put suffix arrow (pure visuel)
    ffRight.children.add(_arrow);
    return ffRoot;
  }

  @override
  Element get getElement => ffRoot;
}

class DropdownFormField<T> extends Relement implements FieldApi {
  final FormController controller;
  final List<DropdownMenuItem<T>> items;
  T? value;
  final String? Function(T? value)? validator;
  final void Function(T? value)? onSaved;
  final void Function(T? value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  final InputDecoration decoration;
  final FieldSize size;
  final bool enabled;

  DropdownFormField({
    required this.controller,
    required this.items,
    this.value,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.decoration = const InputDecoration(),
    this.size = FieldSize.medium,
    this.enabled = true,
    super.id,
  });

  late final DropdownField<T> _field;
  bool _userInteracted = false;
  final DivElement _host = DivElement();

  @override
  Element create() {
    _field = DropdownField<T>(
      items: items,
      value: value,
      enabled: enabled,
      decoration: decoration,
      onChanged: (v) {
        value = v;
        _userInteracted = true;
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode == AutovalidateMode.always ||
            (mode == AutovalidateMode.onUserInteraction && _userInteracted)) {
          _applyValidation();
        }
        onChanged?.call(v);
      },
    );

    _host.classes.add('ff-host');
    _host.children
      ..clear()
      ..add(_field.create());
    controller._register(this);
    return _host;
  }

  @override
  Element get getElement => _host;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    _userInteracted = false;
    value = null;
    _field.setErrorText(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _field.setErrorText(err);
    return err == null || err.isEmpty;
  }
}

// ============================================================================
// 2) ComboBox (input + datalist) + ComboBoxFormField
// ============================================================================
class ComboBoxItem {
  final String value;
  final String label;
  ComboBoxItem(this.value, this.label);
}

class ComboBoxField extends Relement with _DecoratedHost {
  final List<ComboBoxItem> items;
  String value;
  final void Function(String v)? onChanged;
  final bool allowCustom;

  ComboBoxField({
    required this.items,
    this.value = '',
    this.onChanged,
    this.allowCustom = true,
    InputDecoration decoration = const InputDecoration(),
    FieldSize size = FieldSize.medium,
    bool enabled = true,
    double radius = 10,
    Color fill = const Color('transparent'),
    Color focusColor = const Color('#0d6efd'),
    Color errorColor = const Color('#dc3545'),
    Color textColor = const Color('#0f172a'),
    Color hintColor = const Color('#94a3b8'),
    Color disabledColor = const Color('rgba(0,0,0,.38)'),
    // String textColor = '#0f172a',
    // String hintColor = '#94a3b8',
    // String focusColor = '#0d6efd',
    // String errorColor = '#dc3545',
    // String disabledColor = 'rgba(0,0,0,.38)',
    // String fill = 'transparent',
    super.id,
  }) {
    this.decoration = decoration;
    this.size = size;
    this.enabled = enabled;
    this.radius = radius;
    this.textColor = textColor;
    this.hintColor = hintColor;
    this.focusColor = focusColor;
    this.errorColor = errorColor;
    this.disabledColor = disabledColor;
    this.fill = fill;
  }

  final InputElement _input = InputElement();
  final DataListElement _list = DataListElement();

  @override
  Element create() {
    initHost(kindClass: 'combobox');

    final dlId = 'dl-${hashCode}-${DateTime.now().microsecondsSinceEpoch}';
    _list.id = dlId;

    for (final it in items) {
      _list.children.add(OptionElement(data: it.label, value: it.value));
    }

    _input
      ..classes.add('ff-input')
      ..placeholder = decoration.hintText ?? ''
      ..value = value
      ..disabled = !enabled
      ..setAttribute('list', dlId);

    final pad =
        decoration.contentPadding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    _input.style.padding = pad.toCss();

    if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
      final lab =
          LabelElement()
            ..classes.add('ff-label')
            ..text = decoration.labelText!;
      ffCenter.children.add(lab);
    }

    _input.onInput.listen((_) {
      value = _input.value ?? '';
      onChanged?.call(value);
    });
    _input.onChange.listen((_) {
      value = _input.value ?? '';
      // si allowCustom=false, verrouille sur les valeurs proposées
      if (!allowCustom && !items.any((e) => e.value == value)) {
        final first = items.isNotEmpty ? items.first.value : '';
        _input.value = first;
        value = first;
      }
      onChanged?.call(value);
    });
    _input.onFocus.listen((_) {
      isFocused = true;
      _applyBorder();
    });
    _input.onBlur.listen((_) {
      isFocused = false;
      _applyBorder();
    });

    assembleHost([_input, _list]);
    return ffRoot;
  }

  @override
  Element get getElement => ffRoot;
}

class ComboBoxFormField extends Relement implements FieldApi {
  final FormController controller;
  final List<ComboBoxItem> items;
  String value;
  final bool allowCustom;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final void Function(String value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  final InputDecoration decoration;
  final FieldSize size;
  final bool enabled;

  ComboBoxFormField({
    required this.controller,
    required this.items,
    this.value = '',
    this.allowCustom = true,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.decoration = const InputDecoration(),
    this.size = FieldSize.medium,
    this.enabled = true,
    super.id,
  });

  late final ComboBoxField _field;
  bool _userInteracted = false;
  final DivElement _host = DivElement();

  @override
  Element create() {
    _field = ComboBoxField(
      items: items,
      value: value,
      allowCustom: allowCustom,
      enabled: enabled,
      decoration: decoration,
      size: size,
      onChanged: (v) {
        value = v;
        _userInteracted = true;
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode == AutovalidateMode.always ||
            (mode == AutovalidateMode.onUserInteraction && _userInteracted)) {
          _applyValidation();
        }
        onChanged?.call(v);
      },
    );

    _host.children
      ..clear()
      ..add(_field.create());
    controller._register(this);
    return _host;
  }

  @override
  Element get getElement => _host;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    _userInteracted = false;
    value = '';
    _field.setErrorText(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _field.setErrorText(err);
    return err == null || err.isEmpty;
  }
}

// ============================================================================
// 3) MultiSelect (select multiple) + FormField
// ============================================================================
class MultiSelectField<T> extends Relement with _DecoratedHost {
  final List<DropdownMenuItem<T>> items;
  final List<T> values;
  final void Function(List<T> v)? onChanged;

  MultiSelectField({
    required this.items,
    List<T>? values,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FieldSize size = FieldSize.medium,
    bool enabled = true,
    super.id,
  }) : values = values ?? [];

  final SelectElement _select = SelectElement()..multiple = true;

  @override
  Element create() {
    initHost(kindClass: 'multiselect');

    _select
      ..classes.add('ff-select')
      ..disabled = !enabled;

    final pad =
        decoration.contentPadding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    _select.style.padding = pad.toCss();

    if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
      final lab =
          LabelElement()
            ..classes.add('ff-label')
            ..text = decoration.labelText!;
      ffCenter.children.add(lab);
    }

    _select.children.clear();
    for (var i = 0; i < items.length; i++) {
      final it = items[i];
      final opt =
          OptionElement(data: it.label, value: '$i')
            ..disabled = it.disabled
            ..selected = values.contains(it.value);
      _select.children.add(opt);
    }

    _select.onChange.listen((_) {
      final selected = <T>[];
      for (var i = 0; i < _select.options.length; i++) {
        final o = _select.options[i];
        if (o.selected) {
          final val = items[int.parse(o.value)].value;
          selected.add(val);
        }
      }
      values
        ..clear()
        ..addAll(selected);
      onChanged?.call(List<T>.from(values));
    });

    _select.onFocus.listen((_) {
      isFocused = true;
      _applyBorder();
    });
    _select.onBlur.listen((_) {
      isFocused = false;
      _applyBorder();
    });

    assembleHost([_select]);
    return ffRoot;
  }

  @override
  Element get getElement => ffRoot;
}

class MultiSelectFormField<T> extends Relement implements FieldApi {
  final FormController controller;
  final List<DropdownMenuItem<T>> items;
  final List<T> values;
  final String? Function(List<T> values)? validator;
  final void Function(List<T> values)? onSaved;
  final void Function(List<T> values)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration decoration;
  final FieldSize size;
  final bool enabled;

  MultiSelectFormField({
    required this.controller,
    required this.items,
    List<T>? values,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.decoration = const InputDecoration(),
    this.size = FieldSize.medium,
    this.enabled = true,
    super.id,
  }) : values = values ?? [];

  late final MultiSelectField<T> _field;
  bool _userInteracted = false;
  final DivElement _host = DivElement();

  @override
  Element create() {
    _field = MultiSelectField<T>(
      items: items,
      values: values,
      decoration: decoration,
      size: size,
      enabled: enabled,
      onChanged: (v) {
        values
          ..clear()
          ..addAll(v);
        _userInteracted = true;
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode == AutovalidateMode.always ||
            (mode == AutovalidateMode.onUserInteraction && _userInteracted)) {
          _applyValidation();
        }
        onChanged?.call(List<T>.from(values));
      },
    );
    _host.children
      ..clear()
      ..add(_field.create());
    controller._register(this);
    return _host;
  }

  @override
  Element get getElement => _host;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(List<T>.from(values));

  @override
  void reset() {
    _userInteracted = false;
    values.clear();
    _field.setErrorText(null);
  }

  bool _applyValidation() {
    final err = validator?.call(List<T>.from(values));
    _field.setErrorText(err);
    return err == null || err.isEmpty;
  }
}

// ============================================================================
// 4) Checkbox / Switch / RadioGroup / Slider – FormFields
// ============================================================================
class CheckboxFormField extends Relement implements FieldApi {
  final FormController controller;
  bool value;
  final String label;
  final String? Function(bool value)? validator;
  final void Function(bool value)? onSaved;
  final void Function(bool value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  CheckboxFormField({
    required this.controller,
    required this.value,
    required this.label,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    super.id,
  });

  final LabelElement _root = LabelElement();
  final CheckboxInputElement _cb = CheckboxInputElement();
  final SpanElement _txt = SpanElement();
  final DivElement _err = DivElement()..classes.add('ff-helper');

  @override
  Element create() {
    _ensureFormFieldCss();
    _root
      ..classes.add('ff')
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.gap = '8px';

    _cb
      ..checked = value
      ..onChange.listen((_) {
        value = _cb.checked ?? false;
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode != AutovalidateMode.disabled) _applyValidation();
        onChanged?.call(value);
      });

    _txt.text = label;

    _root.children
      ..clear()
      ..addAll([
        _cb,
        _txt,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(_err),
      ]);
    controller._register(this);
    return _root;
  }

  @override
  Element get getElement => _root;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    value = false;
    _cb.checked = false;
    _setError(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _err.text = has ? msg : '';
    _err.classes.toggle('is-error', has);
  }
}

class SwitchFormField extends Relement implements FieldApi {
  final FormController controller;
  bool value;
  final String label;
  final String? Function(bool value)? validator;
  final void Function(bool value)? onSaved;
  final void Function(bool value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  SwitchFormField({
    required this.controller,
    required this.value,
    required this.label,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    super.id,
  });

  final LabelElement _root = LabelElement();
  final CheckboxInputElement _sw = CheckboxInputElement(); // role switch
  final SpanElement _txt = SpanElement();
  final DivElement _err = DivElement()..classes.add('ff-helper');

  @override
  Element create() {
    _ensureFormFieldCss();
    _root
      ..classes.add('ff')
      ..style.display = 'flex'
      ..style.alignItems = 'center'
      ..style.gap = '8px';

    _sw
      ..checked = value
      ..onChange.listen((_) {
        value = _sw.checked ?? false;
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode != AutovalidateMode.disabled) _applyValidation();
        onChanged?.call(value);
      });

    _txt.text = label;

    _root.children
      ..clear()
      ..addAll([
        _sw,
        _txt,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(_err),
      ]);
    controller._register(this);
    return _root;
  }

  @override
  Element get getElement => _root;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    value = false;
    _sw.checked = false;
    _setError(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _err.text = has ? msg : '';
    _err.classes.toggle('is-error', has);
  }
}

class RadioOption<T> {
  final T value;
  final String label;
  RadioOption(this.value, this.label);
}

class RadioGroupFormField<T> extends Relement implements FieldApi {
  final FormController controller;
  final String name;
  T? value;
  final List<RadioOption<T>> options;
  final String? Function(T? value)? validator;
  final void Function(T? value)? onSaved;
  final void Function(T? value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  RadioGroupFormField({
    required this.controller,
    required this.name,
    required this.options,
    this.value,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    super.id,
  });

  final DivElement _root = DivElement();
  final DivElement _err = DivElement()..classes.add('ff-helper');

  @override
  Element create() {
    _ensureFormFieldCss();
    _root.classes.add('ff');
    final row =
        DivElement()
          ..style.display = 'flex'
          ..style.flexWrap = 'wrap'
          ..style.gap = '12px';

    for (final opt in options) {
      final lab =
          LabelElement()
            ..style.display = 'inline-flex'
            ..style.alignItems = 'center'
            ..style.gap = '6px';
      final rb =
          RadioButtonInputElement()
            ..name = name
            ..checked = (value != null && value == opt.value);
      rb.onChange.listen((_) {
        if (rb.checked == true) {
          value = opt.value;
          final mode = autovalidateMode ?? controller.autovalidateMode;
          if (mode != AutovalidateMode.disabled) _applyValidation();
          onChanged?.call(value);
        }
      });
      lab.children.addAll([rb, SpanElement()..text = opt.label]);
      row.children.add(lab);
    }

    _root.children
      ..clear()
      ..addAll([
        row,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(_err),
      ]);
    controller._register(this);
    return _root;
  }

  @override
  Element get getElement => _root;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    value = null;
    _setError(null);
    // reset visuel
    for (final el in _root.querySelectorAll('input[type="radio"]')) {
      (el as RadioButtonInputElement).checked = false;
    }
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _err.text = has ? msg : '';
    _err.classes.toggle('is-error', has);
  }
}

class SliderFormField extends Relement implements FieldApi {
  final FormController controller;
  double value;
  final double min;
  final double max;
  final double step;
  final String? Function(double value)? validator;
  final void Function(double value)? onSaved;
  final void Function(double value)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final String? label;

  SliderFormField({
    required this.controller,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.label,
    super.id,
  });

  final DivElement _root = DivElement();
  final InputElement _range = InputElement(type: 'range');
  final SpanElement _val = SpanElement();
  final DivElement _err = DivElement()..classes.add('ff-helper');

  @override
  Element create() {
    _ensureFormFieldCss();
    _root.classes.add('ff');

    if (label != null) {
      _root.children.add(LabelElement()..text = label!);
    }

    _range
      ..min = '$min'
      ..max = '$max'
      ..step = '$step'
      ..value = '$value';
    _val.text = value.toString();

    _range.onInput.listen((_) {
      value = double.tryParse(_range.value ?? '') ?? value;
      _val.text = value.toString();
      final mode = autovalidateMode ?? controller.autovalidateMode;
      if (mode != AutovalidateMode.disabled) _applyValidation();
      onChanged?.call(value);
    });

    _root.children.add(
      DivElement()
        ..style.display = 'flex'
        ..style.alignItems = 'center'
        ..style.gap = '8px'
        ..children.addAll([_range, _val]),
    );
    _root.children.add(
      DivElement()
        ..classes.add('ff-meta')
        ..children.add(_err),
    );

    controller._register(this);
    return _root;
  }

  @override
  Element get getElement => _root;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    value = min;
    _range.value = '$value';
    _val.text = '$value';
    _setError(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _err.text = has ? msg : '';
    _err.classes.toggle('is-error', has);
  }
}

// ============================================================================
// 5) TextAreaFormField – textarea décorée (label, helper, border)
// ============================================================================
class TextAreaFormField extends Relement implements FieldApi {
  final FormController controller;
  String value;
  final String? Function(String value)? validator;
  final void Function(String value)? onSaved;
  final void Function(String value)? onChanged;
  final AutovalidateMode? autovalidateMode;

  // Décor
  final InputDecoration decoration;
  final FieldSize size;
  final bool enabled;

  TextAreaFormField({
    required this.controller,
    this.value = '',
    this.validator,
    this.onSaved,
    this.onChanged,
    this.autovalidateMode,
    this.decoration = const InputDecoration(),
    this.size = FieldSize.medium,
    this.enabled = true,
    super.id,
  });

  final _host = DivElement();
  final _wrap = DivElement();
  final _left = DivElement();
  final _right = DivElement();
  final _center = DivElement();
  final _helper = DivElement();
  final _ta = TextAreaElement();

  bool _focused = false;

  @override
  Element create() {
    _ensureFormFieldCss();

    _host
      ..classes.addAll(['ff', _sizeToken(size)])
      ..style.setProperty(
        '--ff-fill',
        decoration.filled
            ? (decoration.fillColor ?? 'transparent')
            : 'transparent',
      )
      ..style.setProperty('--ff-hint', '#94a3b8')
      ..style.setProperty('--ff-error', '#dc3545')
      ..style.setProperty('--ff-text', '#0f172a')
      ..style.setProperty('--ff-radius', '${decoration.borderRadius ?? 10}px');

    _wrap.classes.add('ff-wrap');
    _left.classes.add('ff-side');
    _right.classes.add('ff-side');
    _center.classes.add('ff-center');
    _helper.className = 'ff-helper';

    if (decoration.prefixIcon != null) {
      _left.children.add(
        SpanElement()
          ..classes.add('ff-affix')
          ..setInnerHtml(
            iconToHtml(decoration.prefixIcon!),
            treeSanitizer: NodeTreeSanitizer.trusted,
          ),
      );
    }
    if (decoration.suffixIcon != null) {
      _right.children.add(
        SpanElement()
          ..classes.add('ff-affix')
          ..setInnerHtml(
            iconToHtml(decoration.suffixIcon!),
            treeSanitizer: NodeTreeSanitizer.trusted,
          ),
      );
    }

    _ta
      ..classes.add('ff-textarea')
      ..value = value
      ..disabled = !enabled;

    final pad =
        decoration.contentPadding ??
        EdgeInsets.symmetric(horizontal: 12, vertical: 12);
    _ta.style.padding = pad.toCss();

    if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
      _center.children.add(
        LabelElement()
          ..classes.add('ff-label')
          ..text = decoration.labelText!,
      );
    }

    _ta.onInput.listen((_) {
      value = _ta.value ?? '';
      final mode = autovalidateMode ?? controller.autovalidateMode;
      if (mode != AutovalidateMode.disabled) _applyValidation();
      onChanged?.call(value);
    });
    _ta.onFocus.listen((_) {
      _focused = true;
      _applyBorder();
    });
    _ta.onBlur.listen((_) {
      _focused = false;
      _applyBorder();
    });

    _center.children.add(_ta);
    _wrap.children
      ..clear()
      ..addAll([_left, _center, _right]);

    // Helper / Error
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      _helper
        ..text = decoration.errorText!
        ..classes.add('is-error');
    } else if (decoration.helperText != null &&
        decoration.helperText!.isNotEmpty) {
      _helper.text = decoration.helperText!;
    }

    _host.children
      ..clear()
      ..addAll([
        _wrap,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(_helper),
      ]);
    _applyBorder();
    controller._register(this);
    return _host;
  }

  @override
  Element get getElement => _host;

  @override
  bool validate() => _applyValidation();

  @override
  void save() => onSaved?.call(value);

  @override
  void reset() {
    value = '';
    _ta.value = '';
    _setError(null);
  }

  bool _applyValidation() {
    final err = validator?.call(value);
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _helper.text = has ? msg : (decoration.helperText ?? '');
    _helper.classes.toggle('is-error', has);
    _applyBorder();
  }

  void _applyBorder() {
    final border =
        (() {
          final hasErr = _helper.classes.contains('is-error');
          if (hasErr) {
            return decoration.errorBorder ??
                decoration.focusedBorder ??
                decoration.enabledBorder ??
                decoration.border ??
                OutlineInputBorder(
                  borderRadius: decoration.borderRadius ?? 10,
                  borderSide: const BorderSide(color: '#dc3545', width: 2),
                );
          }
          if (_focused) {
            return decoration.focusedBorder ??
                decoration.enabledBorder ??
                decoration.border ??
                OutlineInputBorder(
                  borderRadius: decoration.borderRadius ?? 10,
                  borderSide: const BorderSide(color: '#0d6efd', width: 2),
                );
          }
          return decoration.enabledBorder ??
              decoration.border ??
              OutlineInputBorder(borderRadius: decoration.borderRadius ?? 10);
        })();
    border.applyTo(_wrap);
  }

  String _sizeToken(FieldSize s) => switch (s) {
    FieldSize.small => 'sm',
    FieldSize.medium => 'md',
    FieldSize.large => 'lg',
  };
}

// ============================================================================
// 6) FilePickerFormField – fichiers (accept/multiple) + validation
// ============================================================================
class FilePickerFormField extends Relement implements FieldApi {
  final FormController controller;
  final bool multiple;
  final String? accept; // ex: "image/*,.pdf"
  final int? maxFiles; // null illimité
  final int? maxSizeMB; // par fichier
  List<File> files;

  final String? Function(List<File> files)? validator;
  final void Function(List<File> files)? onSaved;
  final void Function(List<File> files)? onChanged;
  final Relement label;
  final AutovalidateMode? autovalidateMode;

  FilePickerFormField({
    required this.controller,
    this.multiple = false,
    this.accept,
    this.maxFiles,
    this.maxSizeMB,
    List<File>? initialFiles,
    this.validator,
    this.onSaved,
    this.onChanged,
    required this.label,
    this.autovalidateMode,
    super.id,
  }) : files = initialFiles ?? [];

  final DivElement _root = DivElement();
  final FileUploadInputElement _input = FileUploadInputElement();
  final UListElement _list = UListElement();
  final DivElement _err = DivElement()..classes.add('ff-helper');

  @override
  Element create() {
    _ensureFormFieldCss();
    _root.classes.add('ff');

    _input
      ..multiple = multiple
      ..accept = accept ?? ''
      ..style.display = 'none';

    final btn =
        ButtonElement()
          ..children.add(label.create())
          ..classes.add('ff-icon-btn')
          ..onClick.listen((_) => _input.click());

    _input.onChange.listen((_) {
      files = _input.files?.toList() ?? [];
      // règles locales rapides
      final locErr = _localRules();
      if (locErr != null) {
        _setError(locErr);
      } else {
        final mode = autovalidateMode ?? controller.autovalidateMode;
        if (mode != AutovalidateMode.disabled) _applyValidation();
        _setError(null);
      }
      _renderList();
      onChanged?.call(List<File>.from(files));
    });

    _renderList();

    _root.children
      ..clear()
      ..addAll([
        btn,
        _list,
        DivElement()
          ..classes.add('ff-meta')
          ..children.add(_err),
      ]);
    controller._register(this);
    return _root;
  }

  @override
  Element get getElement => _root;

  void _renderList() {
    _list.children.clear();
    for (final f in files) {
      _list.children.add(
        LIElement()
          ..text =
              '${f.name} (${(f.size / 1024 / 1024).toStringAsFixed(2)} MB)',
      );
    }
  }

  String? _localRules() {
    if (maxFiles != null && files.length > maxFiles!) {
      return 'Maximum $maxFiles fichier(s).';
    }
    if (maxSizeMB != null) {
      for (final f in files) {
        final mb = f.size / 1024 / 1024;
        if (mb > maxSizeMB!) {
          return '“${f.name}” dépasse ${maxSizeMB}MB.';
        }
      }
    }
    return null;
  }

  @override
  bool validate() {
    final errLoc = _localRules();
    if (errLoc != null) {
      _setError(errLoc);
      return false;
    }
    return _applyValidation();
  }

  @override
  void save() => onSaved?.call(List<File>.from(files));

  @override
  void reset() {
    files.clear();
    _input.value = '';
    _renderList();
    _setError(null);
  }

  bool _applyValidation() {
    final err = validator?.call(List<File>.from(files));
    _setError(err);
    return err == null || err.isEmpty;
  }

  void _setError(String? msg) {
    final has = (msg != null && msg.isNotEmpty);
    _err.text = has ? msg : '';
    _err.classes.toggle('is-error', has);
  }
}
