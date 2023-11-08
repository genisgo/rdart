part of 'rview_bases.dart';

abstract class Relement {
  static int registrerElementID = 0;
  //generate id
  static int _idgenerate = 0;
  final String? id;
  const Relement({required this.id});
  Element create();

  Future ondispose() {
    return Future.value();
  }

  Element get getElement;
  int get generateId => _idgenerate++;
}

abstract class Rview extends Relement {
  late Element _relement;
  List<String> className;
  Rview({String? id, this.className = const []}) : super(id: id) {
    ///ondispose
    /// est cree pour eviter l'attachement des element appres suppression
    ///Comme les listener [sEventListener]

    // Future.delayed(Duration.zero, () => initState());
  }

  ///On initialized
  void initState() {}
  void onUpdate(Element old) {}

  ///build creat Element
  Relement build();

  @override
  Element create() {
    _relement = build().create();
    //Set id
    if (id != null) _relement.id = id!;
    initState();
    //set custom className
    if (className.isNotEmpty) _relement.className += " ${className.join(" ")}";
    return _relement;
  }

  void setState(void Function() state) {
    Element old = getElement;
    var oldParent = old.parent;
    var oldIndex = oldParent!.children.indexOf(old);
    Future.delayed(
      Duration.zero,
      () {
        state();
        _relement = build().create();
        oldParent.children.remove(old);
        oldParent.children.insert(oldIndex, getElement);
        //iniEvent();
      },
    ).then((value) {
      onUpdate(old);
    });
  }

  @override
  Element get getElement => _relement;
}

//definition du type de
typedef RelementCallBack(Relement element);

abstract class BootStrapComponent extends Relement {
  final List<Bootstrap> bootstraps;
  final Map<String, String> dataset;
  final Map<String, String> attributes;

  const BootStrapComponent(
      this.bootstraps, this.dataset, this.attributes, String? id)
      : super(id: id);
  bootstrap();
}
