import 'package:flutter/material.dart';
import '../modeles/meteo_modele.dart';

/// Widget qui affiche une carte contenant les informations météo principales.
class CarteMeteo extends StatelessWidget {
  final ModeleMeteo meteo;

  const CarteMeteo({super.key, required this.meteo});

  @override
  Widget build(BuildContext context) {
    // On prépare un tableau de lignes de texte à afficher.
    final List<String> lignes = [
      'Ville : ${meteo.nomVille}',
      'Température : ${meteo.temperature.toStringAsFixed(1)} °C',
      'Humidité : ${meteo.humidite} %',
      'Vent : ${meteo.vitesseVent.toStringAsFixed(1)} m/s',
      'Précipitations (1h) : ${meteo.precipitation.toStringAsFixed(1)} mm',
    ];

    // On va utiliser une boucle pour créer un widget Text pour chaque ligne.
    final List<Widget> widgetsTexte = [];
    for (String ligne in lignes) {
      widgetsTexte.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(ligne),
        ),
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meteo.description,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widgetsTexte, // On insère tous les Text créés dans la boucle
          ],
        ),
      ),
    );
  }
}
