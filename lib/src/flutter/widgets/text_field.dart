part of 'widgets.dart';

class TextField extends Relement {
  final TextEditingController controller;

  // Logique
  final InputType inputType;
  final bool enabled;
  final bool readOnly;

  // Style global
  final InputVariant variant;
  final FieldSize size;

  // Décoration regroupée
  final InputDecoration decoration;

  // Thème (CSS vars; override par decoration si défini)
  final Color baseFillColor;
  final Color borderColor;
  final Color focusColor;
  final Color errorColor;
  final Color textColor;
  final Color hintColor;
  final Color disabledColor;
  final double borderRadius; // défaut si decoration.borderRadius == null

  // number/date: bornes
  final num? min;
  final num? max;
  final num? step;

  // Callbacks
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  TextField({
    required this.controller,
    this.inputType = InputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.variant = InputVariant.outline,
    this.size = FieldSize.medium,
    this.decoration = const InputDecoration(),

    // // Thème
    // this.baseFillColor = '#f8f9fb',
    // this.borderColor = 'rgba(0,0,0,.20)',
    // this.focusColor = '#0d6efd',
    // this.errorColor = '#dc3545',
    // this.textColor = '#0f172a',
    // this.hintColor = '#94a3b8',
    // this.disabledColor = 'rgba(0,0,0,.38)',
    // this.borderRadius = 10,
    // Thème
    this.baseFillColor = const Color('#f8f9fb'),
    this.borderColor = const Color('rgba(0,0,0,.20)'),
    this.focusColor = const Color('#0d6efd'),
    this.errorColor = const Color('#dc3545'),
    this.textColor = const Color('#0f172a'),
    this.hintColor = const Color('#94a3b8'),
    this.disabledColor = const Color('rgba(0,0,0,.38)'),
    this.borderRadius = 10,

    // number/date: bornes
    this.min,
    this.max,
    this.step,

    this.onChanged,
    this.onSubmitted,
    super.id,
  });

  final DivElement _root = DivElement();
  final DivElement _wrap = DivElement();    // wrapper champ (bordure appliquée ici)
  final DivElement _left = DivElement();    // préfixe (icône/texte)
  final DivElement _right = DivElement();   // suffixe (icône/texte + boutons)
  final DivElement _center = DivElement();  // zone input + label
  final InputElement _input = InputElement();
  final LabelElement _label = LabelElement();
  final DivElement _helper = DivElement();
  final DivElement _counter = DivElement();
  final ButtonElement _clearBtn = ButtonElement();
  final ButtonElement _eyeBtn = ButtonElement();

  bool _isFocused = false;
  bool _obscuredRuntime = false;

