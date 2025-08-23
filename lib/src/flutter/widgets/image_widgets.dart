part of 'widgets.dart';

// ============================================================================
// Enums utilitaires (mimic Flutter)
// ============================================================================
enum BoxFit { fill, contain, cover, none, scaleDown }

String _fitToCss(BoxFit fit) {
  switch (fit) {
    case BoxFit.fill:
      return 'fill';
    case BoxFit.contain:
      return 'contain';
    case BoxFit.cover:
      return 'cover';
    case BoxFit.none:
      return 'none';
    case BoxFit.scaleDown:
      return 'scale-down';
  }
}

enum AlignmentPreset {
  center,
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

String _alignToCss(AlignmentPreset a) {
  switch (a) {
    case AlignmentPreset.center:
      return '50% 50%';
    case AlignmentPreset.topLeft:
      return '0% 0%';
    case AlignmentPreset.topCenter:
      return '50% 0%';
    case AlignmentPreset.topRight:
      return '100% 0%';
    case AlignmentPreset.centerLeft:
      return '0% 50%';
    case AlignmentPreset.centerRight:
      return '100% 50%';
    case AlignmentPreset.bottomLeft:
      return '0% 100%';
    case AlignmentPreset.bottomCenter:
      return '50% 100%';
    case AlignmentPreset.bottomRight:
      return '100% 100%';
  }
}

enum ImageRepeat { noRepeat, repeat, repeatX, repeatY }

String _repeatToCss(ImageRepeat r) {
  switch (r) {
    case ImageRepeat.noRepeat:
      return 'no-repeat';
    case ImageRepeat.repeat:
      return 'repeat';
    case ImageRepeat.repeatX:
      return 'repeat-x';
    case ImageRepeat.repeatY:
      return 'repeat-y';
  }
}

// ============================================================================
// Image — Flutter-like API (network / asset / memory), web-friendly
// ============================================================================
class Image extends Relement {
  final String src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentPreset alignment;
  final ImageRepeat repeat;
  final double?
  borderRadius; // clip arrondi rapide (sinon utilise Container externe)
  final bool clipOval; // si true -> cercle/ellipse
  final String? alt;
  final bool draggable;
  final bool lazy; // loading='lazy'
  final bool fadeIn; // animer opacité onLoad
  final int fadeInMs;
  final void Function()? onLoad;
  final void Function()? onError;
  final Relement? placeholder; // affiché tant que l'image n'est pas chargée
  final Relement? errorWidget; // affiché si onError

  // Note: pour asset, passe un chemin relatif/absolu servi par ton appli web.
  Image.network(
    String url, {
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = AlignmentPreset.center,
    this.repeat = ImageRepeat.noRepeat,
    this.borderRadius,
    this.clipOval = false,
    this.alt,
    this.draggable = false,
    this.lazy = true,
    this.fadeIn = true,
    this.fadeInMs = 180,
    this.onLoad,
    this.onError,
    this.placeholder,
    this.errorWidget,
    super.id,
  }) : src = url;

  Image.asset(
    String path, {
    String? baseUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = AlignmentPreset.center,
    this.repeat = ImageRepeat.noRepeat,
    this.borderRadius,
    this.clipOval = false,
    this.alt,
    this.draggable = false,
    this.lazy = true,
    this.fadeIn = true,
    this.fadeInMs = 180,
    this.onLoad,
    this.onError,
    this.placeholder,
    this.errorWidget,
    super.id,
  }) : src =
           baseUrl == null
               ? path
               : (baseUrl.endsWith('/')
                   ? baseUrl + path
                   : baseUrl + '/' + path);

  Image.memory(
    typed.Uint8List bytes, {
    String mimeType = 'image/png',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = AlignmentPreset.center,
    this.repeat = ImageRepeat.noRepeat,
    this.borderRadius,
    this.clipOval = false,
    this.alt,
    this.draggable = false,
    this.lazy = true,
    this.fadeIn = true,
    this.fadeInMs = 180,
    this.onLoad,
    this.onError,
    this.placeholder,
    this.errorWidget,
    super.id,
  }) : src = 'data:' + mimeType + ';base64,' + conv.base64Encode(bytes);

  // DOM refs
  final DivElement _root = DivElement();
  Element? _content; // img ou div bg
  bool _loaded = false;

