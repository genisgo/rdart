part of 'widgets.dart';
// lib/src/flutter/widgets/pdf_reader.dart

enum PdfBackend { native, pdfjs }

class PdfController {
  void Function(int page)? _setPage;
  void Function(double zoom)? _setZoom;
  void Function()? _zoomIn;
  void Function()? _zoomOut;
  void Function()? _prev;
  void Function()? _next;

  void setPage(int page) => _setPage?.call(page);
  void setZoom(double zoom) => _setZoom?.call(zoom);
  void zoomIn() => _zoomIn?.call();
  void zoomOut() => _zoomOut?.call();
  void previousPage() => _prev?.call();
  void nextPage() => _next?.call();
}

class PdfReader extends Relement {
  final String src;                   // URL/chemin du PDF
  final PdfController? controller;
  final int initialPage;
  final double initialZoom;           // 100 = 100%
  final double? width;
  final double? height;
  final bool showToolbar;
  final bool preventDownload;         // <— NEW
  final PdfBackend backend;           // <— NEW
  final String? pdfJsViewerUrl;       // ex: '/assets/pdfjs/web/viewer.html'

  PdfReader({
    required this.src,
    this.controller,
    this.initialPage = 1,
    this.initialZoom = 100,
    this.width,
    this.height = 600,
    this.showToolbar = true,
    this.preventDownload = false,
    this.backend = PdfBackend.native,
    this.pdfJsViewerUrl, // requis si backend = pdfjs
    super.id,
  });

  late IFrameElement _frame;
  late DivElement _root;
  late DivElement _toolbar;

  int _page = 1;
  double _zoom = 100;

  @override
  Element create() {
    _page = initialPage < 1 ? 1 : initialPage;
    _zoom = initialZoom <= 5 ? 5 : initialZoom;

    _root = DivElement()..classes.add('pdf-reader');
    _toolbar = DivElement()..classes.add('pdf-toolbar');

    if (showToolbar) _buildToolbar();

    _frame = IFrameElement()
      ..classes.add('pdf-frame')
      ..style.border = '0'
      ..style.width = (width != null ? '${width!.toStringAsFixed(0)}px' : '100%')
      ..style.height = (height != null ? '${height!.toStringAsFixed(0)}px' : '600px')
      ..src = _composeUrl();

    // IMPORTANT : sandbox pour limiter le download en mode natif
    if (backend == PdfBackend.native && preventDownload) {
      // Pas de allow-downloads → bloque la plupart des téléchargements initiés par l’iframe
      // On garde same-origin pour laisser le viewer s’exécuter.
      _frame.sandbox!.add('allow-scripts');
      _frame.sandbox!.add('allow-same-origin');
      // NE PAS ajouter 'allow-downloads' ni 'allow-top-navigation'
    }

    _root.append(_frame);

    if (controller != null) {
      controller!._setPage = (int p) => _setPage(p);
      controller!._setZoom = (double z) => _setZoom(z);
      controller!._zoomIn = () => _zoomIn();
      controller!._zoomOut = () => _zoomOut();
      controller!._prev = () => _goPrev();
      controller!._next = () => _goNext();
    }

    _ensureCss();
    return _root;
  }

  // --- Toolbar
  late SpanElement? _pageInfoEl = null;
  late SpanElement? _zoomInfoEl = null;

  void _buildToolbar() {
    final btnPrev = ButtonElement()
      ..text = '◀'
      ..classes.add('pdf-btn')
      ..onClick.listen((_) => _goPrev());

    final pageInfo = SpanElement()
      ..classes.add('pdf-page-info')
      ..text = 'Page $_page';

    final btnNext = ButtonElement()
      ..text = '▶'
      ..classes.add('pdf-btn')
      ..onClick.listen((_) => _goNext());

    final btnZoomOut = ButtonElement()
      ..text = '−'
      ..classes.add('pdf-btn')
      ..onClick.listen((_) => _zoomOut());

    final zoomInfo = SpanElement()
      ..classes.add('pdf-zoom-info')
      ..text = '${_zoom.toStringAsFixed(0)}%';

    final btnZoomIn = ButtonElement()
      ..text = '+'
      ..classes.add('pdf-btn')
      ..onClick.listen((_) => _zoomIn());

    _toolbar.children.addAll([
      btnPrev, pageInfo, btnNext,
      SpanElement()..text = ' | ',
      btnZoomOut, zoomInfo, btnZoomIn,
      if (preventDownload)
        SpanElement()
          ..classes.add('pdf-note')
          ..text = 'Téléchargement désactivé'
    ]);

    _pageInfoEl = pageInfo;
    _zoomInfoEl = zoomInfo;
    _root.append(_toolbar);
  }

