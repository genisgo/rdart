part of 'widgets.dart';

class RRadio<T> extends Relement {
  final String name;   // groupe
  final T value;
  T groupValue;
  final String? label;
  final void Function(T)? onChanged;
  final bool enabled;

  RRadio({
    required this.name,
    required this.value,
    required this.groupValue,
    this.label,
    this.onChanged,
    this.enabled = true,
    super.id,
  });

  final LabelElement _root = LabelElement();
  final RadioButtonInputElement _rb = RadioButtonInputElement();

  @override
  Element create() {
    _root
      ..id = id ?? 'radio-${DateTime.now().microsecondsSinceEpoch}'
      ..style.display = 'inline-flex'
      ..style.alignItems = 'center'
      ..style.gap = '6px';

    _rb
      ..name = name
      ..checked = value == groupValue
      ..disabled = !enabled;
    _rb.onChange.listen((_) {
      if (_rb.checked == true) {
        groupValue = value;
        onChanged?.call(value);
      }
    });

    _root.children
      ..clear()
      ..add(_rb);
    if (label != null) _root.children.add(SpanElement()..text = label!);

    return _root;
  }

  @override
  Element get getElement => _root;
}
