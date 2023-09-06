@JS("bootstrap")
library bootstrapJs;

import 'dart:js_interop';

@JS("Carousel")
class Caroucel {
  external Caroucel(element, config);
  external cycle();
}
