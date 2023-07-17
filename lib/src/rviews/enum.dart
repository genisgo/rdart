part of 'rview_bases.dart';
//Border style
enum BorderStyle {
  none,
  dashed,
  double,
  solid,
  dotted,
  outset,
  ridge,
  groove,
  inset
}
enum ClassName{
  tabBtn,
  tabBar,
  tabPage,
  page
  ;
}
enum AligmentHorizontal {
  ///alignement a droite
  right("flex-end"),

  ///Alignment au centre Horizontalement
  center("center"),

  ///Alignment a gauche
  left("flex-start"),

  ///Espace entre les element
  spaceBetween("space-between"),

  ///Espacement justifier des elements
  spaceAround("space-around"),
  //Desactiver
  none("unset");

  const AligmentHorizontal(this.value);
  final String value;
}

enum AlignmentVertical {
  ///alignement a haut
  top("start"),

  ///Alignment au centre Verticalement
  center("center"),

  ///Alignment en bas
  bottom("end"),

  ///Espace entre les elements verticalement justifier
  stretch("stretch"),

  ///Espacement justifier des elements
  spaceAround("space-around"),
  //Desactiver
  none("unset");

  const AlignmentVertical(this.value);
  final String value;
}

enum TextAlign {
  ///centre le text
  center("center"),

  ///Ajuster le contenu
  justify("justify"),

  ///Mettre a gauche
  left("left"),

  ///mettre a gauche
  right("right"),

  ///Aligner à la fin
  end("end"),

  ///Desactiver alignement
  unset("unset"),

  ///Aligner au debut
  start("start");

  ///
  const TextAlign(this.value);
  final String value;
}
