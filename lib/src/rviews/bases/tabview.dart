part of '../rview_bases.dart';

class TabView extends Rview {
  ///Une [tabBar] constitue l'entête de [TabView] et il est contitué
  ///de [Tab] chaque Tab declarer doit avoir une [tabPage] correspondante
  ///sinon cela crée une Erreur d'affichage
  TabBar tabBar;

  ///De meme pour [tabPage] le nombre d'élément doit être strictement egale
  ///au nombre de [Tab] de [tabBar]
  List<Relement> tabPage;

  TabView({required this.tabBar, required this.tabPage})
      : assert((tabBar.tabs.length == tabPage.length));

  Container currentPage = Container(
      child: Text("non page"),
      style: RStyle(
        width: 100,
        ratioHeight: true,
        ratioWidth: true,
        height: 100,
      ));

  @override
  Relement build() {
    return Column(children: [tabBar, currentPage], mainAxisExpand: true);
  }

  @override
  void initState() {
    _setidCurrentPage();
    _setOnselectCallBack();
    _setDefaultTabPage();
  }

  _setidCurrentPage() {
    for (var i = 0; i < tabPage.length; i++) {
      tabPage[i].getElement.className = ClassName.tabPage.name;
      int index = querySelectorAll(".${ClassName.tabPage.name}").length;
      tabPage[i].getElement.id = "${ClassName.tabPage.name}$index";
    }
  }

  _setDefaultTabPage() {
    currentPage.getElement.children.clear();
    if (tabPage.isNotEmpty) {
      currentPage.child = tabPage.first;
      currentPage.create();
    }
  }

  _setOnselectCallBack() {
    tabBar.onTabSelected = (indx) {
      currentPage.getElement.children.clear();
      currentPage.child = tabPage[indx];
      currentPage.create();

      //  currentPage.create();
    };
  }
}

class TabBar extends Rview {
  List<Tab> tabs;
  double? height;
  Relement? titre;
  Relement? flexContent;
  Color selectorColor;
  Function(int indx)? onTabSelected;
  int defaultTabIndex;
  int elevation;
  Color? backgroundColor;
  Color shadowColor;
  TabBar(
      {required this.tabs,
      this.elevation = 4,
      this.height,
      this.shadowColor = Colors.grays,
      this.backgroundColor,
      this.defaultTabIndex = 0,
      this.selectorColor = Colors.white,
      this.titre,
      this.flexContent});
  @override
  Relement build() {
    return Container(
        style: RStyle(
          height: height ?? 0,
          ratioWidth: true,
          backgroundColor: backgroundColor,
          decoration: Decoration(
            shadow: BoxShadow(blur: elevation, vertical: 0),
          ),
          width: 100,
        ),
        child: Column(children: [
          if (titre != null) titre!,
          Row(children: tabs, crossAxisAlignment: AlignVertical.bottom)
        ]));
  }

  @override
  void initState() {
    _setIdTabBar();
    _initializColor();
    _selectionTab();
    setDefaultActiveTab(defaultTabIndex);
  }

//colors initialisation
  void _initializColor() {
    for (var element in tabs) {
      element.color ??= backgroundColor;
      element.height ??= height;
      element.getStyle().createStyle(element.getElement);
    }
  }

//
  void _selectionTab() {
    for (var index = 0; index < tabs.length; index++) {
      tabs[index].getElement.id = "${getElement.id} $index";
      tabs[index]._selectorColor = selectorColor;
      //tabs[index].color = selectorColor;
      tabs[index]._onActive = (tab) {
        if (onTabSelected != null) onTabSelected!(index);
        tabs
            .where(
                (element) => element.getElement.id != tabs[index].getElement.id)
            .forEach((element) {
          element._isActive = false;
          element.getStyle().createStyle(element.getElement);
        });
      };
    }
  }

  ///Active default Tab for TabBar
  void setDefaultActiveTab(int tabIndex) {
    tabs[tabIndex]._isActive = true;

    tabs[tabIndex].getStyle().createStyle(tabs[tabIndex].getElement);
  }

  ///Set id for all Tab in TabBar
  _setIdTabBar() {
    getElement.className = ClassName.tabBar.name;
    int id = querySelectorAll(".${ClassName.tabBar.name}").length;
    getElement.id = "${ClassName.tabBar.name}$id";
  }
}

///Class Tab is items for TabBarView
class Tab extends Relement {
  Relement child;
  Color? color;
  REdgetInset padding;
  Function(Tab)? _onActive;
  bool _isActive = false;
  Color _selectorColor = Colors.white;
  double? width;
  double? height;
  Tab({
    required this.child,
    this.color,
    this.padding = REdgetInset.zero,
    this.height,
    this.width,
  });
  late RButton _relement;
  late var _element;

  RStyle getStyle() {
    return RStyle(
      ratioWidth: width == null ? true : false,
      width: width ?? 100,
      height: height ?? 100,
      padding: padding,
      ratioHeight: height == null ? true : false,
      backgroundColor: color,
      decoration: Decoration(
          border: _isActive
              ? Rborder(
                  bottom: BorderSide(
                      color: _selectorColor, side: 2, style: BorderStyle.solid),
                )
              : Rborder.all()),
    );
  }

  @override
  Element create() {
    _relement = RButton(
        child: child,
        onPress: (relement) {
          _isActive = true;
          if (_onActive != null) _onActive!(this);

          ///Cree un style lors ce qu'un onglet a été selctionner
          ///un candre blanc a bas s'affiche
          getStyle().createStyle(_relement.getElement);
        },
        style: getStyle());

    _element = _relement.create()..className = ClassName.tabBtn.name;
    return _element;
  }

  @override
  Element get getElement => _element;
}
