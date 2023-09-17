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
    title?.getElement.className += " " + [bnavbar.brand].join(" ");
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

class BsNav extends Relement {
  int _idgenerate = 0;

  String? id;
  List<Relement> items;
  List<Bootstrap> bootstrap;
  final _nav = Element.ul();
  BsNav({required this.items, this.bootstrap = const [], this.id})
      : super(key: id) {
    _idgenerate++;
    id ??= "nav$_idgenerate";
  }

  @override
  Element create() {
    _nav.id = id!;
    _nav.className = bootstrap.join(" ");
    _nav.children.addAll(items.map((e) => e.create()));

    return _nav;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _nav;
}

class BsNavTabs extends Relement {
  String? id;

  List<BsTab> tabs;

  List<Bootstrap> style;

  List<Bootstrap> contentStyle;

  List<BsTabPanel> panels;

  String? targetId;

  String _contentId = "";

  final _nav = Element.ul();

  final _divPanels = Element.div();
  final _divContent = Element.div();

  BsNavTabs(
      {required this.tabs,
      this.style = const [],
      this.panels = const [],
      this.contentStyle = const [],
      this.targetId,
      this.id})
      : super(key: id) {
    id ??= "nav-tabs-$generateId";
    _contentId = "content-$generateId";
  }

  @override
  Element create() {
    ///if target is set
    bool isTarget = targetId != null && panels.isEmpty;
    //nav
    _nav.id = id!;
    _nav.attributes.addAll({"role": "tablist"});
    _nav.className = [bnav, ...style].join(" ");
    //BsTab & content
    List<Element> contentElement = [];
    var tabEelement = tabs.map((e) => e.create()).toList();
    //on set target id
    if (isTarget) {
      var querySelect = querySelector("#$targetId");
      if (querySelect != null) contentElement = querySelect.children;
    } else {
      contentElement = panels.map((e) => e.create()).toList();
    }

    assert(contentElement.length == tabs.length,
        "tabs and panel must be the same numbers");

    for (var i = 0; i < tabEelement.length; i++) {
      var btn = tabEelement[i].children.first;
      var content = contentElement[i];
      //set content id to btn
      btn.dataset.addAll({"bs-target": "#${content.id}"});
      btn.attributes.addAll({"aria-controls": content.id});
      //set aria-labelledby
      content.attributes.addAll({"aria-labelledby": btn.id});
    }

//content
    _divPanels.className = [btabs.content, ...contentStyle].join(" ");
    _divPanels.id = _contentId;

    _nav.children.addAll(tabEelement);
    if (panels.isNotEmpty) {
      _divPanels.children.addAll(contentElement);
    }
    _divContent.children.add(
      _nav,
    );
    if (!isTarget) {
      _divContent.children.add(_divPanels);
    }
    return _divContent;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _divContent;
}

///Tab

class BsTab extends Relement {
  Relement child;
  List<Bootstrap> style;
  bool addNavLink;
  bool active;
  String title;
  String? id;
  final _li = Element.li();
  final _btn = ButtonElement();
  BsTab(
      {required this.child,
      this.style = const [],
      this.addNavLink = false,
      this.title = "",
      this.id,
      this.active = false})
      : super(key: id) {
    id ??= "tab-$generateId";
  }

  @override
  Element create() {
    _btn.id = id!;
    _btn.className = [
      bnav.link,
    ].join(" ");
    _btn.attributes
        .addAll({"role": "tab", "aria-selected": "$active", "type": "button"});
    _btn.dataset.addAll({
      "bs-toggle": "tab",
    });
    _li.children.add(_btn);
    return _li;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _li;
}

///Tab Panel
class BsTabPanel extends Rview {
  Relement child;
  String? id;
  List<Bootstrap> bootstrap;
  BsTabPanel({
    required this.child,
    this.bootstrap = const [],
    this.id,
  }) : super(key: id) {
    id ??= "tab-panel-$generateId";
  }
  @override
  Relement build() {
    return BsElement(
        child: child,
        bootstrap: [btabs.panel, bfade, ...bootstrap],
        attributes: {"role": "tabpanel", "tabindex": "0", "id": id!});
  }
}

///BsNavMenuItem
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
        child: child, bootstrap: [bnav.item, if (active) bactive, ...style]);
  }

  @override
  void onInitialized() {
    if (addNavLink || child is Link || child is RButton) {
      child.getElement.className += " ${bnav.link}";
    }
    super.onInitialized();
  }
}
