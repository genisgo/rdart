part of 'widgets.dart';

class Checkbox extends Relement {
  bool value;
  final String? label;
  final void Function(bool)? onChanged;
  final bool enabled;

  Checkbox({required this.value, this.label, this.onChanged, this.enabled = true, super.id});

  final LabelElement _root = LabelElement();
  final CheckboxInputElement _cb = CheckboxInputElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'chk-${DateTime.now().microsecondsSinceEpoch}'
      ..style.display = 'inline-flex'
      ..style.alignItems = 'center'
      ..style.gap = '6px';

    _cb
      ..checked = value
      ..disabled = !enabled;
    _cb.onChange.listen((_) {
      value = _cb.checked ?? false;
      onChanged?.call(value);
    });

    _root.children
      ..clear()
      ..add(_cb);
    if (label != null) _root.children.add(SpanElement()..text = label!);
    return _root;
  }

  @override
  Element get getElement => _root;
}
