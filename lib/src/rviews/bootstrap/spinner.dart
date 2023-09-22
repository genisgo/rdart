part of 'bs.components.dart';

enum BspinnerType {
  border,
  grow,
}

class BsSpinner extends Rview {
  /// Use the [bspinnerBorder] and [bspinnerGrow]
  List<Bootstrap> bootstraps;
  BspinnerType type;
  Relement? child;
  BsSpinner(
      {this.bootstraps = const [],
      this.type = BspinnerType.border,
      this.child});

  @override
  Relement build() {
    return BsElement(child: child, userParent: true, bootstrap: [
      switch (type) { BspinnerType.grow => bspinnerGrow, _ => bspinnerBorder },
      ...bootstraps
    ], attributes: {
      "role": "status"
    });
  }
}
