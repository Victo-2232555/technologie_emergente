import 'package:flutter/material.dart';
import '../services/service_meteo.dart';
import '../modeles/meteo_modele.dart';
import '../widgets/carte_meteo.dart';

/// Écran principal : affiche la météo actuelle sous forme de tableau de bord.
class EcranTableauBord extends StatefulWidget {
  const EcranTableauBord({super.key});

  @override
  State<EcranTableauBord> createState() => _EcranTableauBordState();
}

class _EcranTableauBordState extends State<EcranTableauBord> {
  final ServiceMeteo _serviceMeteo = ServiceMeteo();

  ModeleMeteo? _meteo;
  bool _chargement = false;
  String? _messageErreur;

  /// Charge les données météo en appelant le service.
  Future<void> _chargerMeteo() async {
    setState(() {
      _chargement = true;
      _messageErreur = null;
    });

    try {
      final donnees = await _serviceMeteo.obtenirMeteoActuelle();
      setState(() {
        _meteo = donnees;
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
    _chargerMeteo();
  }

  /// Construit l'interface utilisateur du tableau de bord météo.

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

    if (_meteo == null) {
      return Center(
        child: ElevatedButton(
          onPressed: _chargerMeteo,
          child: const Text('Charger la météo'),
        ),
      );
    }

    return Column(
      children: [
        CarteMeteo(meteo: _meteo!),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _chargerMeteo,
          child: const Text('Actualiser la météo'),
        ),
      ],
    );
  }
}
