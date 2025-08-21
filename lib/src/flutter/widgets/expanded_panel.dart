part of 'widgets.dart';

/// ============================================================================
/// 3) ExpandablePanel – accordéon fluide (anim height auto)
/// ============================================================================
bool _cssInjectedExpandedPanel = false;

_ensureExpandedCssStyle() {
  if (_cssInjectedExpandedPanel) return;
  _cssInjectedExpandedPanel = true;
  final style =
      StyleElement()
        ..id = ".rdx-expandable"
        ..text = r'''
/* === ExpandablePanel === */
.rdx-expandable{ display:block; }
.rdx-exp-header{ cursor:pointer; }
.rdx-exp-body{ overflow:hidden; height:0; }
.rdx-expandable.open .rdx-exp-body{ height:auto; }
''';
  document.head?.append(style);
}

class ExpandablePanel extends Relement {
  final Relement header;
  final Relement body;
  bool expanded;
  final int durationMs;
  final Curve curve;
  final bool collapseOnHeaderTap;

  ExpandablePanel({
    required this.header,
    required this.body,
    this.expanded = false,
    this.durationMs = 240,
    this.curve = Curve.easeInOut,
    this.collapseOnHeaderTap = true,
    super.id,
  });

  final _root = DivElement();
  final _hdr = DivElement();
  final _bodyWrap = DivElement();

  @override
  Element create() {
    _ensureExpandedCssStyle();
    _root
      ..id = id ?? 'exp-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rdx-expandable');

    _hdr
      ..classes.add('rdx-exp-header')
      ..children.add(header.create());

    _bodyWrap
      ..classes.add('rdx-exp-body')
      ..style.transition = 'height ${durationMs}ms ${_curveCss(curve)}'
      ..children.add(body.create());

    _root.children
      ..clear()
      ..addAll([_hdr, _bodyWrap]);

    if (expanded) {
      // set height to content then to auto
      window.requestAnimationFrame((_) {
        _openImmediate();
      });
    }

    if (collapseOnHeaderTap) {
      _hdr.onClick.listen((_) {
        toggle();
      });
    }

    return _root;
  }

  void toggle() {
    expanded ? collapse() : expand();
  }

  void expand() {
    if (expanded) return;
    expanded = true;
    final full = _bodyWrap.scrollHeight;
    _bodyWrap.style.height = '${full}px';

    Future.delayed(Duration(milliseconds: durationMs), () {
      _root.classes.add('open');
      _bodyWrap.style.height = 'auto';
    });
  }

  void collapse() {
    if (!expanded) return;
    expanded = false;
    final full = _bodyWrap.scrollHeight; // current height
    _bodyWrap.style.height = '${full}px';
    // force reflow before going to 0
    _bodyWrap.getBoundingClientRect();
    _bodyWrap.style.height = '0px';
    _root.classes.remove('open');
  }

  void _openImmediate() {
    _root.classes.add('open');
    _bodyWrap.style.height = 'auto';
  }

  @override
  Element get getElement => _root;
}
