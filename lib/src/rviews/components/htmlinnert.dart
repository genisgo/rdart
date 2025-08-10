part of '../rview_bases.dart';

/// HtmlInnert : composant pour insérer du HTML brut
class HtmlInnert extends Relement {
  String _html;
  HtmlInnert({required String html, super.id}) : _html = html;

  String get gethtml => _html;

  set html(String value) {
    _html = value;
  }

  final _element = Element.div();
  @override
  Element create() {
    //Delete all old children.
    _element.children.clear();

    final parse = Element.div();
    final cleanHtml = StringBuffer(decodeHtmlEntities(_html)).toString();
    parse.innerHtml = cleanHtml;
    _element.children.add(parse);

    return _element;
  }

  @override
  // TODO: implement getElement
  Element get getElement => _element;
}
