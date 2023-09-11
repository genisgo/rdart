part of 'bs.components.dart';

///List groups are a flexible and powerful component for displaying a series of content.
/// Modify and extend them to support just about any content within <br>
///**Use Blist:**
///* Example
///```dart
///BsList(
///     itemActiveColor: Colors.red,
///      mouseHoverColor: Color("#ffb7a8"),
///      style: [Bmargin.m3, blist.horizontal.md],
///     items: [
///       BsListItem(
///       child: Column(singleBootStrap: true, bootstrap: [
///       Bdisplay.flex,
///       BFlex.nowrap,
///       BJustifyContent.between
///   ], children: [
///     Text("List Element 0"),
///  ])
/// )]);
///
///```

class BsList extends Relement {
  ///[BsListItem] is possible to extends and custom this
  List<BsListItem> items;

  ///Use [style] to custom Blist with bootstrap generale const [blist]
  ///or class [BList.list]. <br>
  ///`Example :`
  /// ```dart
  /// //Generale const example
  /// BsListItem(style: [blist.horizontal, blist.groupeNumber],);
  /// //Class const example
  /// BsListItem(style: [BList.list.horizontal, BList.list.groupeNumber],)
  /// ```
  List<Bootstrap> style;

  ///Use [Color] class to customize mouse hover background color<br>
  ///**Example**:
  ///```dart
  ///BsList(
  ///mouseHoverColor: Color("#ffb7a8"))
  ///```
  Color? mouseHoverColor;

  ///edit itemActive color
  ///Example :
  ///```dart
  ///BsList(
  ///   itemActiveColor: Colors.red,)
  ///```
  Color? itemActiveColor;

  ///List groups are a flexible and powerful component for displaying a series of content.
  /// Modify and extend them to support just about any content within <br>
  ///**Use Blist:**
  ///* Example
  ///```dart
  ///BsList(
  ///     itemActiveColor: Colors.red,
  ///      mouseHoverColor: Color("#ffb7a8"),
  ///      style: [Bmargin.m3, blist.horizontal.md],
  ///     items: [
  ///       BsListItem(
  ///       child: Column(singleBootStrap: true, bootstrap: [
  ///       Bdisplay.flex,
  ///       BFlex.nowrap,
  ///       BJustifyContent.between
  ///   ], children: [
  ///     Text("List Element 0"),
  ///  ])
  /// )]);
  ///```
  ///**Custom Style for List :**<br>
  ///* dd [blist.groupeNumber]  to opt into numbered list group items. Numbers are generated
  ///`Example:`
  ///```dart
  ///   BsList(
  ///     itemActiveColor: Colors.red,
  ///     mouseHoverColor: Color("#ffb7a8"),
  ///     //Number List
  ///     style: [Bmargin.m3, blist.groupeNumber],)
  ///```
  /// * Add [blist.horizontal] to change the layout of list group items from vertical to horizontal
  ///  across all breakpoints. Alternatively, choose a responsive variant .[blist.horizontal].{sm|md|lg|xl|xxl}
  /// to make a list group horizontal.<br>
  /// `Example`:
  ///```dart
  ///   BsList(
  ///     style: [Bmargin.m3, blist.horizontal.md],
  ///     itemActiveColor: Colors.red,
  ///      mouseHoverColor: Color("#ffb7a8"),)
  ///```
  BsList(
      {this.items = const [],
      this.style = const [],
      this.mouseHoverColor,
      this.itemActiveColor});
  final _ol = Element.ol();
  @override
  Element create() {
    _ol.className = [blist, ...style].join(" ");

    _ol.children.addAll(items.map((e) => e.create()));

    _ol.style
      ..setProperty("--bs-list-group-action-hover-bg", mouseHoverColor?.color)
      ..setProperty("--list-group-action-active-bg", mouseHoverColor?.color);

    return _ol;
  }

  @override
  // TODO: implement getElement
  Element get getElement => throw UnimplementedError();
}

/// [BsListItem]
/// * Use Clicable element
/// Use [Link] class or [RButton] to create actionable list group items with hover,
/// disabled. You can active states by adding [blist.itemAction].
///<br> `Example:`
/// ```dart
///  BsListItem(
///    child: Column(singleBootStrap: true, bootstrap: [
///     Bdisplay.flex,
///     BFlex.nowrap,
///     BJustifyContent.between
///   ], children: [
///     Text("List Element 0"),]) )
/// ```
class BsListItem extends Relement {
  bool active;
  Relement? child;
  bool disabled;
  List<Bootstrap> style;
  BsListItem(
      {this.child,
      this.active = false,
      this.disabled = false,
      this.style = const []});
  final _li = Element.li();
  @override
  Element create() {
    var isActionItem = child is Link || child is RButton;
    var item = BsElement(child: child, bootstrap: [
      blistItem,
      ...style,
      if (active) blistItem.active,
      if (disabled) blistItem.disabled,
      if (isActionItem) blistItem.action,
    ], dataset: {
      if (disabled) "aria-disabled": "true",
      if (active) "aria-current": "true"
    });
    // _li.children.add(item.create());
    return item.create(); //: _li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _li;
}
