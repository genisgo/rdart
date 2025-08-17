part of 'interfaces.dart';

/// ------------------------------------------------------------
/// ABSTRACTIONS (interfaces)
/// ------------------------------------------------------------

/// Drawer abstrait (côté gauche par convention, comme Flutter `drawer:`)
abstract class RDrawer extends Relement {
  RDrawer({super.id});

  /// Callback que l’implémentation peut invoquer (bouton X, clic élément de menu)
  /// pour demander la fermeture du drawer.
  DrawerVoidCallback? get onRequestClose;
  set onRequestClose(DrawerVoidCallback? cb);
  
}

/// EndDrawer abstrait (côté droit, comme Flutter `endDrawer:`)
abstract class REndDrawer extends Relement {
  REndDrawer({super.id});

  DrawerVoidCallback? get onRequestClose;
  set onRequestClose(DrawerVoidCallback? cb);
}

/// ------------------------------------------------------------
/// SOUS-COMPOSANTS (utiles pour les implémentations par défaut)
/// ------------------------------------------------------------

typedef DrawerVoidCallback = void Function();