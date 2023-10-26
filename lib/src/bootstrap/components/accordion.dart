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
      : super(id: id);
  @override
  Relement build() {
    return BsElement(
        child: Column(singleBootStrap: true, children: item),
        bootstrap: [Baccordion.accordion, if (useFlush) Baccordion.flush],
        dataset: {});
  }

  @override
  void initState() {
    getElement.id = id!;
    if (!noUseParent) {
      for (var element in item) {
        element.parent = id!;
      }
    }
    super.initState();
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
      {required this.header, required this.body, this.show = false, super.id});
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
  void initState() {
    body.headerKey = header.id!;
    header.bodyKey = body._ids;
    //show
    if (show) {
      body.show();
      header.show();
    }

    super.initState();
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
  Relement child;
  late String _ids;
  BsAccordionBody({required this.child, super.id}) {
    _ids = id ?? "accoridonBody$generateId";
  }

  @override
  Relement build() {
    //set

    return BsElement(
        id: _ids,
        userParent: true,
        child:
            BsElement(child: child, bootstrap: [Baccordion.body], dataset: {}),
        bootstrap: [
          Baccordion.collapse,
          Bcollapse.collapse,
        ],
        dataset: {},
        attributes: {
          "id": _ids,
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
      {this.padding = 4, String id = "", required this.child, this.activeColor})
      : super(id: id);

  @override
  void initState() {
    //setActive color
    if (activeColor != null) {
      getElement.style
        ..setProperty("--bs-accordion-active-bg", activeColor?.color)
        ..setProperty("--bs-accordion-btn-padding-x", "${padding}px")
        ..setProperty("--bs-accordion-btn-padding-y", "${padding}px");
    }

    super.initState();
  }

  @override
  Relement build() {
    return Column(
        children: [
          BsElement(
              id: id,
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
    if (id != null) getElement.id = id!;
  }

  show() {
    var headerBtn = getElement.children.first;

    headerBtn.className =
        headerBtn.className.replaceAll(Baccordion.collapsed.cname, "");

    headerBtn.attributes["aria-expanded"] = "true";
  }
}
