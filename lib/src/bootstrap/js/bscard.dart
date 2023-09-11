@JS("bootstrap")
library bootstrapJs;

import 'dart:js_interop';

@JS("Carousel")
class Carousel {
  external Carousel(element, config);
  external cycle();
}
