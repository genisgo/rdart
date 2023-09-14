import 'package:rdart/bootstrap.dart';
import 'package:rdart/rviews.dart';

part 'layout.dart';
part 'utilities.dart';
part 'components.dart';
///Const
const bactive = _BootStrapDefaultImp("active");

abstract class Bootstrap {
  final String? _cname;
  const Bootstrap(this._cname);

  String get cname => _cname!;
  @override
  String toString() {
    // TODO: implement toString
    return cname;
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

///Utiliser pour permetre instanciation interne
class _BootStrapDefaultImp extends Bootstrap {
  const _BootStrapDefaultImp(super.cname);
}

Bootstrap _defaultAddScreen(String param, String cname, [int index = 1]) {
  var spleted = cname.split("-");
  spleted.insert(index, param);
  return Brow._(spleted.toSet().join("-"));
}
