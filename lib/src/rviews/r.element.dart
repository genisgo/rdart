part of 'rview_bases.dart';

abstract class Relement {
  static int registrerElementID = 0;
  //generate id
  static int _idgenerate = 0;
  final String? key;
  const Relement({this.key});

  Element create();

  Future ondispose() {
    return Future.value();
  }

  Element get getElement;
  int get generateId => _idgenerate++;
}

abstract class Rview extends Relement {
  late Relement _relement;
  Rview({String? key}) : super(key: key) {
    ///ondispose est cree pour eviter l'attachement des element appres suppression
    ///Comme les listener [sEventListener]
    ondispose();

    _relement = build();

    Future.delayed(Duration.zero, () => initState());
  }

  ///On initialized
  void initState() {}

  ///build creat Element
  Relement build();

  @override
  Element create() {
    return _relement.create();
  }

  void setState(void Function() state) {
    Future.delayed(
      Duration.zero,
      () {
        Element old = getElement;
        var oldParent = old.parent;
        var oldIndex = oldParent!.children.indexOf(old);

        state();
        _relement = build();
        _relement.create();
        oldParent.children.remove(old);
        oldParent.children.insert(oldIndex, getElement);
      },
    );
  }

  @override
  Element get getElement => _relement.getElement;
}

//definition du type de
typedef RelementCallBack(Relement element);

abstract class BootStrapComponent extends Relement {
  final List<Bootstrap> bootstraps;
  final Map<String, String> dataset;
  final Map<String, String> attributes;
  const BootStrapComponent(this.bootstraps, this.dataset, this.attributes);
  bootstrap();
}
