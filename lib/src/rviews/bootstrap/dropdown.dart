part of 'bs.components.dart';

enum DropType { dropdown, dropup, dropstart, dropend, dropdownCenter }

class BsDropDown extends Relement {
  List<BsDropDownItem> items;
  List<Bootstrap> menuStyle;
  List<Bootstrap> dropStyle;
  List<Bootstrap> btnStyle;
  Relement? splitChild;
  Relement? title;
  bool useSingleMenu;
  bool splitBtn;
  DropType type;
  BsDropDown(
      {this.items = const [],
      this.menuStyle = const <Bootstrap>[],
      this.dropStyle = const [],
      this.btnStyle = const [Btn.btn, Btn.primary],
      this.useSingleMenu = false,
      this.splitBtn = false,
      this.splitChild,
      this.title,
      this.type = DropType.dropdown});
  final _menu = Element.ul();
  final _drop = Element.div();
  late Element _dropContent;
  @override
  Element create() {
    ///DropBtn
    var dropBtn = BsElement(
        child: RButton(
            singleBootStrap: true,
            child: title,
            type: BtnType.button,
            style: RStyle()),
        bootstrap: [
          ...btnStyle,
          bdropdown.toggle,
          if (splitBtn) bdropdown.split,
        ],
        dataset: {
          "bs-toggle": "dropdown"
        },
        attributes: {
          "aria-expanded": "false"
        });

    ///Set menu
    _menu.className += [bdropdown.menu, ...menuStyle].join(" ");
    _menu.children.addAll(items.map((e) => e.create()));
    //Droup
    _drop.className = <Bootstrap>[
      if (!splitBtn) setDrop() else Btn.group,
      ...dropStyle,
    ].join(" ");
    //set children
    _drop.children.addAll([if (splitBtn) splitChild!.create()]);
    _drop.children.addAll([dropBtn.create(), _menu]);

    _dropContent = useSingleMenu ? _menu : _drop;

    return _dropContent;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _dropContent;

  Bootstrap setDrop() {
    return switch (type) {
      DropType.dropdown => bdropdown,
      DropType.dropup => bdropdown.dropup,
      DropType.dropdownCenter => bdropdown.center,
      DropType.dropend => bdropdown.dropend,
      DropType.dropstart => bdropdown.dropstart,
    };
  }
}

class BsDropDownItem extends Relement {
  bool active;
  Link child;
  bool disabled;
  BsDropDownItem(
      {required this.child, this.active = false, this.disabled = false});
  final _li = Element.li();
  @override
  Element create() {
    var item = BsElement(child: child, bootstrap: [
      bdropdown.item,
      if (active) bdropdown.itemActive,
      if (disabled) bdropdown.disabled,
    ], dataset: {
      if (disabled) "aria-disabled": "true",
      if (active) "aria-current": "true"
    });
    _li.children.add(item.create());
    return _li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _li;
}
