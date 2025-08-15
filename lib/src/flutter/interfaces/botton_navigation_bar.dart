part of 'interfaces.dart';

abstract class BottomNavigationBarI extends Relement {
  BottomNavigationBarI({super.id});
  int get currentIndex;
  set currentIndex(int value);
}

/// FloatingActionButton abstrait.
/// Implémentations attendues : icône/label + onPressed.
typedef VoidCallback = void Function();

abstract class FloatingActionButtonI extends Relement {
  FloatingActionButtonI({super.id});
  VoidCallback? get onPressed;
} 