part of 'bs.components.dart';

/// *What is Accordion*, the accordions below to expand/collapse the accordion content.
///  Example
///  ```dart
///  BsAccordion(id: "MyAccordion", item: [
///       BsAccordionItem(
///           show: true,
///           header: BsAccordionHeader(
///               activeColor: Colors.blue, child: Text("Header 1")),
///           body: BsAccordionBody(
///               child: Text(
///                 "Il s'agit du corps d'accordéon du premier article.",
///               ),
///               id: "MyaccordionBody")),
///     ])
///```
class BsAccordion extends Rview {
  List<BsAccordionItem> item;

  ///set [noUseParent]=true attribute on each .accordion-collapse
  /// to make accordion items stay open when another item is opened.
  final bool noUseParent;

  ///Add .accordion-flush to remove the default background-color,
  ///some borders, and some rounded corners to render accordions
  ///edge-to-edge with their parent container.
  final bool useFlush;
  BsAccordion(
      {required String id,
      required this.item,
      this.noUseParent = false,
      this.useFlush = false})
      : super(key: id);
  @override
  Relement build() {
    return BsElement(
        child: Column(singleBootStrap: true, children: item),
        bootstrap: [Baccordion.accordion, if (useFlush) Baccordion.flush],
        dataset: {});
  }

  @override
  void onInitialized() {
    getElement.id = key!;
    if (!noUseParent) {
      for (var element in item) {
        element.parent = key!;
      }
    }
    super.onInitialized();
  }
}

///AccordionItem use to set content for accordion
///``Example``
///  ```dart
///  BsAccordion(id: "MyAccordion", item: [
///       BsAccordionItem(
///           show: true,
///           header: BsAccordionHeader(
///               activeColor: Colors.blue, child: Text("Header 1")),
///           body: BsAccordionBody(
///               child: Text(
///                 "Il s'agit du corps d'accordéon du premier article.",
///               ),
///               id: "MyaccordionBody")),
///     ])
///```
class BsAccordionItem extends Rview {
  BsAccordionHeader header;
  BsAccordionBody body;
  bool show;
  BsAccordionItem(
      {required this.header, required this.body, this.show = false});
  @override
  Relement build() {
    return Column(
        singleBootStrap: true,
        children: [header, body],
        bootstrap: [Baccordion.item]);
  }

  set parent(String parentKey) {
    body.parent = parentKey;
  }

  @override
  void onInitialized() {
    body.headerKey = header.key!;
    header.bodyKey = body.id!;
    //show
    if (show) {
      body.show();
      header.show();
    }

    super.onInitialized();
  }
}

///AccordionBody use to set body content for [BsAccordionItem]
/// [BsAccordionBody.id] is necessary for connected to [BsAccordionHeader]
/// if
///``Example``
///  ```dart
///  BsAccordion(id: "MyAccordion", item: [
///       BsAccordionItem(
///           show: true,
///           header: BsAccordionHeader(
///               activeColor: Colors.blue, child: Text("Header 1")),
///           body: BsAccordionBody(
///               child: Text(
///                 "Il s'agit du corps d'accordéon du premier article.",
///               ),
///               id: "MyaccordionBody")),
///     ])
///```
class BsAccordionBody extends Rview {
  static int _internalId = 0;
  String? id;
  Relement child;
  BsAccordionBody({required this.child, this.id}) {
    _internalId++;
  }

  @override
  Relement build() {
    id ??= "accoridonBody$_internalId";
    return BsElement(
        userParent: true,
        child:
            BsElement(child: child, bootstrap: [Baccordion.body], dataset: {}),
        bootstrap: [
          Baccordion.collapse,
          Bcollapse.collapse,
        ],
        dataset: {},
        attributes: {
          "id": id!,
        });
  }

  set parent(String parentKey) {
    getElement.dataset.addAll({"bs-parent": "#$parentKey"});
  }

  set headerKey(String hkey) {
    getElement.attributes.addAll({"aria-labelledby": hkey});
  }

  void show() {
    getElement.className += " ${Bcollapse.show}";
  }
}

class BsAccordionHeader extends Rview {
  final Relement child;
  int padding;

  Color? activeColor;
  BsAccordionHeader(
      {this.padding = 4,
      String key = "",
      required this.child,
      this.activeColor})
      : super(key: key);

  @override
  void onInitialized() {
    //setActive color
    if (activeColor != null) {
      getElement.style
        ..setProperty("--bs-accordion-active-bg", activeColor?.color)
        ..setProperty("--bs-accordion-btn-padding-x", "${padding}px")
        ..setProperty("--bs-accordion-btn-padding-y", "${padding}px");
    }

    super.onInitialized();
  }

  @override
  Relement build() {
    return Column(
        children: [
          BsElement(
              child: RButton(
                  type: BtnType.button,
                  singleBootStrap: true,
                  child: child,
                  style: RStyle(
                      bootstrap: [Baccordion.button, Baccordion.collapsed])),
              bootstrap: [],
              dataset: {
                "bs-toggle": "${Bcollapse.collapse}",
              },
              attributes: {
                "aria-expanded": "false",
                // "id": key
              })
        ],
        singleBootStrap: true,
        bootstrap: [
          Baccordion.header,
        ]);
  }

  set bodyKey(String bodykey) {
    getElement.children.first.dataset.addAll({"bs-target": "#$bodykey"});
    getElement.children.first.attributes.addAll({
      "aria-controls": bodykey,
    });
    getElement.id = key!;
  }

  show() {
    var headerBtn = getElement.children.first;

    headerBtn.className =
        headerBtn.className.replaceAll(Baccordion.collapsed.cname, "");

    headerBtn.attributes["aria-expanded"] = "true";
  }
}
