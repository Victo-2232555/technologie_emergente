import 'package:flutter/material.dart';
import 'ecrans/tableau_bord.dart';
import 'ecrans/alertes.dart';
import 'ecrans/recommandations.dart';

/// Point d’entrée de l’application TekAgri.
///
/// SOURCES D’INSPIRATION :
///
/// Voir les liens ci-dessous
///
/// Ces ressources ont inspiré :
/// la structure générale de l’application (MaterialApp + Scaffold),
/// l’utilisation d’une barre de navigation inférieure (BottomNavigationBar),
/// la gestion de l’index d’onglet avec un StatefullWidget,
/// l’organisation en plusieurs écrans : tableau de bord, alertes, recommandations.
///
void main() {
  runApp(const ApplicationTekAgri());
}

/// Widget racine de l’application
class ApplicationTekAgri extends StatefulWidget {
  const ApplicationTekAgri({super.key});

  @override
  State<ApplicationTekAgri> createState() => _ApplicationTekAgriState();
}

class _ApplicationTekAgriState extends State<ApplicationTekAgri> {
  /// Index de l’onglet sélectionné (0 = tableau de bord, 1 = alertes, 2 = recommandations)
  int _indexOnglet = 0;

  /// Tableau contenant les écrans principaux de l’application
  final List<Widget> _ecrans = const [
    EcranTableauBord(),
    EcranAlertes(),
    EcranRecommandations(),
  ];

  /// MaterialApp : https://api.flutter.dev/flutter/material/MaterialApp-class.html
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TekAgri',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,

      /// Scaffold : https://api.flutter.dev/flutter/material/Scaffold-class.html
      home: Scaffold(
        /// AppBar : https://api.flutter.dev/flutter/material/AppBar-class.html
        appBar: AppBar(title: const Text('TekAgri - Agriculture intelligente')),
        body: _ecrans[_indexOnglet],

        /// BottomNavigationBar : https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indexOnglet,
          onTap: (int nouvelIndex) {
            // Quand on change d’onglet, on met à jour l’index
            setState(() {
              _indexOnglet = nouvelIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Tableau de bord',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Alertes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tips_and_updates),
              label: 'Conseils',
            ),
          ],
        ),
      ),
    );
  }
}
