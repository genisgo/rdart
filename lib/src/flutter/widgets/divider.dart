part of 'widgets.dart';

class Divider extends Relement {
  final bool vertical;
  final double thickness;  // px
  final String color;      // CSS color
  final EdgeInsets? margin;

  Divider({
    this.vertical = false,
    this.thickness = 1,
    this.color = 'rgba(0,0,0,.12)',
    this.margin,
    super.id,
  });

  late final DivElement _el = DivElement();

  @override
  Element create() {
    _el.id = id ?? 'divider-${DateTime.now().microsecondsSinceEpoch}';
    if (vertical) {
      _el.style
        ..width = '${thickness}px'
        ..height = '100%'
        ..backgroundColor = color
        ..display = 'inline-block';
      if (margin != null) _el.style.margin = margin!.toCss();
    } else {
      _el.style
        ..height = '${thickness}px'
        ..width = '100%'
        ..backgroundColor = color
        ..display = 'block';
      if (margin != null) _el.style.margin = margin!.toCss();
    }
    return _el;
  }

  @override
  Element get getElement => _el;
}
