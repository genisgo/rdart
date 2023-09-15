part of 'bs.components.dart';

//Navbar

class BsNavbar extends Relement {
  static int _idgenerate = 0;
  Relement? icon;

  ///This use [bnavbar.nav]
  List<Relement> menus;
  Relement? toggleButton;

  ///Use [bnavbar.brand] navbar-brand
  Relement? title;

  ///Add custom style
  List<Bootstrap> style;
  bool useDefaultExpand;
  String? id;
  BsNavbar(
      {this.title,
      this.icon,
      required this.menus,
      this.style = const [],
      this.toggleButton,
      this.useDefaultExpand = true,
      this.id})
      : super(key: id) {
    id ??= "nav$_idgenerate";
  }
  var idCollapse = "navcollapse$_idgenerate";
  final nav = Element.nav();
  var spanicon = Element.span();
  var container = Element.div();
  var collapseContent = Element.div();
  @override
  Element create() {
    var navStyle = [bnavbar, ...style, if (useDefaultExpand) bnavbarExpand.lg];

    if (icon != null) {
      spanicon = icon!.create();
    }

    collapseContent.className +=
        [Bcollapse.collapse, bnavbar.collapse].join(" ");
    //set Collapse id
    collapseContent.id = idCollapse;
    //set icon bootstrap class
    spanicon.className += " ${bnavbar.togglerIcon}";
    //containter class
    container.className = [BContainer.fluid].join(" ");
    //nav class
    nav.className = navStyle.join(" ");
    //default btn
    //Title create
    title?.create();
    title?.getElement.className += [bnavbar.brand].join(" ");
    var defaultToggleBtn = BsElement(
        child: RButton(
          singleBootStrap: true,
          style: RStyle(),
          type: BtnType.button,
        ),
        bootstrap: [
          bnavbar.toggler
        ],
        dataset: {
          "bs-toggle": "collapse",
          "bs-target": "#$idCollapse"
        },
        attributes: {
          "aria-expanded": "false",
          "aria-label": "Toggle navigation"
        });

//Create Default Btn element
    defaultToggleBtn.create();
    toggleButton ??= defaultToggleBtn;
    //set icon
    toggleButton?.getElement.children.add(spanicon);
//set collapse menu in collapse container
    collapseContent.children.addAll(menus.map((e) => e.create()));
//set container
    container.children.addAll([
      if (title != null) title!.getElement,
      toggleButton!.getElement,
      collapseContent
    ]);

//add element to nav
    nav.children.add(container);

    return nav;
  }

  @override
  // TODO: implement getElement
  Element get getElement => throw UnimplementedError();
}

class BsNavMenu extends Rview {
  List<Relement> items;
  List<Bootstrap> style;
  String? id;
  BsNavMenu({required this.items, this.style = const [], this.id})
      : super(key: id);

  @override
  Relement build() {
    return BsElement(
        child: Column(singleBootStrap: true, children: items),
        bootstrap: [bnavbar.nav, ...style]);
  }

  @override
  void onInitialized() {
    ///set Id
    if (id != null) getElement.id = id!;
    super.onInitialized();
  }
}

class BsNavMenuItem extends Rview {
  Relement child;
  List<Bootstrap> style;
  bool addNavLink;
  bool active;
  BsNavMenuItem(
      {required this.child,
      this.style = const [],
      this.addNavLink = false,
      this.active = false});
  @override
  Relement build() {
    return BsElement(
        child: child, bootstrap: [bnavbar.item, if (active) bactive, ...style]);
  }

  @override
  void onInitialized() {
    if (addNavLink|| child is Link) child.getElement.className += " ${bnavbar.link}";
    super.onInitialized();
  }
}
