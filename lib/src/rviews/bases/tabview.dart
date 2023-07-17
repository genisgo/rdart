part  of '../rview_bases.dart';
class TabView extends Rview {
  TabBar tabBar;
  List<Relement> tabPage;
  TabView({required this.tabBar, required this.tabPage});

  Container currentPage = Container(
      child: Text("Accun contenu"),
      style: RStyle(
        width: 100,ratioHeight: true,ratioWidth: true,
        height: 100,
      ));

  @override
  Relement build() {
    return Column(children: [tabBar, currentPage], mainAxisExpand: true);
  }

  @override
  void onInitialized() {
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

_setDefaultTabPage(){
  currentPage.getElement.children.clear();
  if(tabPage.isNotEmpty){
    currentPage.child = tabPage.first; 
    currentPage.create();
  }
}
  _setOnselectCallBack() {

    tabBar.onTabSelected = (indx) {
      print("page $indx");
      
      currentPage.getElement.children.clear();
      currentPage.child=tabPage[indx]; 
      currentPage.create(); 

      //  currentPage.create();
    };
  }
}

class TabBar extends Rview {
  List<Tab> tabs;
  int? height;
  Relement? titre;
  Relement? flexContent;
  Color selectorColor;
  Function(int indx)? onTabSelected;
  int defaultTabIndex;
  Color backgroundColor;
  TabBar(
      {required this.tabs,
      this.height,
      this.backgroundColor = Colors.primaryColor,
      this.defaultTabIndex = 0,
      this.selectorColor = Colors.White,
      this.titre,
      this.flexContent});
  @override
  Relement build() {
    return Container(
        style: RStyle(
            height: height ?? 0,
            ratioWidth: true,
            decoration: Decoration(
              shadow: BoxShadow(blur: 5),
              backgroundColor: backgroundColor,
            ),
            width: 100,
            backgroundColor: Colors.Black),
        child: Column(children: [
          if (titre != null) titre!,
          Row(children: tabs, crossAxisAlignment: AlignVertical.bottom)
        ]));
  }

  @override
  void onInitialized() {
    _setIdTabBar();
    _selectionTab();
    setDefaultActiveTab(defaultTabIndex);
  }

//
  void _selectionTab() {
    for (var index = 0; index < tabs.length; index++) {
      tabs[index].getElement.id = "${getElement.id} $index";
      tabs[index].color = backgroundColor;
      tabs[index]._selectorColor = selectorColor;

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
  Color color;
  REdgetInset padding ;
  Function(Tab)? _onActive;
  bool _isActive = false;
  Color _selectorColor = Colors.white;
  int? width;
  int? height;
  Tab({
    required this.child,
    this.color = Colors.primaryColor,
    this.padding =REdgetInset.zero,
    this.height,
    this.width,
  });
  late RButton _relement;
  late var _element;

  RStyle getStyle() {
    return RStyle(
      ratioWidth: true,
      width: width ?? 100,
      height: height ?? 100,
      padding: padding,
      ratioHeight: true,
      decoration: Decoration(
       
          backgroundColor: color,
          border: _isActive
              ? Rborder(
                  bottom: BorderSide(
                      color: _selectorColor, side: 4, style: BorderStyle.solid),
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
          getStyle().createStyle(_relement.getElement);
        },
        style: getStyle());

    _element = _relement.create()..className = ClassName.tabBtn.name;
    return _element;
  }

  @override
  Element get getElement => _element;
}
