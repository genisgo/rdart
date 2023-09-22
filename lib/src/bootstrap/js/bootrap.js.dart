@JS("bootstrap")
library bootstrapJs;

import 'dart:html';
import 'dart:js_interop';

@JS("Carousel")
class Carousel {
  external Carousel(element, config);
  external cycle();
}

@JS("Modal")
class Modal {
  external Modal(id, config);
  external show();
  external hide();
}

@JS("Tab")
class Tab {
  external Tab(id);
  external show();
  external hide();
}

@JS("Offcanvas")
class Offcanvas {
  external Offcanvas(id);
  external show();
  external hide();
}

@JS("Toast")
class Toast {
  external Toast(id, config);
  external show();
  external hide();
  external static Toast getOrCreateInstance(element);
}
@JS("Popover")
class Popover {
  external Popover(id, config);
  external show();
  external hide();
  external static Popover getOrCreateInstance(element);
}
@JS("Tooltip")
class Tooltip {
  external Tooltip(id, config);
  external show();
  external hide();
  external static Tooltip getOrCreateInstance(element);
}

