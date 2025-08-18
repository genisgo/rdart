part of 'widgets.dart';

class RSlider extends Relement {
  double value;
  final double min;
  final double max;
  final double step;
  final bool enabled;
  final void Function(double)? onChanged;

  RSlider({
    required this.value,
    this.min = 0,
    this.max = 1,
    this.step = 0.01,
    this.enabled = true,
    this.onChanged,
    super.id,
  }) : assert(max > min),
       assert(step > 0);

  final InputElement _range = InputElement(type: 'range');

  @override
  Element create() {
    _range
      ..id = id ?? 'slider-${DateTime.now().microsecondsSinceEpoch}'
      ..min = '$min'
      ..max = '$max'
      ..step = '$step'
      ..value = '$value'
      ..disabled = !enabled;

    _range.onInput.listen((_) {
      value = double.tryParse(_range.value ?? '') ?? value;
      onChanged?.call(value);
    });

    return _range;
  }

  @override
  Element get getElement => _range;
}
