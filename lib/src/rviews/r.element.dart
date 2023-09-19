part of 'rview_bases.dart';

abstract class Relement {
  static int registrerElementID = 0;
  //generate id
  static int _idgenerate = 0;
  final String? key;
  const Relement({this.key});

  Element create();
  Element get getElement;
  int get generateId => _idgenerate++;
}

abstract class Rview extends Relement {
  late Relement _relement;
  Rview({String? key}) : super(key: key) {
    _relement = build();
    Future.delayed(Duration.zero, () => onInitialized());
  }

  ///build creat Element
  Relement build();

  ///On initialized
  void onInitialized() {}
  @override
  Element create() {
    return _relement.create();
  }

  void setState(void Function() state) {
    Future.delayed(
      Duration.zero,
      () {
        state();

        getElement.parent?.children.add(build().create());
        getElement.parent?.children.remove(getElement);
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
