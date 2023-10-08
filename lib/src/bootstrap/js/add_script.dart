part of 'bootrap.js.dart';

List<ScriptElement> bootstrapScript() {
  ScriptElement poper = ScriptElement();
  ScriptElement bscript = ScriptElement();

  //boostrap //poper  <script type="text/javascript" charset="utf-8" async="" data-requirecontext="_" data-requiremodule="packages/rdart/bootstrap" src="/packages/rdart/src/rviews/js/native.js"></script>
  bscript.setAttribute("type", "text/javascript");
  bscript.setAttribute("charset", "utf-8");
  bscript.setAttribute("async", "");
  bscript.setAttribute("data-requirecontext", "_");
  bscript.setAttribute("data-requiremodule", "packages/rdart/bootstrap");
  bscript.src = "packages/rdart/src/bootstrap/lib/js/bootstrap.bundle.min.js";
 
   //bscript.crossOrigin = "anonymous";
  // poper.src =
  //     "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js";
  // poper.integrity =
  //     "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r";
  // poper.crossOrigin = "anonymous";

  return [
    bscript,
  ];
}

void activeBootStrap() {
  document.head?.children.addAll([
    LinkElement()
      ..href = "packages/rdart/src/bootstrap/lib/css/bootstrap.min.css"
      ..rel = "stylesheet"
  ]);
}
