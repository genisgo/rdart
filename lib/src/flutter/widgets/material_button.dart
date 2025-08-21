part of 'widgets.dart';

/// ============================================================================
/// MaterialButton – Flutter-like, sans classes Bootstrap
/// ============================================================================

enum IconPosition { leading, trailing }

class MaterialButton extends Relement {
  // Contenu
  final String label;
  final BsIcon? icon;
  final IconPosition iconPosition;
  final double iconGap;

  // Actions
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool loading;

  // Styles
  final MaterialColor backgroundColor;
  final MaterialColor foregroundColor;
  final MaterialColor disabledBackgroundColor;
  final MaterialColor disabledForegroundColor;
  final MaterialColor? borderColor;
  final double borderWidth;
  final double borderRadius;
  final int elevation; // 0..40
  final bool fullWidth;
  final ButtonSize size;

  // Effets
  final Color? overlayColor; // couleur de l’onde/ripple/hover

  MaterialButton({
    required this.label,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.iconGap = 8,
    this.onPressed,
    this.tooltip,
    this.loading = false,
    this.backgroundColor = const MaterialColor(
      29,
      78,
      216,
    ), // bleu app (pas bootstrap)
    this.foregroundColor = const MaterialColor(255, 255, 255),
    MaterialColor? disabledBackgroundColor,
    MaterialColor? disabledForegroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.elevation = 2,
    this.fullWidth = false,
    this.size = ButtonSize.medium,
    this.overlayColor,
    super.id,
  }) : disabledBackgroundColor =
           disabledBackgroundColor ?? const MaterialColor(229, 231, 235),
       disabledForegroundColor =
           disabledForegroundColor ?? const MaterialColor(156, 163, 175);

  // DOM
  final ButtonElement _btn = ButtonElement();
  final SpanElement _labelEl = SpanElement();
  Element? _iconEl;

  bool get _enabled => onPressed != null && !loading;

  @override
  Element create() {
    _ensureCssMaterialButton();

    _btn
      ..id = id ?? 'mb-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('mb')
      ..title = tooltip ?? ''
      ..disabled = !_enabled
      ..style.setProperty('--mb-radius', '${borderRadius}px')
      ..style.setProperty('--mb-shadow', _shadowFor(elevation))
      ..style.setProperty('--mb-bg', backgroundColor.color)
      ..style.setProperty('--mb-fg', foregroundColor.color)
      ..style.setProperty('--mb-bg-dis', disabledBackgroundColor.color)
      ..style.setProperty('--mb-fg-dis', disabledForegroundColor.color)
      ..style.setProperty(
        '--mb-overlay',
        (overlayColor ?? (foregroundColor as MaterialColor).withAlpha(0.14))
            .color,
      );

    if (borderColor != null && borderWidth > 0) {
      _btn.style.setProperty(
        '--mb-border',
        '${borderWidth}px solid ${borderColor!.color}',
      );
    } else {
      _btn.style.setProperty('--mb-border', '1px solid transparent');
    }

    // Taille
    switch (size) {
      case ButtonSize.small:
        _btn.classes.add('sm');
        break;
      case ButtonSize.medium:
        _btn.classes.add('md');
        break;
      case ButtonSize.large:
        _btn.classes.add('lg');
        break;
    }

    if (fullWidth) _btn.style.width = '100%';

    // Contenu
    _labelEl
      ..classes.add('mb-label')
      ..text = label;

    final content = <Element>[];
    if (icon != null && iconPosition == IconPosition.leading) {
      _iconEl = icon!.create();
      _iconEl!.classes.add('mb-icon');
      content.add(_iconEl!);
    }
    content.add(_labelEl);
    if (icon != null && iconPosition == IconPosition.trailing) {
      _iconEl = icon!.create();
      _iconEl!.classes.add('mb-icon');
      content.add(SpanElement()..style.width = '${iconGap}px');
      content.add(_iconEl!);
    }

    // gap automatique si icône leading
    if (icon != null && iconPosition == IconPosition.leading) {
      content.insert(1, SpanElement()..style.width = '${iconGap}px');
    }

    _btn.children
      ..clear()
      ..addAll(content);

    // Interaction
    if (_enabled) {
      _btn.onClick.listen((e) {
        _spawnRipple(e);
        onPressed?.call();
      });
    }

    // Loading state
    if (loading) {
      final spinner = _buildSpinner();
      _btn.classes.add('loading');
      _btn.children
        ..clear()
        ..add(spinner)
        ..add(
          SpanElement()
            ..classes.add('sr-only')
            ..text = label,
        );
    }

    return _btn;
  }