  @override
  Element create() {
    _ensureCss();

    _obscuredRuntime = (inputType == InputType.password);

    _root
      ..id = id ?? 'tf-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rdx-tf', 'rdx-${_v(variant)}', 'rdx-${_s(size)}']);
    if (!enabled) _root.classes.add('is-disabled');
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      _root.classes.add('is-error');
    }

    // CSS vars (couleurs/paddings/fond)
    final fill = decoration.filled
        ? (decoration.fillColor ?? baseFillColor.color)
        : 'transparent';

    _root.style
      ..setProperty('--tf-fill', fill)
      ..setProperty('--tf-border', borderColor.color)
      ..setProperty('--tf-focus', focusColor.color)
      ..setProperty('--tf-error', errorColor.color)
      ..setProperty('--tf-text', textColor.color)
      ..setProperty('--tf-hint', hintColor.color)
      ..setProperty('--tf-disabled', disabledColor.color)
      ..setProperty('--tf-radius', '${(decoration.borderRadius ?? borderRadius)}px');

    // --- GRID WRAP ---
    _wrap
      ..classes.add('rdx-field')
      ..style.display = 'grid'
      ..style.gridTemplateColumns = 'auto 1fr auto'
      ..style.alignItems = 'center';
    _left.classes.add('rdx-side');
    _right.classes.add('rdx-side');
    _center.classes.add('rdx-center');

    // LEFT: prefix icon/text
    if (decoration.prefixIcon != null) {
      final icon = SpanElement()
        ..classes.add('rdx-affix')
        ..setInnerHtml(decoration.prefixIcon!.create().outerHtml, treeSanitizer: NodeTreeSanitizer.trusted);
      _left.children.add(icon);
      _root.classes.add('has-prefix');
    }
    if (decoration.prefixText != null && decoration.prefixText!.isNotEmpty) {
      _left.children.add(SpanElement()..classes.add('rdx-affix')..text = decoration.prefixText!);
      _root.classes.add('has-prefix');
    }

    // INPUT
    _input
      ..className = 'rdx-input'
      ..placeholder = ' ' // pour label flottant via :placeholder-shown
      ..value = controller.text
      ..readOnly = readOnly
      ..disabled = !enabled
      ..type = _effectiveHtmlType();
    _applyTypeHints();

    // Padding interne (contentPadding)
    final pad = decoration.contentPadding ??
        (size == FieldSize.small
            ? EdgeInsets.symmetric(vertical: 10, horizontal: 10)
            : size == FieldSize.large
                ? EdgeInsets.symmetric(vertical: 14, horizontal: 14)
                : EdgeInsets.symmetric(vertical: 12, horizontal: 12));
    _input.style
      ..padding = pad.toCss()
      ..color = 'var(--tf-text)';

    // maxLength natif + counter logique
    if (decoration.maxLength != null) {
      _input.maxLength = decoration.maxLength!;
    }

    // Events
    _input.onInput.listen((_) {
      var val = _input.value ?? '';
      // clamp manuel si maxLength fourni
      if (decoration.maxLength != null && val.length > decoration.maxLength!) {
        val = val.substring(0, decoration.maxLength!);
        _input.value = val;
      }
      controller.text = val;
      _refreshHasValue();
      _updateCounter();
      _maybeToggleClear();
      onChanged?.call(val);
    });
    _input.onFocus.listen((_) {
      _isFocused = true;
      _root.classes.add('is-focused');
      _applyBorder();
    });
    _input.onBlur.listen((_) {
      _isFocused = false;
      _root.classes.remove('is-focused');
      _applyBorder();
    });
    _input.onKeyDown.listen((e) {
      if (e.key == 'Enter') onSubmitted?.call(_input.value ?? '');
    });

    controller.addListener(() {
      if (_input.value != controller.text) {
        _input.value = controller.text;
        _refreshHasValue();
        _updateCounter();
        _maybeToggleClear();
      }
    });

    // CENTER: input + floating label
    if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
      _label
        ..className = 'rdx-label'
        ..text = decoration.labelText!;
      _center.children.addAll([_input, _label]);
    } else {
      _center.children.add(_input);
    }

    // RIGHT: clear / eye / suffix
    if (decoration.showClearButton) {
      _clearBtn
        ..type = 'button'
        ..className = 'rdx-icon-btn rdx-clear'
        ..setInnerHtml('✕', treeSanitizer: NodeTreeSanitizer.trusted)
        ..title = 'Effacer';
      _clearBtn.onClick.listen((_) {
        controller.text = '';
        onChanged?.call('');
        _input.focus();
      });
      _right.children.add(_clearBtn);
    }

    final passwordCapable = decoration.showPasswordToggle && (inputType == InputType.password);
    if (passwordCapable) {
      _eyeBtn
        ..type = 'button'
        ..className = 'rdx-icon-btn rdx-eye'
        ..title = 'Afficher/masquer';
      _renderEye();
      _eyeBtn.onClick.listen((_) {
        _obscuredRuntime = !_obscuredRuntime;
        _input.type = _effectiveHtmlType();
        _renderEye();
        _input.focus();
      });
      _right.children.add(_eyeBtn);
      _root.classes.add('has-eye');
    }

    if (decoration.suffixIcon != null) {
      final icon = SpanElement()
        ..classes.add('rdx-affix')
        ..setInnerHtml(decoration.suffixIcon!.create().outerHtml, treeSanitizer: NodeTreeSanitizer.trusted);
      _right.children.add(icon);
      _root.classes.add('has-suffix');
    }
    if (decoration.suffixText != null && decoration.suffixText!.isNotEmpty) {
      _right.children.add(SpanElement()..classes.add('rdx-affix')..text = decoration.suffixText!);
      _root.classes.add('has-suffix');
    }

    // Assemble wrap
    _wrap.children
      ..clear()
      ..addAll([_left, _center, _right]);

    // Helper / Error + Counter
    _helper.className = 'rdx-helper';
    if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
      _helper.text = decoration.errorText!;
      _helper.classes.add('is-error');
    } else if (decoration.helperText != null && decoration.helperText!.isNotEmpty) {
      _helper.text = decoration.helperText!;
    }

    _counter.className = 'rdx-counter';
    _updateCounter(); // init

    _root.children
      ..clear()
      ..addAll([
        _wrap,
        DivElement()..classes.add('rdx-meta')..children.addAll([_helper, _counter]),
      ]);

    // États initiaux
    _refreshHasValue();
    _maybeToggleClear();
    _applyBorder();

    return _root;
  }

  @override
  Element get getElement => _root;

  // ========================================================================
  // Helpers
  // ========================================================================
  void _updateCounter() {
    if (decoration.maxLength == null && decoration.counterText == null) {
      _counter.style.display = 'none';
      return;
    }
    _counter.style.display = 'block';
    if (decoration.counterText != null) {
      _counter.text = decoration.counterText!;
    } else {
      final len = (controller.text).length;
      _counter.text = '$len/${decoration.maxLength}';
      _counter.classes.toggle('is-over', decoration.maxLength != null && len > decoration.maxLength!);
    }
  }

  void _refreshHasValue() {
    final has = (_input.value ?? '').isNotEmpty;
    _root.classes.toggle('has-value', has);
    if (decoration.hintText != null) {
      _input.dataset['hint'] = decoration.hintText!;
    }
  }

  void _maybeToggleClear() {
    if (!decoration.showClearButton) return;
    final show = enabled && (_input.value ?? '').isNotEmpty && !readOnly;
    _clearBtn.style.display = show ? 'inline-flex' : 'none';
  }

  void _renderEye() {
    _eyeBtn.setInnerHtml(_obscuredRuntime ? _biconToString(Bicon.eye) :_biconToString(Bicon.eyeSlash), treeSanitizer: NodeTreeSanitizer.trusted);
  }

  // --- Type & attributs spécialisés ---
  String _effectiveHtmlType() {
    if (_obscuredRuntime) return 'password';
    switch (inputType) {
      case InputType.text:          return 'text';
      case InputType.email:         return 'email';
      case InputType.number:        return 'text'; // inputmode numeric/decimal pour meilleur contrôle
      case InputType.password:      return 'password';
      case InputType.search:        return 'search';
      case InputType.tel:           return 'tel';
      case InputType.url:           return 'url';
      case InputType.date:          return 'date';
      case InputType.time:          return 'time';
      case InputType.month:         return 'month';
      case InputType.week:          return 'week';
      case InputType.datetimeLocal: return 'datetime-local';
      case InputType.color:         return 'color';
    }
  }

  void _applyTypeHints() {
    switch (inputType) {
      case InputType.number:
        _input.setAttribute('inputmode', (step != null && step != 1 && step != 0) ? 'decimal' : 'numeric');
        if (min != null) _input.setAttribute('min', '$min');
        if (max != null) _input.setAttribute('max', '$max');
        if (step != null) _input.setAttribute('step', '$step');
        break;
      case InputType.email:
        _input.setAttribute('inputmode', 'email');
        _input.setAttribute('autocomplete', decoration.autocomplete ?? 'email');
        break;
      case InputType.password:
        _input.setAttribute('autocomplete', decoration.autocomplete ?? 'current-password');
        break;
      case InputType.search:
        _input.setAttribute('inputmode', 'search');
        break;
      case InputType.tel:
        _input.setAttribute('inputmode', 'tel');
        break;
      case InputType.url:
        _input.setAttribute('autocomplete', decoration.autocomplete ?? 'url');
        break;
      case InputType.date:
      case InputType.time:
      case InputType.month:
      case InputType.week:
      case InputType.datetimeLocal:
      case InputType.text:
      case InputType.color:
        if (decoration.autocomplete != null) {
          _input.setAttribute('autocomplete', decoration.autocomplete!);
        }
        break;
    }
  }

  // --- Bordures par état ---
  void _applyBorder() {
    final b = _effectiveBorder();
    b.applyTo(_wrap);
  }

  InputBorder _effectiveBorder() {
    if (!enabled) {
      return decoration.disabledBorder
          ?? decoration.enabledBorder
          ?? decoration.border
          ?? _borderFromVariant(disabled: true);
    }
    final hasError = decoration.errorText != null && decoration.errorText!.isNotEmpty;
    if (hasError) {
      return decoration.errorBorder
          ?? decoration.focusedBorder
          ?? decoration.enabledBorder
          ?? decoration.border
          ?? _borderFromVariant(error: true);
    }
    if (_isFocused) {
      return decoration.focusedBorder
          ?? decoration.enabledBorder
          ?? decoration.border
          ?? _borderFromVariant(focused: true);
    }
    return decoration.enabledBorder
        ?? decoration.border
        ?? _borderFromVariant();
  }

  InputBorder _borderFromVariant({bool focused = false, bool error = false, bool disabled = false}) {
    final color = error
        ? errorColor
        : disabled
            ? disabledColor
            : (focused ? focusColor : borderColor);

    switch (variant) {
      case InputVariant.outline:
        return OutlineInputBorder(
          borderRadius: decoration.borderRadius ?? borderRadius,
          borderSide: BorderSide(color: color.color, width: 1),
        );
      case InputVariant.underline:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color.color, width: 1),
        );
      case InputVariant.filled:
        final c = (focused || error) ? color.color : 'transparent';
        return OutlineInputBorder(
          borderRadius: decoration.borderRadius ?? borderRadius,
          borderSide: BorderSide(color: c, width: 1),
        );
    }
  }

  // --- tokens CSS ---
  String _v(InputVariant v) => switch (v) { InputVariant.outline => 'outline', InputVariant.underline => 'underline', InputVariant.filled => 'filled' };
  String _s(FieldSize s)   => switch (s) { FieldSize.small => 'sm', FieldSize.medium => 'md', FieldSize.large => 'lg' };