  void _updateIndicators() {
    if (_pageInfoEl != null) _pageInfoEl!.text = 'Page $_page';
    if (_zoomInfoEl != null) _zoomInfoEl!.text = '${_zoom.toStringAsFixed(0)}%';
  }

  void _goPrev() {
    if (_page > 1) { _page -= 1; _reload(); }
  }

  void _goNext() { _page += 1; _reload(); }

  void _zoomIn() { _zoom = (_zoom + 10).clamp(5, 800); _reload(); }

  void _zoomOut() { _zoom = (_zoom - 10).clamp(5, 800); _reload(); }

  void _setPage(int p) {
    final np = p < 1 ? 1 : p;
    if (np != _page) { _page = np; _reload(); }
  }

  void _setZoom(double z) {
    final nz = z.clamp(5, 800);
    if (nz != _zoom) { _zoom = nz.toDouble(); _reload(); }
  }
// Construit une URL absolue même-origine si le chemin commence par "/"
String _absSameOrigin(String pathOrUrl) {
  // Si c'est déjà une URL absolue (http/https), on la retourne telle quelle
  final lower = pathOrUrl.toLowerCase();
  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return pathOrUrl;
  }
  // Si c'est un path absolu, on reconstruit une URL complète à partir de la base
  if (pathOrUrl.startsWith('/')) {
    final base = Uri.base; // ex: https://example.com/
    final u = Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: pathOrUrl, // garde le chemin tel quel
    );
    return u.toString();
  }
  // Sinon, c'est relatif → on le résout contre Uri.base
  return Uri.base.resolve(pathOrUrl).toString();
}

/// Construit l'URL de l'iframe selon le backend choisi.
String _composeUrl() {
  if (backend == PdfBackend.pdfjs) {
    // 1) viewer (PDF.js)
    final viewer = pdfJsViewerUrl ?? '/assets/pdfjs/web/viewer.html';
    final viewerUrl = _absSameOrigin(viewer);

    // 2) fichier PDF (même-origine fortement recommandé)
    final fileUrl = _absSameOrigin(src);
    final fileParam = Uri.encodeComponent(fileUrl);

    // 3) hash de navigation (page/zoom)
    final hash = '#page=$_page&zoom=${_zoom.toStringAsFixed(0)}';

    // 4) paramètres – on ajoute nos flags quand preventDownload = true
    final params = StringBuffer('file=$fileParam');
    if (preventDownload) {
      // Certains builds officiels n'interprètent pas ces flags,
      // on garde malgré tout pour compat' et on complète côté CSS dans viewer.html.
      params.write('&download=false&disableDownload=true&print=false&disablePrint=true');
    }

    // Résultat final : https://.../viewer.html?file=<ENCODED>&download=false...#page=..&zoom=..
    return '$viewerUrl?$params$hash';
  }

  // Backend natif : viewer du navigateur
  // On garde src tel quel mais on normalise si besoin (ex: chemin absolu)
  final pdfUrl = _absSameOrigin(src);
  final hash = '#page=$_page&zoom=${_zoom.toStringAsFixed(0)}';

  // S'il y avait déjà un hash dans l'URL, on l'écrase proprement :
  final withoutHash = pdfUrl.split('#').first;
  return '$withoutHash$hash';
}
  void _reload() {
    _updateIndicators();
    _frame.src = _composeUrl();
  }

  void _ensureCss() {
    final id = 'pdf-reader-css';
    if (document.getElementById(id) != null) return;
    final style = StyleElement()
      ..id = id
      ..text = '''
.pdf-reader{ display:flex; flex-direction:column; gap:8px; }
.pdf-toolbar{ display:flex; align-items:center; gap:8px; font-family:system-ui,-apple-system,Segoe UI,Roboto,Ubuntu,Cantarell,Noto Sans,sans-serif; }
.pdf-btn{ padding:4px 8px; border:1px solid #ddd; border-radius:6px; background:#fff; cursor:pointer; }
.pdf-btn:hover{ background:#f7f7f7; }
.pdf-page-info, .pdf-zoom-info{ min-width:72px; text-align:center; font-size:12px; color:#444; }
.pdf-note{ font-size:12px; color:#888; margin-left:auto; }
.pdf-frame{ flex:0 0 auto; background:#f9fafb; border:1px solid #eee; border-radius:10px; box-shadow: 0 1px 6px rgba(0,0,0,.04); }
''';
    document.head!.append(style);
  }
  
  @override
  // TODO: implement getElement
  Element get getElement => _root;
}