  @override
  Element get getElement => _btn;

  void setLoading(bool isLoading) {
    if (isLoading == loading) return;
    // (si tu veux, reconstruis le bouton en réappelant create())
  }

  // Ripple minimaliste
  void _spawnRipple(MouseEvent e) {
    final rect = _btn.getBoundingClientRect();
    final size = (rect.width > rect.height ? rect.width : rect.height) * 1.2;
    final ripple =
        SpanElement()
          ..classes.add('mb-ripple')
          ..style.width = '${size}px'
          ..style.height = '${size}px'
          ..style.left = '${e.client.x - rect.left - size / 2}px'
          ..style.top = '${e.client.y - rect.top - size / 2}px';
    _btn.append(ripple);
    Future.delayed(Duration(milliseconds: 450), () {
      ripple.remove();
    });
  }

  Element _buildSpinner() {
    final sp = SpanElement()..classes.add('mb-spinner');
    return sp;
  }

  static String _shadowFor(int elevation) {
    final e = elevation.clamp(0, 40);
    if (e <= 0) return 'none';
    if (e <= 2) return '0 1px 2px rgba(0,0,0,.12), 0 1px 1px rgba(0,0,0,.06)';
    if (e <= 6)
      return '0 10px 15px -3px rgba(0,0,0,.1), 0 4px 6px -4px rgba(0,0,0,.1)';
    if (e <= 12)
      return '0 20px 25px -5px rgba(0,0,0,.1), 0 10px 10px -5px rgba(0,0,0,.04)';
    return '0 25px 50px -12px rgba(0,0,0,.25)';
  }
}

/// ============================================================================
/// CSS (injecté 1x)
/// ============================================================================
bool _cssInjected = false;
void _ensureCssMaterialButton() {
  if (_cssInjected) return;
  _cssInjected = true;
  final style =
      StyleElement()
        ..id = 'material-button-styles'
        ..text = '''
.mb{ position:relative; display:inline-flex; align-items:center; justify-content:center; gap:0; cursor:pointer;
     border-radius: var(--mb-radius, 12px); border: var(--mb-border, 1px solid transparent);
     background: var(--mb-bg, rgba(29,78,216,1)); color: var(--mb-fg, #fff);
     box-shadow: var(--mb-shadow, none); transition: filter .12s ease, box-shadow .12s ease, transform .02s ease; }

.mb.sm{ padding: 8px 12px; font-size: 13px; }
.mb.md{ padding: 10px 14px; font-size: 14px; }
.mb.lg{ padding: 12px 18px; font-size: 16px; }

.mb:disabled, .mb[disabled]{ cursor:not-allowed; background: var(--mb-bg-dis, #e5e7eb); color: var(--mb-fg-dis, #9ca3af); box-shadow: none; }

.mb:hover:not(:disabled){ filter: brightness(0.98); }
.mb:active:not(:disabled){ transform: translateY(0.5px); }

.mb .mb-icon{ display:inline-flex; align-items:center; }
.mb .mb-label{ line-height: 1; }

/* Ripple */
.mb{ overflow:hidden; }
.mb .mb-ripple{
  position:absolute; border-radius:50%; background: var(--mb-overlay, rgba(255,255,255,.14)); transform: scale(0);
  animation: mb-ripple .45s ease-out forwards;
}
@keyframes mb-ripple { to { transform: scale(1); opacity: 0; } }

/* Spinner minimal pour l'état loading */
.mb.loading{ pointer-events:none; }
.mb-spinner{ width:18px; height:18px; border-radius:999px; border:2px solid rgba(255,255,255,.4); border-top-color: currentColor; display:inline-block; animation: mb-spin .7s linear infinite; }
@keyframes mb-spin { to { transform: rotate(360deg); } }

/* accessibilité */
.sr-only{ position:absolute; width:1px; height:1px; padding:0; margin:-1px; overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }
''';
  document.head?.append(style);
}

