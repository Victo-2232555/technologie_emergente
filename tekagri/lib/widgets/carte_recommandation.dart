import 'package:flutter/material.dart';

/// Widget qui affiche une liste de recommandations agricoles.
class CarteRecommandation extends StatelessWidget {
  final List<String> recommandations;

  const CarteRecommandation({super.key, required this.recommandations});

  @override
  Widget build(BuildContext context) {
    // Si aucune recommandation, on affiche un message.
    if (recommandations.isEmpty) {
      return const Card(
        margin: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Aucune recommandation particulière.'),
        ),
      );
    }

    // Sinon, on construit la liste de widgets avec une boucle.
    final List<Widget> widgetsConseils = [];
    for (int i = 0; i < recommandations.length; i++) {
      widgetsConseils.add(
        ListTile(
          leading: const Icon(Icons.tips_and_updates, color: Colors.green),
          title: Text(recommandations[i]),
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
              'Conseils pour vos cultures',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...widgetsConseils,
        ],
      ),
    );
  }
}
