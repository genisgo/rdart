part of 'utils.dart';
// background_enums.dart
enum BackgroundSize { cover, contain, auto, fill, none, scaleDown }
enum BackgroundPosition {
  center,
  topLeft, topCenter, topRight,
  centerLeft, centerRight,
  bottomLeft, bottomCenter, bottomRight,
}
enum BackgroundRepeat { noRepeat, repeat, repeatX, repeatY }

String bgSizeToCss(BackgroundSize v) {
  switch (v) {
    case BackgroundSize.cover: return 'cover';
    case BackgroundSize.contain: return 'contain';
    case BackgroundSize.auto: return 'auto';
    case BackgroundSize.fill: return '100% 100%';
    case BackgroundSize.none: return 'auto';         // équiv. pratique
    case BackgroundSize.scaleDown: return 'scale-down';
  }
}

String bgPosToCss(BackgroundPosition v) {
  switch (v) {
    case BackgroundPosition.center: return '50% 50%';
    case BackgroundPosition.topLeft: return '0% 0%';
    case BackgroundPosition.topCenter: return '50% 0%';
    case BackgroundPosition.topRight: return '100% 0%';
    case BackgroundPosition.centerLeft: return '0% 50%';
    case BackgroundPosition.centerRight: return '100% 50%';
    case BackgroundPosition.bottomLeft: return '0% 100%';
    case BackgroundPosition.bottomCenter: return '50% 100%';
    case BackgroundPosition.bottomRight: return '100% 100%';
  }
}

String bgRepeatToCss(BackgroundRepeat v) {
  switch (v) {
    case BackgroundRepeat.noRepeat: return 'no-repeat';
    case BackgroundRepeat.repeat: return 'repeat';
    case BackgroundRepeat.repeatX: return 'repeat-x';
    case BackgroundRepeat.repeatY: return 'repeat-y';
  }
}