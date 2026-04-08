import 'package:flutter/material.dart';

class Paiement {
  final String id;
  final String nomClient;
  final String appartement;
  final double montant;
  final DateTime datePaiement;
  final String methode;
  final String statut;
  final String periode;

  Paiement({
    required this.id,
    required this.nomClient,
    required this.appartement,
    required this.montant,
    required this.datePaiement,
    required this.methode,
    required this.statut,
    required this.periode,
  });
}

class PaiementsPage extends StatelessWidget {
  PaiementsPage({super.key});

  final List<Paiement> paiements = [
    Paiement(
      id: '1',
      nomClient: 'Marie Dubois',
      appartement: 'Appartement A-101',
      montant: 850.0,
      datePaiement: DateTime(2024, 4, 5),
      methode: 'Virement',
      statut: 'Payé',
      periode: 'Avril 2024',
    ),
    Paiement(
      id: '2',
      nomClient: 'Jean Martin',
      appartement: 'Studio B-205',
      montant: 650.0,
      datePaiement: DateTime(2024, 4, 3),
      methode: 'Carte',
      statut: 'Payé',
      periode: 'Avril 2024',
    ),
    Paiement(
      id: '3',
      nomClient: 'Sophie Bernard',
      appartement: 'Appartement C-302',
      montant: 1200.0,
      datePaiement: DateTime(2024, 4, 1),
      methode: 'Espèces',
      statut: 'Payé',
      periode: 'Avril 2024',
    ),
    Paiement(
      id: '4',
      nomClient: 'Pierre Leroy',
      appartement: 'Duplex D-401',
      montant: 1500.0,
      datePaiement: DateTime(2024, 4, 7),
      methode: 'Virement',
      statut: 'Payé',
      periode: 'Avril 2024',
    ),
    Paiement(
      id: '5',
      nomClient: 'Claire Petit',
      appartement: 'Studio E-105',
      montant: 750.0,
      datePaiement: DateTime(2024, 4, 6),
      methode: 'Carte',
      statut: 'Payé',
      periode: 'Avril 2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter un nouveau paiement
        },
        backgroundColor: const Color(0xFF3B82F6),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.payment_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          "Dashboard Van Mut",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color(0xFFFFFFFF),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    backgroundImage: const AssetImage('assets/image/fond.jpeg'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header avec statistiques
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Paiements Reçus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${paiements.length} loyers payés ce mois',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${paiements.fold(0.0, (sum, p) => sum + p.montant).toStringAsFixed(0)} \$',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barre de recherche et filtres
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Rechercher un client...',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.filter_list,
                    color: const Color(0xFF3B82F6),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Liste des paiements
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: paiements.length,
              itemBuilder: (context, index) {
                final paiement = paiements[index];
                return _buildPaiementCard(paiement);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaiementCard(Paiement paiement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paiement.nomClient,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      paiement.appartement,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1E40AF).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  paiement.statut,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E40AF),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${paiement.datePaiement.day.toString().padLeft(2, '0')}/${paiement.datePaiement.month.toString().padLeft(2, '0')}/${paiement.datePaiement.year}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      paiement.methode,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${paiement.montant.toStringAsFixed(0)} \$',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E40AF),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
