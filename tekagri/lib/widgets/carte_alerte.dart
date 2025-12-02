import 'package:flutter/material.dart';

/// Widget qui affiche une liste d’alertes sous forme de carte.
///
/// Sources d’inspiration :
/// Documentation officielle Flutter pour Card (material.Card)
///   https://api.flutter.dev/flutter/material/Card-class.html
/// Documentation officielle Flutter pour ListTile (material.ListTile)
///   https://api.flutter.dev/flutter/material/ListTile-class.html
/// Cookbook Flutter – Créer et afficher des listes
///   https://docs.flutter.dev/cookbook/lists/basic-list

class CarteAlerte extends StatelessWidget {
  final List<String> alertes;

  const CarteAlerte({super.key, required this.alertes});

  @override
  Widget build(BuildContext context) {
    // Si le tableau d’alertes est vide, on affiche un message simple.
    if (alertes.isEmpty) {
      return const Card(
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Aucune alerte pour le moment.'),
        ),
      );
    }

    // Sinon, on crée une liste de widgets à partir des alertes.
    final List<Widget> widgetsAlertes = [];
    for (String alerte in alertes) {
      widgetsAlertes.add(
        ListTile(
          leading: const Icon(Icons.warning, color: Colors.red),
          title: Text(alerte),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Alertes météo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...widgetsAlertes,
        ],
      ),
    );
  }
}
