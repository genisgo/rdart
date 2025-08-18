part of 'widgets.dart';

class LinearProgressIndicator extends Relement {
  /// null => indéterminé (animation)
  final double? value; // 0..1
  final String trackColor;
  final String barColor;
  final double height;
  final List<Bootstrap> bootstrap;

  LinearProgressIndicator({
    this.value,
    this.trackColor = 'rgba(0,0,0,.08)',
    this.barColor = '#0d6efd',
    this.height = 6,
    this.bootstrap = const [],
    super.id,
  });

  final DivElement _root = DivElement();
  final DivElement _bar = DivElement();
  static bool _cssInjected = false;

  @override
  Element create() {
    _ensureCss();

    _root
      ..id = id ?? 'lpi-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll(['rd-lpi', ...bootstrap.map((e) => e.cname,)]);
    _root.style
      ..height = '${height}px'
      ..backgroundColor = trackColor;

    _bar
      ..classes.add('rd-lpi-bar')
      ..style.backgroundColor = barColor;

    if (value == null) {
      _bar.classes.add('indeterminate');
    } else {
      final pct = (value!.clamp(0, 1) * 100).toStringAsFixed(2);
      _bar.style.width = '$pct%';
      _bar.classes.remove('indeterminate');
    }

    _root.children
      ..clear()
      ..add(_bar);
    return _root;
  }

  @override
  Element get getElement => _root;

  static void _ensureCss() {
    if (_cssInjected) return;
    _cssInjected = true;
    final style =
        StyleElement()
          ..id = 'rdart-lpi-styles'
          ..text = '''
.rd-lpi{ position:relative; width:100%; border-radius:999px; overflow:hidden; }
.rd-lpi-bar{ position:absolute; left:0; top:0; bottom:0; width:0; transition:width .2s ease; }
.rd-lpi-bar.indeterminate{
  width:40%; animation:rdart-lpi 1.1s ease-in-out infinite;
}
@keyframes rdart-lpi{
  0%{ transform: translateX(-50%); }
  50%{ transform: translateX(50%); }
  100%{ transform: translateX(150%); }
}
''';
    document.head?.append(style);
  }
}