String _biconToString(Bicon icon) => BsIcon(icon: icon).create().outerHtml!;
  // --- CSS injecté 1x ---
  static bool _cssInjected = false;
  static void _ensureCss() {
    if (_cssInjected) return;
    _cssInjected = true;
    final style = StyleElement()
      ..id = 'rdx-tf-styles'
      ..text = '''
/* Container */
.rdx-tf{ display:block; font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; }

/* Wrap: fond + rayon gérés via vars; bordure appliquée inline par InputBorder */
.rdx-field{ background: var(--tf-fill); border-radius: var(--tf-radius); }

/* Variants (ne gèrent plus la bordure, uniquement aspects généraux) */
.rdx-tf.rdx-underline .rdx-field{ border-radius: 0; }

/* Grid zones */
.rdx-field{ display:grid; grid-template-columns:auto 1fr auto; align-items:center; }
.rdx-side{ display:inline-flex; align-items:center; gap:6px; padding:0 6px; }
.rdx-center{ position:relative; }

/* Input */
.rdx-input{
  width:100%; background:transparent; border:0; outline:none;
  color:var(--tf-text); font-size:14px; transition: background .12s ease, color .12s ease;
}
.rdx-tf.rdx-sm .rdx-input{ font-size:13px; }
.rdx-tf.rdx-lg .rdx-input{ font-size:16px; }
.rdx-input::placeholder{ color: transparent; }

/* Label flottant */
.rdx-label{
  position:absolute; left:12px; top:50%; transform:translateY(-50%);
  color:var(--tf-hint); pointer-events:none; transition: all .12s ease;
  background: transparent; padding:0 4px;
}
.rdx-tf.rdx-sm .rdx-label{ left:10px; }
.rdx-tf.rdx-lg .rdx-label{ left:14px; }

/* Label up */
.rdx-tf.is-focused .rdx-label,
.rdx-tf.has-value .rdx-label{
  top:4px; transform:none; font-size:11px; color:var(--tf-focus);
}

/* Affixes & buttons */
.rdx-affix{ color: var(--tf-hint); display:inline-flex; align-items:center; }
.rdx-icon-btn{
  display:inline-flex; align-items:center; justify-content:center;
  width:28px; height:28px; border:0; background:transparent; color:var(--tf-hint);
  border-radius:6px; cursor:pointer;
}
.rdx-icon-btn:hover{ background: rgba(0,0,0,.06); }

/* Meta (helper + counter) */
.rdx-meta{ display:flex; justify-content:space-between; align-items:center; margin-top:6px; }
.rdx-helper{ font-size:12px; color:#6b7280; }
.rdx-helper.is-error{ color: var(--tf-error); }
.rdx-counter{ font-size:12px; color:#6b7280; }
.rdx-counter.is-over{ color: var(--tf-error); }

/* Disabled */
.rdx-tf.is-disabled{ opacity:.6; }
.rdx-tf.is-disabled .rdx-input{ cursor:not-allowed; }
''';
    document.head?.append(style);
  }
}

