part of 'rview_bases.dart';
abstract class Relement {
  static int registrerElementID = 0;
  const Relement();

  Element create();
  Element get getElement;
}

 mixin RState  {
 void setState(){

 }
}
abstract class Rview extends Relement with RState {
  late Relement _relement;
  Rview() {
    _relement = build();
    Future.delayed(
      Duration.zero,() =>onInitialized()
     
    );
  }

  ///build creat Element
  Relement build();

  ///On initialized
  void onInitialized() {}
  @override
  Element create() {
    return _relement.create();
  }
  @override
  void setState() {
    
    super.setState();
  }
  @override
  Element get getElement => _relement.getElement;
}

//definition du type de
typedef RelementCallBack(Relement element);
