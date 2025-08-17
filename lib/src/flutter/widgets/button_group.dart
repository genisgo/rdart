part of 'widgets.dart';
class ButtonGroup extends Relement {
  final List<ButtonI> buttons;
  final bool vertical;
  final ButtonSize? size;          // applique 'btn-group-sm' ou 'btn-group-lg'
  final bool fullWidth;            // w-100
  final String? ariaLabel;

  final ButtonGroupToggle toggle;  // none | single (radio) | multi (checkbox)
  final int? initialActiveIndex;   // pour single
  final Set<int>? initialActives;  // pour multi

  final void Function(List<int> actives)? onChange;

  ButtonGroup({
    required this.buttons,
    this.vertical = false,
    this.size,
    this.fullWidth = false,
    this.ariaLabel,
    this.toggle = ButtonGroupToggle.none,
    this.initialActiveIndex,
    this.initialActives,
    this.onChange,
    super.id,
  });

  final DivElement _root = DivElement();

  Set<int> _active = {};

  @override
  Element create() {
    _root
      ..id = id ?? 'btngrp-${DateTime.now().microsecondsSinceEpoch}'
      ..classes.addAll([vertical ? 'btn-group-vertical' : 'btn-group'])
      ..setAttribute('role', 'group');
    if (ariaLabel != null) _root.setAttribute('aria-label', ariaLabel!);
    if (fullWidth) _root.classes.add('w-100');

    if (size != null) {
      switch (size!) {
        case ButtonSize.small:  _root.classes.add('btn-group-sm'); break;
        case ButtonSize.medium: /* rien */ break;
        case ButtonSize.large:  _root.classes.add('btn-group-lg'); break;
      }
    }

    // init état actif
    if (toggle == ButtonGroupToggle.single && initialActiveIndex != null) {
      _active = { initialActiveIndex! };
    } else if (toggle == ButtonGroupToggle.multi && initialActives != null) {
      _active = {...initialActives!};
    } else {
      _active = {};
    }

    // injecte les boutons
    _root.children.clear();
    for (var i = 0; i < buttons.length; i++) {
      final b = buttons[i].create();
      if (b is ButtonElement) {
        b.classes.toggle('active', _active.contains(i));
        // écouteurs pour le toggle
        if (toggle != ButtonGroupToggle.none) {
          b.onClick.listen((e) {
            // ne prend en compte que si bouton "clickable"
            if ((b as ButtonElement).disabled) return;

            if (toggle == ButtonGroupToggle.single) {
              _active = { i };
              _refreshActive();
            } else if (toggle == ButtonGroupToggle.multi) {
              if (_active.contains(i)) {
                _active.remove(i);
              } else {
                _active.add(i);
              }
              _refreshActive();
            }
            onChange?.call(_active.toList()..sort());
          });
        }
      }
      _root.children.add(b);
    }

    return _root;
  }

  void _refreshActive() {
    final kids = _root.querySelectorAll('button.btn');
    for (var i = 0; i < kids.length; i++) {
      kids[i].classes.toggle('active', _active.contains(i));
      kids[i].setAttribute('aria-pressed', _active.contains(i).toString());
    }
  }

  List<int> getActiveIndices() => _active.toList()..sort();

  @override
  Element get getElement => _root;
}