/// ------------------------------------------------------------------
/// 3) TextField sans Bootstrap (utilise InputType + InputDecoration)
/// ------------------------------------------------------------------
// class TextField extends Relement {
//   final TextEditingController controller;

//   // Logique
//   final InputType inputType;
//   final bool enabled;
//   final bool readOnly;

//   // Style global
//   final InputVariant variant;
//   final FieldSize size;

//   // Décoration regroupée
//   final InputDecoration decoration;

//   // Thème (CSS vars; override par decoration si défini)
//   final Color baseFillColor;
//   final Color borderColor;
//   final Color focusColor;
//   final Color errorColor;
//   final Color textColor;
//   final Color hintColor;
//   final Color disabledColor;
//   final double borderRadius; // défaut si decoration.borderRadius == null

//   // Nombre (spécialisation facultative)
//   final num? min;
//   final num? max;
//   final num? step;

//   // Callbacks
//   final void Function(String value)? onChanged;
//   final void Function(String value)? onSubmitted;

//   TextField({
//     required this.controller,
//     this.inputType = InputType.text,
//     this.enabled = true,
//     this.readOnly = false,
//     this.variant = InputVariant.outline,
//     this.size = FieldSize.medium,
//     this.decoration = const InputDecoration(),

//     // Thème
//     this.baseFillColor = const Color('#f8f9fb'),
//     this.borderColor = const Color('rgba(0,0,0,.20)'),
//     this.focusColor = const Color('#0d6efd'),
//     this.errorColor = const Color('#dc3545'),
//     this.textColor = const Color('#0f172a'),
//     this.hintColor = const Color('#94a3b8'),
//     this.disabledColor = const Color('rgba(0,0,0,.38)'),
//     this.borderRadius = 10,