  @override
  Element create() {
    _root.children.clear();
    _root.style
      ..display = 'inline-block'
      ..position = 'relative'
      ..overflow =
          (clipOval || (borderRadius != null && borderRadius! > 0))
              ? 'hidden'
              : ''
      ..borderRadius =
          clipOval
              ? '9999px'
              : (borderRadius != null ? '${borderRadius}px' : '');

    if (width != null) _root.style.width = '${width}px';
    if (height != null) _root.style.height = '${height}px';

    // Placeholder si fourni
    if (placeholder != null && !_loaded) {
      final ph = DivElement()..style.position = 'absolute';
      //..style.inset = '0';
      ph.children.add(placeholder!.create());
      _root.children.add(ph);
    }

    // Si on veut répéter, on utilise background-image (img ne répète pas)
    if (repeat != ImageRepeat.noRepeat) {
      final div =
          DivElement()
            ..style.position = 'relative'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.backgroundImage = 'url("$src")'
            ..style.backgroundRepeat = _repeatToCss(repeat)
            ..style.backgroundPosition = _alignToCss(alignment)
            ..style.backgroundSize = _fitToCss(fit);
      _content = div;
    } else {
      final img =
          ImageElement(src: src)
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.objectFit = _fitToCss(fit)
            ..style.objectPosition = _alignToCss(alignment)
            ..draggable = draggable
            ..alt = alt ?? '';
      if (lazy) img.async = 'lazy';

      if (fadeIn) {
        img.style.opacity = '0';
        img.style.transition = 'opacity ${fadeInMs}ms ease';
      }

      img.onLoad.first.then((_) {
        _loaded = true;
        // Retire le placeholder si présent
        if (_root.children.isNotEmpty && placeholder != null) {
          _root.children.first.remove();
        }
        if (fadeIn) img.style.opacity = '1';
        onLoad?.call();
      });
      img.onError.first.then((_) {
        if (placeholder != null) {
          // on garde le placeholder
        } else if (errorWidget != null) {
          _root.children
            ..clear()
            ..add(errorWidget!.create());
        }
        onError?.call();
      });

      _content = img;
    }

    _root.children.add(_content!);
    return _root;
  }

  @override
  Element get getElement => _root;
}

// ============================================================================
// FadeInImage — crossfade placeholder → image (réseau/asset/mémoire)
// ============================================================================
class FadeInImage extends Relement {
  final Relement placeholder;
  final String imageUrl; // (utiliser data:... pour mémoire si besoin)
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentPreset alignment;
  final int durationMs;

  FadeInImage({
    required this.placeholder,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = AlignmentPreset.center,
    this.durationMs = 220,
    super.id,
  });

  final _root = DivElement();

  @override
  Element create() {
    _root.children.clear();
    _root.style
      ..position = 'relative'
      ..display = 'inline-block'
      ..overflow = 'hidden';
    if (width != null) _root.style.width = '${width}px';
    if (height != null) _root.style.height = '${height}px';

    final ph = DivElement()..style.position = 'absolute';
    // ..style.inset = '0';
    ph.children.add(placeholder.create());

    final img =
        ImageElement(src: imageUrl)
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = _fitToCss(fit)
          ..style.objectPosition = _alignToCss(alignment)
          ..style.opacity = '0'
          ..style.transition = 'opacity ${durationMs}ms ease';

    img.onLoad.first.then((_) {
      img.style.opacity = '1';
      Future.delayed(
        Duration(milliseconds: durationMs + 32),
        () => ph.remove(),
      );
    });

    _root.children.addAll([ph, img]);
    return _root;
  }

  @override
  Element get getElement => _root;
}

// ============================================================================
// CircleAvatar — avatar circulaire avec image (ou initiale de repli)
// ============================================================================
class CircleAvatar extends Relement {
  final String? imageUrl; // si null → affiche l'initiale
  final String? initials; // utilisé si pas d'image
  final double radius; // rayon en px
  final Color backgroundColor; // CSS color string
  final Color textColor; // CSS color string
  final double fontSize;

  CircleAvatar({
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.backgroundColor =  const Color( '#e5e7eb'),
    this.textColor = const Color('#111827'),
    double? fontSize,
    super.id,
  }) : fontSize = fontSize ?? (radius * 0.9);

  Element? _el;

  @override
  Element create() {
    final el =
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            color: backgroundColor,
          ),
          child:
              imageUrl != null
                  ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    clipOval: true,
                    width: radius * 2,
                    height: radius * 2,
                    fadeIn: true,
                    fadeInMs: 180,
                  )
                  : _InitialsBadge(
                    text:
                        (initials ?? '').trim().isEmpty
                            ? '?'
                            : initials!.trim(),
                    color: textColor.color,
                    fontSize: fontSize,
                  ),
        ).create();

    _el = el;
    return el;
  }

  @override
  Element get getElement => _el ?? create();
}

class _ImageFill extends Relement {
  final String src;
  _ImageFill(this.src, {required super.id});

  ImageElement? _img;

  @override
  Element create() {
    final img =
        ImageElement(src: src)
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'cover'
          ..draggable = false;
    _img = img;
    return img;
  }

  @override
  Element get getElement => _img ?? create();
}

class _InitialsBadge extends Relement {
  final String text;
  final String color;
  final double fontSize;
  _InitialsBadge({
    required this.text,
    required this.color,
    required this.fontSize,
    super.id,
  });

  DivElement? _root;

  @override
  Element create() {
    final d =
        DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'flex'
          ..style.alignItems = 'center'
          ..style.justifyContent = 'center'
          ..style.color = color
          ..style.fontWeight = '700'
          ..style.fontSize = '${fontSize}px';
    d.text = text.toUpperCase();
    _root = d;
    return d;
  }

  @override
  Element get getElement => _root ?? create();
}
