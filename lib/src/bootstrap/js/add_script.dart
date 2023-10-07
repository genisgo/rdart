part of 'bootrap.js.dart';

List<ScriptElement> bootstrapScript() {
  ScriptElement poper = ScriptElement();
  ScriptElement bsc = ScriptElement();
  ScriptElement ne = ScriptElement();

  //poper  <script type="text/javascript" charset="utf-8" async="" data-requirecontext="_" data-requiremodule="packages/rdart/bootstrap" src="/packages/rdart/src/rviews/js/native.js"></script>
  ne.setAttribute("type", "text/javascript");
  ne.setAttribute("charset", "utf-8");
  ne.setAttribute("async", "");
  ne.setAttribute("data-requirecontext", "_");
  ne.setAttribute("data-requiremodule", "packages/rdart/bootstrap");
  ne.src =
      "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js";

  ne.crossOrigin = "anonymous";

  poper.src =
      "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js";
  poper.integrity =
      "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r";
  poper.crossOrigin = "anonymous";
//boostrap
  bsc.src =
      "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js";
  bsc.integrity =
      "sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+";
  bsc.crossOrigin = "anonymous";
  return [ne];
}

void activeBootStrap() {
  document.head?.children.addAll([
    LinkElement()
      ..crossOrigin = "anonymous"
      ..href =
          "https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css"
      ..rel = "stylesheet"
      ..integrity =
          "sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9",
  ]);
}
