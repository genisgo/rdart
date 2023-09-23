part of 'bs.components.dart';

class BsCard extends Rview {
  Relement? header;
  Relement? title;
  Relement? footer;
  Relement? body;
  List<Bootstrap> bodyStyle;
  List<Bootstrap> headerStyle;
  List<Bootstrap> footerStyle;
  List<Bootstrap> cardStyle;

  BsCard(
      {this.header,
      this.body,
      this.footer,
      this.title,
      this.bodyStyle = const [],
      this.footerStyle = const [],
      this.headerStyle = const [],
      this.cardStyle = const []});
  @override
  Relement build() {
    return BsElement(
        child: Column(children: [
          if (header != null)
            _addBsInElement(bs: [bcard.header, ...headerStyle], rview: header),
          if (body != null)
            _addBsInElement(bs: [bcard.body, ...bodyStyle], rview: body),
          if (footer != null)
            _addBsInElement(bs: [bcard.footer, ...footerStyle], rview: footer)
        ]),
        bootstrap: [bcard, ...cardStyle],
        dataset: {});
  }

  Relement _addBsInElement({List<Bootstrap> bs = const [], Relement? rview}) {
    return BsElement(child: rview, bootstrap: bs, dataset: {});
  }

  @override
  void initState() {
    var bsTitle = _addBsInElement(bs: [bcard.title], rview: title).create();

    var headerelement = header?.getElement;

    ///Conter add default margin et padding in element, remove this with
    ///[BContainer.fluid]
    headerelement?.className =
        headerelement.className.replaceAll("container", " ${BContainer.fluid}");

    ///set title in body
    body?.getElement.children.insert(0, bsTitle);
    super.initState();
  }
}
