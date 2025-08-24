# 🌐 Rdart

**Rdart** est un framework UI expérimental en **Dart** inspiré de **Flutter**, mais conçu pour le **Web**.  
Il fournit une API déclarative (`Rview`, `Relement`) et des composants modernes (`Scaffold`, `AppBar`, `Form`, `Toast`, etc.) rendus directement dans le navigateur.

⚠️ **Rdart est en développement actif et n’est pas encore publié sur [pub.dev](https://pub.dev).**  

---

## Objectifs

- Reprendre la **philosophie Flutter** (widgets déclaratifs, arbre de vues, état réactif).  
- Fournir des **composants prêts à l’emploi** pour le web : navigation, formulaires, toasts, carrousels.  
- Permettre une **interopérabilité facile avec le DOM et JavaScript** (`dart:html`, `package:web`).  
- Être **léger et extensible** pour des projets modernes en Dart web.

---

## Installation

Comme Rdart n’est pas encore publié sur `pub.dev`, ajoute-le directement depuis GitHub dans ton `pubspec.yaml` :

```yaml
dependencies:
  rdart:
    git:
      url: https://github.com/genisgo/rdart.git
```

Puis :

```bash
dart pub get
```

---

## ⚡ Exemple rapide

### `main.dart`
```dart
import 'package:rdart/rviews.dart';
import 'package:rdart/bootstrap.dart';

class CounterPage extends Rview {
  static final String url = "counter";
  int count = 0;

  @override
  Relement build() {
    return Scaffold(
      appBar: AppBar(title: "Compteur"),
      body: Center(
        child: Column(
          gap: 16,
          children: [
            Text("Valeur : $count", fontSize: 24),
            ElevatedButton(
              label: Text("Incrémenter"),
              onPressed: () {
                count++;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main(List<String> args) {
  Rapp(
    router: GoRouter(
      routes: [
        Rroute(url: CounterPage.url, page: (_) => CounterPage()),
      ],
      home: Rroute(url: "/", page: (_) => CounterPage()),
    ),
  );
}
```

---

## 📚 Composants déjà disponibles

- **Structure** : `Scaffold`, `AppBar`, `Drawer`, `BottomNavigationBar`.  
- **UI** : `Button`, `Toast`, `Dialog`, `ProgressIndicator`, `Carousel`.  
- **Formulaires** : `TextField`, `DropdownFormField`, `CheckBox`, `RadioGroup`, `Slider`.  
- **Layout** : `Row`, `Column`, `Stack`, `Align`, `Center`, `Wrap`.  

---

## 📂 Exemples

➡️ Voir le dépôt compagnon [rdart-exemple](https://github.com/genisgo/rdart-exemple) pour une galerie complète de composants en action :  
- Boutons  
- Formulaires  
- Toasts  
- Carrousels  
- Dialogs  
- Layouts  

---

## 🛣️ Roadmap

- [ ] Stabiliser les API de base (`Rview`, `Relement`, `Scaffold`).  
- [ ] Améliorer les formulaires (validation, contrôleurs).  
- [ ] Ajouter plus de composants Material/Bootstrap.  
- [ ] Publier sur **pub.dev** 🎉  

---

## 📜 Licence

Projet open-source sous licence **MIT**.  
Libre à vous de l’utiliser et de contribuer.

---

👉 Avec **Rdart**, construis des applications Web modernes en Dart, en gardant la simplicité de Flutter 🚀.
