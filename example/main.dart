import 'package:rdart/bootstrap.dart';
import 'package:rdart/rviews.dart';
void main() {
  int counter = 0;

  final counterStyle = RStyle(
    textSize: 24,
    color: Colors.primary,
    bootstrap: [],
  );

  final counterText = Text(
    'Compteur : $counter',
    style: counterStyle,
    id: 'counterText',
  );

  final incrementButton = BsElement(
    bootstrap: [Btn.btn, Btn.primary, Btn.lg],
    child: Text('Incrémenter'),
    userParent: true,
  );

  incrementButton.create().onClick.listen((event) {
    counter++;
    counterText.text = 'Compteur : $counter';
    counterText.create();
  });

  final aboutButton = BsElement(
    bootstrap: [Btn.btn, Btn.secondary, Btn.sm],
    child: Text('À propos'),
    userParent: true,
  );

  aboutButton.create().onClick.listen((event) {
   rnavigator.push('/about');
  });

  final homePage = Page(
    appBar: AppBar(title: Text('Démo Compteur', style: RStyle(textSize: 18))),
    body: Column(
      children: [
        counterText,
        SizeBox(height: 20),
        incrementButton,
        SizeBox(height: 20),
        aboutButton,
      ],
      mainAxisAlignment: AlignHorizontal.center,
      crossAxisAlignment: AlignVertical.center,
    ),
    bootstrap: [],
  );

  final aboutPage = Page(
    appBar: AppBar(title: Text('À propos', style: RStyle(textSize: 18))),
    body: Text('Ceci est la page à propos.', style: RStyle(textSize: 20)),
    bootstrap: [],
  );

  // Définition des routes
  final routeList = [
    Rroute(url: '/', page: (data) => homePage),
    Rroute(url: '/about', page: (data) => aboutPage),
  ];

  // Lancement de l'application avec Rapp et GoRouter
  Rapp(router: GoRouter(routes: routeList, home: routeList.first));
}