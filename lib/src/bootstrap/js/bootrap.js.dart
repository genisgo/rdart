@JS("bootstrap")
library bootstrapJs;

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
