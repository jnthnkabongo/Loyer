import 'package:flutter/material.dart';

class Locataire {
  final String id;
  final String nom;
  final String email;
  final String telephone;
  final String appartement;
  final double loyer;
  final DateTime dateEntree;
  final String statut;

  Locataire({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.appartement,
    required this.loyer,
    required this.dateEntree,
    required this.statut,
  });
}

class LocatairesPage extends StatelessWidget {
  LocatairesPage({super.key});

  final List<Locataire> locataires = [
    Locataire(
      id: '1',
      nom: 'Marie Dubois',
      email: 'marie.dubois@email.com',
      telephone: '06 12 34 56 78',
      appartement: 'Appartement A-101',
      loyer: 850.0,
      dateEntree: DateTime(2023, 6, 15),
      statut: 'Actif',
    ),
    Locataire(
      id: '2',
      nom: 'Jean Martin',
      email: 'jean.martin@email.com',
      telephone: '06 23 45 67 89',
      appartement: 'Studio B-205',
      loyer: 650.0,
      dateEntree: DateTime(2023, 9, 1),
      statut: 'Actif',
    ),
    Locataire(
      id: '3',
      nom: 'Sophie Bernard',
      email: 'sophie.bernard@email.com',
      telephone: '06 34 56 78 90',
      appartement: 'Appartement C-302',
      loyer: 1200.0,
      dateEntree: DateTime(2023, 3, 20),
      statut: 'Actif',
    ),
    Locataire(
      id: '4',
      nom: 'Pierre Leroy',
      email: 'pierre.leroy@email.com',
      telephone: '06 45 67 89 01',
      appartement: 'Duplex D-401',
      loyer: 1500.0,
      dateEntree: DateTime(2023, 12, 10),
      statut: 'Actif',
    ),
    Locataire(
      id: '5',
      nom: 'Claire Petit',
      email: 'claire.petit@email.com',
      telephone: '06 56 78 90 12',
      appartement: 'Studio E-105',
      loyer: 750.0,
      dateEntree: DateTime(2024, 1, 5),
      statut: 'Actif',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter un nouveau locataire
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
            Icons.person_add_rounded,
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
                    Icons.people_rounded,
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
                        'Locataires Actifs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${locataires.length} locataires enregistrés',
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
                        '${locataires.fold(0.0, (sum, l) => sum + l.loyer).toStringAsFixed(0)} \$',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Total Loyers',
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
                            'Rechercher un locataire...',
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

          // Liste des locataires
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: locataires.length,
              itemBuilder: (context, index) {
                final locataire = locataires[index];
                return _buildLocataireCard(locataire);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocataireCard(Locataire locataire) {
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  //color: Colors.white.withValues(alpha: 0.2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locataire.nom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locataire.appartement,
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
                  locataire.statut,
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
                      Icons.email_rounded,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        locataire.email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      locataire.telephone,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                      'Entrée: ${locataire.dateEntree.day.toString().padLeft(2, '0')}/${locataire.dateEntree.month.toString().padLeft(2, '0')}/${locataire.dateEntree.year}',
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
                      '${locataire.loyer.toStringAsFixed(0)} \$',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E40AF),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/mois',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
