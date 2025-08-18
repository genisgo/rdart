part of 'widgets.dart';

class Switch extends Relement {
  bool value;
  final void Function(bool)? onChanged;
  final bool enabled;
  final String? ariaLabel;

  Switch({required this.value, this.onChanged, this.enabled = true, this.ariaLabel, super.id});

  final LabelElement _root = LabelElement();
  final CheckboxInputElement _cb = CheckboxInputElement();
  final SpanElement _slider = SpanElement();
  static bool _cssInjected = false;

  @override
  Element create() {
    _ensureCss();
    _root
      ..id = id ?? 'switch-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.add('rd-switch')
      ..setAttribute('role', 'switch')
      ..setAttribute('aria-checked', value.toString());
    if (ariaLabel != null) _root.setAttribute('aria-label', ariaLabel!);

    _cb
      ..checked = value
      ..disabled = !enabled;
    _cb.onChange.listen((_) {
      value = _cb.checked ?? false;
      _root.setAttribute('aria-checked', value.toString());
      onChanged?.call(value);
    });

    _slider.classes.add('rd-switch-slider');

    _root.children
      ..clear()
      ..addAll([_cb, _slider]);
    return _root;
  }

  @override
  Element get getElement => _root;

  static void _ensureCss() {
    if (_cssInjected) return;
    _cssInjected = true;
    final style = StyleElement()
      ..id = 'rdart-switch-styles'
      ..text = '''
.rd-switch{ position:relative; display:inline-block; width:42px; height:24px; }
.rd-switch input{ opacity:0; width:0; height:0; }
.rd-switch-slider{
  position:absolute; cursor:pointer; top:0; left:0; right:0; bottom:0; background:#adb5bd; transition:.2s; border-radius:999px;
}
.rd-switch-slider:before{
  position:absolute; content:""; height:18px; width:18px; left:3px; top:3px; background:white; transition:.2s; border-radius:999px; box-shadow:0 1px 3px rgba(0,0,0,.2);
}
.rd-switch input:checked + .rd-switch-slider{ background:#0d6efd; }
.rd-switch input:checked + .rd-switch-slider:before{ transform: translateX(18px); }
.rd-switch input:disabled + .rd-switch-slider{ opacity:.6; cursor:not-allowed; }
''';
    document.head?.append(style);
  }
}
