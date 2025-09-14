
import 'package:rdart/rdart.dart';

void main() {
  int counter = 0;

  final counterText = Text(
    'Compteur : $counter',
    fontSize: 24,
    color: Colors.primary,
    id: 'counterText',
  );

  final incrementButton = BsElement(
    bootstrap: [Btn.btn, Btn.primary, Btn.lg],
    child: Text('Incrémenter'),
    userParent: true,
  );

  incrementButton.create().onClick.listen((event) {
    counter++;
    counterText.data = 'Compteur : $counter';
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
    appBar: AppBar(title: Text('Démo Compteur')),
    body: Column(
      children: [
        counterText,
        SizeBox(height: 20),
        incrementButton,
        SizeBox(height: 20),
        aboutButton,
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
    bootstrap: [],
  );

  final aboutPage = Page(
    appBar: AppBar(title: Text('À propos')),
    body: Text('Ceci est la page à propos.', fontSize: 20),
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
