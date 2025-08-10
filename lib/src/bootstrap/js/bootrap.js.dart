@JS("bootstrap")
library bootstrapJs;

import 'dart:html';
import 'dart:js_interop';
part 'add_script.dart';

// class Carousel {
//   external Carousel(element, config);
//   external cycle();
// }
@JS("Carousel")
@staticInterop
class Carousel {
  external factory Carousel(Element element, [JSObject? config]);
}

extension CarouselExtension on Carousel {
  external void cycle();
  external void dispose();
  external void pause();
}

// @JS("Modal")
// class Modal {
//   external Modal(id, config);
//   external show();
//   external hide();
// }
@JS("Modal")
@staticInterop
class Modal {
  external factory Modal(JSAny elementOrSelector, [JSObject? config]);
}

extension ModalExtension on Modal {
  external void show();
  external void hide();
}

// @JS("Tab")
// class Tab {
//   external Tab(id);
//   external show();
//   external hide();
// }

// @JS("Offcanvas")
// class Offcanvas {
//   external Offcanvas(id);
//   external show();
//   external hide();
// }

// @JS("Toast")
// class Toast {
//   external Toast(id, config);
//   external show();
//   external hide();
//   external static Toast getOrCreateInstance(element);
// }

// @JS("Popover")
// class Popover {
//   external Popover(id, config);
//   external show();
//   external hide();
//   external static Popover getOrCreateInstance(element);
// }

// @JS("Tooltip")
// class Tooltip {
//   external Tooltip(id, config);
//   external show();
//   external hide();
//   external static Tooltip getOrCreateInstance(element);
// }

// ---------------------------
// Tab
// ---------------------------
@JS("Tab")
@staticInterop
class Tab {
  external factory Tab(JSAny elementOrSelector);
}

extension TabExtension on Tab {
  external void show();
  external void hide();
}

// ---------------------------
// Offcanvas
// ---------------------------
@JS("Offcanvas")
@staticInterop
class Offcanvas {
  external factory Offcanvas(JSAny elementOrSelector);
}

extension OffcanvasExtension on Offcanvas {
  external void show();
  external void hide();
}

// ---------------------------
// Toast
// ---------------------------
@JS("Toast")
@staticInterop
class Toast {
  external factory Toast(JSAny elementOrSelector, [JSObject? config]);
  external static Toast getOrCreateInstance(JSAny element);
}

extension ToastExtension on Toast {
  external void show();
  external void hide();
}

// ---------------------------
// Popover
// ---------------------------
@JS("Popover")
@staticInterop
class Popover {
  external factory Popover(JSAny elementOrSelector, [JSObject? config]);
  external static Popover getOrCreateInstance(JSAny element);
}

extension PopoverExtension on Popover {
  external void show();
  external void hide();
}

// ---------------------------
// Tooltip
// ---------------------------
@JS("Tooltip")
@staticInterop
class Tooltip {
  external factory Tooltip(JSAny elementOrSelector, [JSObject? config]);
  external static Tooltip getOrCreateInstance(JSAny element);
}

extension TooltipExtension on Tooltip {
  external void show();
  external void hide();
}