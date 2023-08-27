
part 'layout.dart';
part 'utilities.dart';
part 'components.dart';
abstract class Bootstrap {
  final String? cname;
  const Bootstrap(this.cname);
  @override
  String toString() {
    // TODO: implement toString
    return "$cname";
  }
}

abstract class Bscreen {
  Bootstrap get sm;
  Bootstrap get md;
  Bootstrap get lg;
  Bootstrap get xl;
  Bootstrap get xxl;
  Bootstrap _addScreen(param);
}
