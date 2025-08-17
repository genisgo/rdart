part of 'utils.dart';

/// =============================================================
/// Wrap (Flutter-like)
/// =============================================================

enum Axis { horizontal, vertical }

enum WrapAlignment {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

enum WrapCrossAlignment { start, end, center, stretch }

/// Direction horizontale (pour Axis.horizontal)
enum TextDir { ltr, rtl }

/// Sens vertical des lignes (pour Axis.horizontal) ou colonnes (Axis.vertical)
/// - down: runs empilés du haut vers le bas (wrap normal)
/// - up: runs empilés du bas vers le haut (wrap-reverse)
enum RunsDirection { down, up }