//     // number/date: bornes
//     this.min,
//     this.max,
//     this.step,

//     this.onChanged,
//     this.onSubmitted,
//     super.id,
//   });

//   final DivElement _root = DivElement();
//   final DivElement _wrap = DivElement();
//   final DivElement _left = DivElement(); // prefix zone
//   final DivElement _right = DivElement(); // suffix zone
//   final InputElement _input = InputElement();
//   final LabelElement _label = LabelElement();
//   final DivElement _helper = DivElement();
//   final DivElement _counter = DivElement();
//   final ButtonElement _clearBtn = ButtonElement();
//   final ButtonElement _eyeBtn = ButtonElement();

//   bool _obscuredRuntime = false;

//   @override
//   Element create() {
//     _ensureCss();

//     _obscuredRuntime = (inputType == InputType.password);

//     _root
//       ..id = id ?? 'tf-${DateTime.now().microsecondsSinceEpoch}'
//       ..classes.addAll(['rdx-tf', 'rdx-${_v(variant)}', 'rdx-${_s(size)}']);
//     if (!enabled) _root.classes.add('is-disabled');
//     if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
//       _root.classes.add('is-error');
//     }

//     // CSS vars (couleurs/paddings)
//     final fill =
//         decoration.filled
//             ? (decoration.fillColor ?? baseFillColor.color)
//             : 'transparent';

//     _root.style
//       ..setProperty('--tf-fill', fill)
//       ..setProperty('--tf-border', borderColor.color)
//       ..setProperty('--tf-focus', focusColor.color)
//       ..setProperty('--tf-error', errorColor.color)
//       ..setProperty('--tf-text', textColor.color)
//       ..setProperty('--tf-hint', hintColor.color)
//       ..setProperty('--tf-disabled', disabledColor.color)
//       ..setProperty(
//         '--tf-radius',
//         '${(decoration.borderRadius ?? borderRadius)}px',
//       );

//     _wrap
//       ..classes.add('rdx-field')
//       ..style.display = 'grid'
//       ..style.gridTemplateColumns = 'auto 1fr auto'
//       ..style.alignItems = 'center';

//     // LEFT (prefix icon/text)
//     _left.classes.add('rdx-side');
//     if (decoration.prefixIcon != null) {
//       final icon =
//           SpanElement()
//             ..classes.add('rdx-affix')
//             ..setInnerHtml(
//               decoration.prefixIcon!.create().outerHtml,
//               treeSanitizer: NodeTreeSanitizer.trusted,
//             );
//       _left.children.add(icon);
//       _root.classes.add('has-prefix');
//     }
//     if (decoration.prefixText != null && decoration.prefixText!.isNotEmpty) {
//       _left.children.add(
//         SpanElement()
//           ..classes.add('rdx-affix')
//           ..text = decoration.prefixText!,
//       );
//       _root.classes.add('has-prefix');
//     }

