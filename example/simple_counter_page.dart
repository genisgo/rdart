
import 'package:rdart/rdart.dart';

class SimpleCounterPage extends Rview {
  SimpleCounterPage();

  int count = 0;

  @override
  Relement build() {
    return Page(
      appBar: AppBar(title: Text("Simple Compteur")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
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
