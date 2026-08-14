import 'package:flutter_test/flutter_test.dart';

import 'package:gestion_loyer/pages/impaiement_page.dart';

void main() {
  test(
    'filterPaymentsByLocataireId returns only the selected tenant payments',
    () {
      final paiements = [
        {
          'montant': 250000,
          'mois_concerne': '2026-01-01',
          'contrat': {
            'locataire': {'id': 7},
          },
        },
        {
          'montant': 250000,
          'mois_concerne': '2026-02-01',
          'contrat': {
            'locataire': {'id': 8},
          },
        },
        {
          'montant': 250000,
          'mois_concerne': '2026-03-01',
          'contrat': {
            'locataire': {'id': 7},
          },
        },
      ];

      final filtered = ImpaiementsPage.filterPaymentsByLocataireId(
        paiements,
        7,
      );

      expect(filtered.length, 2);
      expect(filtered[0]['mois_concerne'], '2026-03-01');
      expect(filtered[1]['mois_concerne'], '2026-01-01');
    },
  );
}