//     // INPUT
//     _input
//       ..className = 'rdx-input'
//       ..placeholder =
//           ' ' // pour le label flottant via :placeholder-shown
//       ..value = controller.text
//       ..readOnly = readOnly
//       ..disabled = !enabled
//       ..type = _effectiveHtmlType();
//     _applyTypeHints(); // inputmode/autocomplete/min/max/step

//     // Content padding
//     final pad =
//         decoration.contentPadding ??
//         (size == FieldSize.small
//             ? EdgeInsets.symmetric(vertical: 10, horizontal: 10)
//             : size == FieldSize.large
//             ? EdgeInsets.symmetric(vertical: 14, horizontal: 14)
//             : EdgeInsets.symmetric(vertical: 12, horizontal: 12));
//     _input.style.padding = pad.toCss();
//     _input.style.color = 'var(--tf-text)';

//     // Events
//     _input.onInput.listen((_) {
//       var val = _input.value ?? '';
//       // maxLength → tronquer & MAJ input si dépassement
//       if (decoration.maxLength != null && val.length > decoration.maxLength!) {
//         val = val.substring(0, decoration.maxLength!);
//         _input.value = val;
//       }
//       controller.text = val;
//       _refreshHasValue();
//       _updateCounter();
//       _maybeToggleClear();
//       onChanged?.call(val);
//     });
//     _input.onFocus.listen((_) => _root.classes.add('is-focused'));
//     _input.onBlur.listen((_) => _root.classes.remove('is-focused'));
//     _input.onKeyDown.listen((e) {
//       if (e.key == 'Enter') onSubmitted?.call(_input.value ?? '');
//     });

//     controller.addListener(() {
//       if (_input.value != controller.text) {
//         _input.value = controller.text;
//         _refreshHasValue();
//         _updateCounter();
//         _maybeToggleClear();
//       }
//     });

//     // RIGHT (suffix + buttons)
//     _right.classes.add('rdx-side');

//     // clear button
//     if (decoration.showClearButton) {
//       _clearBtn
//         ..type = 'button'
//         ..className = 'rdx-icon-btn rdx-clear'
//         ..setInnerHtml('✕', treeSanitizer: NodeTreeSanitizer.trusted)
//         ..title = 'Effacer';
//       _clearBtn.onClick.listen((_) {
//         controller.text = '';
//         onChanged?.call('');
//         _input.focus();
//       });
//       _right.children.add(_clearBtn);
//     }

//     // eye button (password)
//     final passwordCapable =
//         decoration.showPasswordToggle && (inputType == InputType.password);
//     if (passwordCapable) {
//       _eyeBtn
//         ..type = 'button'
//         ..className = 'rdx-icon-btn rdx-eye'
//         ..title = 'Afficher/masquer';
//       _renderEye();
//       _eyeBtn.onClick.listen((_) {
//         _obscuredRuntime = !_obscuredRuntime;
//         _input.type = _effectiveHtmlType();
//         _renderEye();
//         _input.focus();
//       });
//       _right.children.add(_eyeBtn);
//       _root.classes.add('has-eye');
//     }

//     // suffix icon/text
//     if (decoration.suffixIcon != null) {
//       final icon =
//           SpanElement()
//             ..classes.add('rdx-affix')
//             ..setInnerHtml(
//               decoration.suffixIcon!.create().outerHtml,
//               treeSanitizer: NodeTreeSanitizer.trusted,
//             );
//       _right.children.add(icon);
//       _root.classes.add('has-suffix');
//     }
//     if (decoration.suffixText != null && decoration.suffixText!.isNotEmpty) {
//       _right.children.add(
//         SpanElement()
//           ..classes.add('rdx-affix')
//           ..text = decoration.suffixText!,
//       );
//       _root.classes.add('has-suffix');
//     }

//     // label flottant
//     if (decoration.labelText != null && decoration.labelText!.isNotEmpty) {
//       _label
//         ..className = 'rdx-label'
//         ..text = decoration.labelText!;
//     }

//     // helper / error + counter
//     _helper.className = 'rdx-helper';
//     if (decoration.errorText != null && decoration.errorText!.isNotEmpty) {
//       _helper.text = decoration.errorText!;
//       _helper.classes.add('is-error');
//     } else if (decoration.helperText != null &&
//         decoration.helperText!.isNotEmpty) {
//       _helper.text = decoration.helperText!;
//     }

//     _counter.className = 'rdx-counter';
//     _updateCounter(); // init

