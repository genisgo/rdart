part of 'widgets.dart';

/// =============================================================
/// Center : simple alias d'Align(center)
/// =============================================================
class Center extends Align {
  Center({
    Relement? child,
    bool expand = false,
    String? id,
    List<String> bootstrap = const [],
  }) : super(
         child: child,
         alignment: Alignment.center,
         expand: expand,
         id: id,
         bootstrap: bootstrap,
       );
}
