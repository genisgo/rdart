import 'package:rdart/rviews.dart' hide SizedBox, Text;
import 'package:rdart/bootstrap.dart';
import 'package:rdart/flutter_widgets.dart' hide Column;

class SimpleCounterPage extends Rview {
  SimpleCounterPage();

  int count = 0;

  @override
  Relement build() {
    return Page(
      appBar: AppBar(title: "Simple Compteur"),
      body: Column(
        crossAxisAlignment: AlignVertical.center,
        mainAxisAlignment: AlignHorizontal.center,
        children: [
          Text(
            "Valeur du compteur : $count",
            bootstrap: [Bcolor.bgPrimary.text],
          ),
          SizedBox(height: 24),
          RButton(
            singleBootStrap: true,
            style: RStyle(bootstrap: [Btn.btn, Btn.success, Bpadding.p2]),
            child: Text("Incrémenter"),
            onPress: (_) {
              count++;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