//     // Assemble
//     _wrap.children
//       ..clear()
//       ..addAll([
//         _left, // col 1
//         DivElement() // col 2 wrapper (input + label)
//           ..classes.add('rdx-center')
//           ..children.addAll([_input, if (decoration.labelText != null) _label]),
//         _right, // col 3
//       ]);

//     _root.children
//       ..clear()
//       ..addAll([
//         _wrap,
//         DivElement()
//           ..classes.add('rdx-meta')
//           ..children.addAll([_helper, _counter]),
//       ]);

//     // États initiaux
//     _refreshHasValue();
//     _maybeToggleClear();

//     return _root;
//   }

//   @override
//   Element get getElement => _root;

//   // -------------------- Helpers --------------------
//   void _updateCounter() {
//     if (decoration.maxLength == null && decoration.counterText == null) {
//       _counter.style.display = 'none';
//       return;
//     }
//     _counter.style.display = 'block';
//     if (decoration.counterText != null) {
//       _counter.text = decoration.counterText!;
//     } else {
//       final len = (controller.text).length;
//       _counter.text = '$len/${decoration.maxLength}';
//       _counter.classes.toggle(
//         'is-over',
//         decoration.maxLength != null && len > decoration.maxLength!,
//       );
//     }
//   }

//   void _refreshHasValue() {
//     final has = (_input.value ?? '').isNotEmpty;
//     _root.classes.toggle('has-value', has);
//     // Hint (data-hint) → on l’affiche en style when no value & not focused
//     if (decoration.hintText != null) {
//       _input.dataset['hint'] = decoration.hintText!;
//     }
//   }

//   void _maybeToggleClear() {
//     if (!decoration.showClearButton) return;
//     final show = enabled && (_input.value ?? '').isNotEmpty && !readOnly;
//     _clearBtn.style.display = show ? 'inline-flex' : 'none';
//   }

//   void _renderEye() {
//     _eyeBtn.setInnerHtml(
//       _obscuredRuntime
//           ? BsIcon(icon: Bicon.eye).create().outerHtml
//           : BsIcon(icon: Bicon.eyeSlash).create().outerHtml,
//       treeSanitizer: NodeTreeSanitizer.trusted,
//     );
//   }

//   String _effectiveHtmlType() {
//     if (_obscuredRuntime) return 'password';
//     switch (inputType) {
//       case InputType.text:
//         return 'text';
//       case InputType.email:
//         return 'email';
//       case InputType.number:
//         return 'text'; // on force text + inputmode=decimal pour un meilleur contrôle
//       case InputType.password:
//         return 'password';
//       case InputType.search:
//         return 'search';
//       case InputType.tel:
//         return 'tel';
//       case InputType.url:
//         return 'url';
//       case InputType.date:
//         return 'date';
//       case InputType.time:
//         return 'time';
//       case InputType.month:
//         return 'month';
//       case InputType.week:
//         return 'week';
//       case InputType.datetimeLocal:
//         return 'datetime-local';
//       case InputType.color:
//         return 'color';
//     }
//   }

//   void _applyTypeHints() {
//     // inputmode / autocomplete / min-max-step
//     switch (inputType) {
//       case InputType.number:
//         // Meilleure UX mobile: clavier numérique/decimal
//         _input.setAttribute(
//           'inputmode',
//           (step != null && step != 1 && step != 0) ? 'decimal' : 'numeric',
//         );
//         if (min != null) _input.setAttribute('min', '$min');
//         if (max != null) _input.setAttribute('max', '$max');
//         if (step != null) _input.setAttribute('step', '$step');
//         break;
//       case InputType.email:
//         _input.setAttribute('inputmode', 'email');
//         _input.setAttribute('autocomplete', decoration.autocomplete ?? 'email');
//         break;
//       case InputType.password:
//         _input.setAttribute(
//           'autocomplete',
//           decoration.autocomplete ?? 'current-password',
//         );
//         break;
//       case InputType.search:
//         _input.setAttribute('inputmode', 'search');
//         break;
//       case InputType.tel:
//         _input.setAttribute('inputmode', 'tel');
//         break;
//       case InputType.url:
//         _input.setAttribute('autocomplete', decoration.autocomplete ?? 'url');
//         break;
//       case InputType.date:
//       case InputType.time:
//       case InputType.month:
//       case InputType.week:
//       case InputType.datetimeLocal:
//       case InputType.text:
//       case InputType.color:
//         // rien de spécial
//         if (decoration.autocomplete != null) {
//           _input.setAttribute('autocomplete', decoration.autocomplete!);
//         }
//         break;
//     }
//   }

