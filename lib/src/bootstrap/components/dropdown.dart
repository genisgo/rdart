part of 'bs.components.dart';

enum DropType { dropdown, dropup, dropstart, dropend, dropdownCenter }

///Use Dropdown Rview
///Use general const [bdropdown] or [Bdropdown.dropdown]
///for custom Dropdown style
///Simple example:
///```dart
/// BsDropDown(
///   btnStyle: [Btn.btn, Btn.primary],
///   menuStyle: [bdropdown.menuDark],
///  title: Text(
///  "Download start",
///  singleBootStrap: true,
///  style:RStyle(bootstrap: [Bdisplay.inline, Btext.fs.h6]),),
///  items:[
///   BsDropDownItem(
///    child: Link(
///        click: () {},
///       child:Row(children: [
///          Text("text",
///             style: RStyle(bootstrap: [Btext.fs.h6, Bmargin.m0.b])),
///       ])),)
/// ]);
/// ```
class BsDropDown extends Relement {
  ///Use [BsDropDownItem] class to creat item or other [Relement] Object
  /// `Example for [BsDropDownItem]`
  /// ```dart
  ///   BsDropDownItem(
  ///    child: Link(
  ///        click: () {},
  ///       child: Row(children: [
  ///          Text("Hello word!",
  ///            style: RStyle(bootstrap: [Btext.fs.h6, Bmargin.m0.b])),
  ///       ])),)
  /// ```
  List<Relement> items;

  ///The menu style example value
  ///[bdropdown.menAlignEnd], [bdropdown.menAlignStart],
  ///[bdropdown.menuDark]
  ///`code example`
  ///```dart
  /// BsDropDown(menuStyle: [bdropdown.menuDark],)
  ///```
  List<Bootstrap> menuStyle;

  ///Use this [bdropdown] for custom dropdown
  ///Value example : [bdropdown.dropstart], [bdropdown.dropend]
  ///[bdropdown.dropup] and [bdropdown.center]
  List<Bootstrap> dropStyle;

  ///Use [Btn] class for custom Button
  ///Example value : [Btn.btn], [Btn.info]
  ///```dart
  /// BsDropDown(
  ///   btnStyle: [Btn.btn, Btn.primary],
  /// )
  /// ```
  List<Bootstrap> btnStyle;

  ///[splitChild] is use if [split]=true, she creat Btn.group
  /// and add [splitChild] and second [RButton] to creat goupe Button
  /// ```dart
  /// BsDropDown(
  ///  useSingleMenu: singleMenu,
  ///  splitBtn: splite)
  ///```
  Relement? splitChild;

  Relement? title;

  bool useSingleMenu;

  ///Active split mode
  bool split;

  ///Use set Type of drop
  DropType type;

  ///Use Dropdown Rview
  ///Use general const [bdropdown] or [Bdropdown.dropdown]
  ///for custom Dropdown style
  ///Simple example:
  ///```dart
  /// BsDropDown(
  ///   btnStyle: [Btn.btn, Btn.primary],
  ///   menuStyle: [bdropdown.menuDark],
  ///  title: Text(
  ///  "Download start",
  ///  singleBootStrap: true,
  ///  style:RStyle(bootstrap: [Bdisplay.inline, Btext.fs.h6]),),
  ///  items:[
  ///   BsDropDownItem(
  ///    child: Link(
  ///        click: () {},
  ///       child:Row(children: [
  ///          Text("text",
  ///             style: RStyle(bootstrap: [Btext.fs.h6, Bmargin.m0.b])),
  ///       ])),)
  /// ]);
  /// ```
  BsDropDown(
      {this.items = const [],
      this.menuStyle = const <Bootstrap>[],
      this.dropStyle = const [],
      this.btnStyle = const [Btn.btn, Btn.primary],
      this.useSingleMenu = false,
      this.split = false,
      this.splitChild,
      super.id,
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
          if (split) bdropdown.split,
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
      if (!split) setDrop() else Btn.group,
      ...dropStyle,
    ].join(" ");
    //set children
    _drop.children.addAll([if (split) splitChild!.create()]);
    _drop.children.addAll([dropBtn.create(), _menu]);

    _dropContent = useSingleMenu ? _menu : _drop;
    //SET ID
    if (id != null) _dropContent.id = id!;
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

/// **Manipulate [BsDropDownItem]**<br>
/// **sytle:** with Bootstrap const [bdropdown],
/// or class [Bdropdown] or Bootstrap other class.
/// Applique [BsDropDown.sytle] to set List of style
/// * Add `bdropdown.itemActive` to a [BsDropDownItem] to indicate the current active selection.
/// * Add `bdropdown.disabled` to a [BsDropDownItem] to make it appear disabled.
/// Add the [bdropdown.itemText].
/// Example sytle:
/// ```dart
///   //markup active item
///   BsDropDownItem(style:[bdropdown.itemActive])
///  ```
/// **Use Component:**
///```dart
///  items:[
///   BsDropDownItem(
///    child: Link(
///        click: () {},
///       child:Row(children: [
///          Text("text",
///             style: RStyle(bootstrap: [Btext.fs.h6, Bmargin.m0.b])),
///       ])),)
/// ```
///
class BsDropDownItem extends Relement {
  bool active;
  Link child;
  bool disabled;
  List<Bootstrap> style;
  BsDropDownItem(
      {required this.child,
      this.active = false,
      super.id,
      this.disabled = false,
      this.style = const []});
  final _li = Element.li();
  @override
  Element create() {
    var item = BsElement(child: child, bootstrap: [
      bdropdown.item,
      ...style,
      if (active) bdropdown.itemActive,
      if (disabled) bdropdown.disabled,
    ], dataset: {
      if (disabled) "aria-disabled": "true",
      if (active) "aria-current": "true"
    });
    _li.children.add(item.create());
    //SET ID
    if (id != null) _li.id = id!;
    return _li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _li;
}
