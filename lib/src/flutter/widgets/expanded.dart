part of 'widgets.dart';

/// Raccourci de Flexible avec fit = tight (comme Flutter).
class Expanded extends Flexible {
  Expanded({required Relement child, int flex = 1, String? id})
    : super(child: child, flex: flex, fit: FlexFit.tight, id: id);
}