//   String _v(InputVariant v) => switch (v) {
//     InputVariant.outline => 'outline',
//     InputVariant.underline => 'underline',
//     InputVariant.filled => 'filled',
//   };
//   String _s(FieldSize s) => switch (s) {
//     FieldSize.small => 'sm',
//     FieldSize.medium => 'md',
//     FieldSize.large => 'lg',
//   };

//   // CSS (injecté 1x)
//   static bool _cssInjected = false;
//   static void _ensureCss() {
//     if (_cssInjected) return;
//     _cssInjected = true;
//     final style =
//         StyleElement()
//           ..id = 'rdx-tf-styles'
//           ..text = '''
// /* Container */
// .rdx-tf{ display:block; font-family: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial; }
// .rdx-field{ background: var(--tf-fill); border-radius: var(--tf-radius); }

// /* Variants */
// .rdx-tf.rdx-outline .rdx-field{ border:1px solid var(--tf-border); }
// .rdx-tf.rdx-outline.is-focused .rdx-field{ border-color: var(--tf-focus); box-shadow: 0 0 0 3px color-mix(in srgb, var(--tf-focus) 20%, transparent); }
// .rdx-tf.rdx-outline.is-error   .rdx-field{ border-color: var(--tf-error); box-shadow: 0 0 0 3px color-mix(in srgb, var(--tf-error) 15%, transparent); }

// .rdx-tf.rdx-underline .rdx-field{ border-bottom:1px solid var(--tf-border); border-radius: 0; }
// .rdx-tf.rdx-underline.is-focused .rdx-field{ border-bottom-color: var(--tf-focus); }
// .rdx-tf.rdx-underline.is-error   .rdx-field{ border-bottom-color: var(--tf-error); }

// .rdx-tf.rdx-filled .rdx-field{ border:1px solid transparent; }
// .rdx-tf.rdx-filled.is-focused .rdx-field{ border-color: var(--tf-focus); }
// .rdx-tf.rdx-filled.is-error   .rdx-field{ border-color: var(--tf-error); }

// /* Grid zones */
// .rdx-field{ display:grid; grid-template-columns:auto 1fr auto; align-items:center; }
// .rdx-side{ display:inline-flex; align-items:center; gap:6px; padding:0 6px; }
// .rdx-center{ position:relative; }

// /* Input */
// .rdx-input{
//   width:100%; background:transparent; border:0; outline:none;
//   color:var(--tf-text); font-size:14px; transition: background .12s ease, color .12s ease;
// }
// .rdx-tf.rdx-sm .rdx-input{ font-size:13px; }
// .rdx-tf.rdx-lg .rdx-input{ font-size:16px; }
// .rdx-input::placeholder{ color: transparent; }

// /* Label flottant */
// .rdx-label{
//   position:absolute; left:12px; top:50%; transform:translateY(-50%);
//   color:var(--tf-hint); pointer-events:none; transition: all .12s ease;
//   background: transparent; padding:0 4px;
// }
// .rdx-tf.rdx-sm .rdx-label{ left:10px; }
// .rdx-tf.rdx-lg .rdx-label{ left:14px; }

// /* Label up */
// .rdx-tf.is-focused .rdx-label,
// .rdx-tf.has-value .rdx-label{
//   top:4px; transform:none; font-size:11px; color:var(--tf-focus);
// }

// /* Affixes & buttons */
// .rdx-affix{ color: var(--tf-hint); display:inline-flex; align-items:center; }
// .rdx-icon-btn{
//   display:inline-flex; align-items:center; justify-content:center;
//   width:28px; height:28px; border:0; background:transparent; color:var(--tf-hint);
//   border-radius:6px; cursor:pointer;
// }
// .rdx-icon-btn:hover{ background: rgba(0,0,0,.06); }

// /* Meta (helper + counter) */
// .rdx-meta{ display:flex; justify-content:space-between; align-items:center; margin-top:6px; }
// .rdx-helper{ font-size:12px; color:#6b7280; }
// .rdx-helper.is-error{ color: var(--tf-error); }
// .rdx-counter{ font-size:12px; color:#6b7280; }
// .rdx-counter.is-over{ color: var(--tf-error); }

// /* Disabled */
// .rdx-tf.is-disabled{ opacity:.6; }
// .rdx-tf.is-disabled .rdx-input{ cursor:not-allowed; }
// ''';
//     document.head?.append(style);
//   }
// }

