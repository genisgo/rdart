import 'package:rdart/rviews.dart';
part '../bootstrap/css.class/utilities.dart';
part '../bootstrap/css.class/layout.dart';
part 'css.class/components.dart';
part '../bootstrap/css.class/forms.dart';

///Const
const bactive = _BootStrapDefaultImp("active");
const bfade = _BootStrapDefaultImp("fade");
const bdisable = _BootStrapDefaultImp("disable");

abstract class Bootstrap {
  final String? _cname;
  const Bootstrap(this._cname);

  String get cname => _cname!;
  @override
  String toString() {
    return cname;
  }
}

abstract class Bscreen {
  Bootstrap get sm => addScreen("sm");
  Bootstrap get md => addScreen("md");
  Bootstrap get lg => addScreen("lg");
  Bootstrap get xl => addScreen("xl");
  Bootstrap get xxl => addScreen("xxl");
  Bootstrap addScreen(param);
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
