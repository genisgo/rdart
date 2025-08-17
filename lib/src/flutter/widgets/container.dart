part of 'widgets.dart';

class Container extends Relement {
  final Relement? child;

  final double? width;   // px
  final double? height;  // px

  final EdgeInsets? padding;
  final EdgeInsets? margin;

  final Alignment? alignment;

  final BoxConstraints? constraints;

  final BoxDecoration? decoration;

  /// Quand true, on clip le contenu (utile avec borderRadius)
  final bool clip;

  /// Classes CSS additionnelles (ex: utilitaires Bootstrap)
  final List<String> bootstrap;

  Container({
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.constraints,
    this.decoration,
    this.clip = false,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'container-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-container', ...bootstrap]);

    final s = _root.style;

    // Dimensions directes
    if (width != null) s.width = '${width}px';
    if (height != null) s.height = '${height}px';

    // Marges & Padding
    if (margin != null) s.margin = margin!.toCss();
    if (padding != null) s.padding = padding!.toCss();

    // Contraintes
    constraints?.applyTo(s);

    // Décoration
    decoration?.applyTo(s);

    // Clip
    if (clip) s.overflow = 'hidden';

    // Alignement du child (via flex)
    if (alignment != null) {
      s.display = 'flex';
      s.flexDirection = 'row'; // peu importe, on centre un seul enfant
      s.justifyContent = _justifyFrom(alignment!.x);
      s.alignItems = _alignFrom(alignment!.y);
      if (alignment!.x == AlignX.stretch || alignment!.y == AlignY.stretch) {
        // En cas de stretch, autoriser l'enfant à s'étirer
        // (le child devra avoir width:100%/height:auto selon l'axe)
      }
    }

    // Child
    if (child != null) {
      _root.children.add(child!.create());
      if (alignment != null && (alignment!.x == AlignX.stretch || alignment!.y == AlignY.stretch)) {
        final c = _root.children.last;
        if (alignment!.x == AlignX.stretch) c.style.width = '100%';
        if (alignment!.y == AlignY.stretch) c.style.height = '100%';
      }
    }

    return _root;
  }

  @override
  Element get getElement => _root;

  // ===========================================================
  // Helpers runtime (facultatifs)
  // ===========================================================
  void setChild(Relement? newChild) {
    _root.children.clear();
    if (newChild != null) {
      _root.children.add(newChild.create());
    }
  }

  void setPadding(EdgeInsets? p) {
    if (p == null) {
      _root.style.padding = '';
    } else {
      _root.style.padding = p.toCss();
    }
  }

  void setMargin(EdgeInsets? m) {
    if (m == null) {
      _root.style.margin = '';
    } else {
      _root.style.margin = m.toCss();
    }
  }

  void setSize({double? w, double? h}) {
    if (w != null) _root.style.width = '${w}px';
    if (h != null) _root.style.height = '${h}px';
  }

  void setDecoration(BoxDecoration? d) {
    // On efface d’abord les styles décoratifs courants
    final s = _root.style;
    s.backgroundColor = '';
    s.backgroundImage = '';
    s.backgroundSize = '';
    s.backgroundPosition = '';
    s.backgroundRepeat = '';
    s.border = s.borderTop = s.borderRight = s.borderBottom = s.borderLeft = '';
    s.borderRadius = '';
    s.boxShadow = '';
    // Puis on applique la nouvelle déco
    d?.applyTo(s);
  }

  // ===========================================================
  // Mappings
  // ===========================================================
  String _justifyFrom(AlignX x) {
    switch (x) {
      case AlignX.start: return 'flex-start';
      case AlignX.center: return 'center';
      case AlignX.end: return 'flex-end';
      case AlignX.stretch: return 'stretch'; // peu utilisé en justify-content
    }
  }

  String _alignFrom(AlignY y) {
    switch (y) {
      case AlignY.start: return 'flex-start';
      case AlignY.center: return 'center';
      case AlignY.end: return 'flex-end';
      case AlignY.stretch: return 'stretch';
    }
  }
}