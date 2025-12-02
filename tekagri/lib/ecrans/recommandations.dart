import 'package:flutter/material.dart';
import '../services/service_meteo.dart';
import '../modeles/meteo_modele.dart';
import '../widgets/carte_recommandation.dart';

/// Écran qui affiche des recommandations agricoles en fonction de la météo.
///
/// SOURCES D’INSPIRATION :
///
/// - Documentation officielle Flutter pour setState(), gestion d’état simple
///   https://api.flutter.dev/flutter/widgets/State/setState.html
///
/// Appeler des services asynchrones / Future & async/await
///   https://docs.flutter.dev/cookbook/networking/fetch-data
///
/// Gestion du chargement avec Future et CircularProgressIndicator
///   https://docs.flutter.dev/cookbook/networking/background-parsing

// Documentation officielle Flutter pour l'utilisation de StatefulWidget
///   https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
class EcranRecommandations extends StatefulWidget {
  const EcranRecommandations({super.key});

  @override
  State<EcranRecommandations> createState() => _EcranRecommandationsState();
}

class _EcranRecommandationsState extends State<EcranRecommandations> {
  final ServiceMeteo _serviceMeteo = ServiceMeteo();

  List<String> _recommandations = [];
  bool _chargement = false;
  String? _messageErreur;

  /// Génère des conseils simples en fonction de la météo.
  List<String> _genererRecommandations(ModeleMeteo meteo) {
    final List<String> conseils = [];

    // On utilise plusieurs if pour ajouter des conseils.
    if (meteo.temperature >= 25 && meteo.precipitation == 0) {
      conseils.add(
        'Arroser davantage les cultures en fin de journée pour limiter l’évaporation.',
      );
    }

    if (meteo.precipitation >= 5) {
      conseils.add(
        'Limiter l’arrosage aujourd’hui : la pluie fournit une bonne partie des besoins.',
      );
    }

    if (meteo.humidite >= 80) {
      conseils.add(
        'Humidité élevée : surveiller l’apparition de maladies fongiques (mildiou, oïdium).',
      );
    }

    if (meteo.vitesseVent >= 8) {
      conseils.add(
        'Éviter les traitements phytosanitaires par pulvérisation en cas de vent fort.',
      );
    }

    // Utilisation d’une boucle pour ajouter un conseil générique à la fin.
    final List<String> conseilsGeneraux = [
      'Observer régulièrement l’état des feuilles.',
      'Adapter les apports d’eau à chaque type de culture.',
      'Prévoir un paillage pour conserver l’humidité du sol.',
    ];

    for (String conseil in conseilsGeneraux) {
      conseils.add(conseil);
    }

    return conseils;
  }

  /// Charge les recommandations en fonction de la météo actuelle.
  Future<void> _chargerRecommandations() async {
    setState(() {
      _chargement = true;
      _messageErreur = null;
    });

    try {
      final meteo = await _serviceMeteo.obtenirMeteoActuelle();
      setState(() {
        _recommandations = _genererRecommandations(meteo);
      });
    } catch (e) {
      setState(() {
        _messageErreur = e.toString();
      });
    } finally {
      setState(() {
        _chargement = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _chargerRecommandations();
  }

  /// Construit l'interface utilisateur des recommandations agricoles.
  @override
  Widget build(BuildContext context) {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_messageErreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Erreur : $_messageErreur', textAlign: TextAlign.center),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CarteRecommandation(recommandations: _recommandations),
          ElevatedButton(
            onPressed: _chargerRecommandations,
            child: const Text('Actualiser les conseils'),
          ),
        ],
      ),
    );
  }
}
