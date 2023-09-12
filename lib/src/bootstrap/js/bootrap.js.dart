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
  external Modal(Element element);
  external show();
  external hide(); 
}