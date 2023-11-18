part of 'rview_bases.dart';

abstract class Relement {
  static int registrerElementID = 0;
  //generate id
  static int _idgenerate = 0;
  final String? id;
  const Relement({required this.id});
  Element create();

  dispose() {}

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
    ///Clean for lastChildreen sinon cela cree des doublons d'objet souvent
    _cleanRview();

    ///Cree une  de rview render
    _relement = build().create();
    //Set id
    if (id != null) _relement.id = id!;
    initState();
    //set custom className
    if (className.isNotEmpty) _relement.className = " ${className.join(" ")}";
    return _relement;
  }

//// netoyage des [Element] dont les enfants reste
  ///attacher malgre la mise a zero par le [setState]
  ///ceci est une solution temporaire
  void _cleanRview() {
    try {
    getElement.children.clear();
    } catch (e) {
      log(
        "$e",
        error: e,stackTrace: StackTrace.current
      );
    }
  }

  void setState(void Function() state) {
    Element old = getElement;

    Future.delayed(
      Duration.zero,
      () {
        var oldParent = old.parent;

        state();
        _relement = build().create();
        //dispose();
        var oldIndex = oldParent?.children.indexOf(old);
        oldParent?.children.remove(old);
        oldParent?.children.insert(oldIndex ?? -1, getElement);
        if (oldParent != null) {}
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
