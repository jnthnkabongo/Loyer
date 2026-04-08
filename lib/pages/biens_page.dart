import 'package:flutter/material.dart';

class Bien {
  final String id;
  final String nom;
  final String adresse;
  final String type;
  final double loyer;
  final String statut;
  final String description;

  Bien({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.type,
    required this.loyer,
    required this.statut,
    required this.description,
  });
}

class BiensPage extends StatelessWidget {
  BiensPage({super.key});

  final List<Bien> biens = [
    Bien(
      id: '1',
      nom: 'Appartement Modern',
      adresse: '123 Rue de la Paix, Paris',
      type: 'Appartement',
      loyer: 1200.0,
      statut: 'Disponible',
      description: 'Bel appartement lumineux en centre-ville',
    ),
    Bien(
      id: '2',
      nom: 'Studio Cosy',
      adresse: '45 Avenue des Champs-Élysées, Paris',
      type: 'Studio',
      loyer: 750.0,
      statut: 'Occupé',
      description: 'Studio parfait pour étudiant ou jeune professionnel',
    ),
    Bien(
      id: '3',
      nom: 'Maison Familiale',
      adresse: '78 Boulevard Haussmann, Paris',
      type: 'Maison',
      loyer: 2500.0,
      statut: 'Disponible',
      description: 'Spacieuse maison avec jardin',
    ),
    Bien(
      id: '4',
      nom: 'Duplex Luxe',
      adresse: '200 Rue du Faubourg Saint-Honoré, Paris',
      type: 'Duplex',
      loyer: 1800.0,
      statut: 'En maintenance',
      description: 'Duplex moderne avec terrasse',
    ),
    Bien(
      id: '5',
      nom: 'Loft Créatif',
      adresse: '15 Rue de Rivoli, Paris',
      type: 'Loft',
      loyer: 1400.0,
      statut: 'Disponible',
      description: 'Loft atypique avec haute plafond',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action pour ajouter un nouveau bien
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
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
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
                    Icons.home_work_rounded,
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
                        'Biens Immobiliers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${biens.length} biens en portefeuille',
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
                        '${biens.where((b) => b.statut == 'Disponible').length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Disponibles',
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
                            'Rechercher un bien...',
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

          // Liste des biens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: biens.length,
              itemBuilder: (context, index) {
                final bien = biens[index];
                return _buildBienCard(bien);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBienCard(Bien bien) {
    Color statutColor;
    Color statutBgColor;

    switch (bien.statut) {
      case 'Disponible':
        statutColor = const Color(0xFF10B981);
        statutBgColor = const Color(0xFF10B981);
        break;
      case 'Occupé':
        statutColor = const Color(0xFF2563EB);
        statutBgColor = const Color(0xFF2563EB);
        break;
      case 'En maintenance':
        statutColor = const Color(0xFFF59E0B);
        statutBgColor = const Color(0xFFF59E0B);
        break;
      default:
        statutColor = const Color(0xFF6B7280);
        statutBgColor = const Color(0xFF6B7280);
    }

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
                  gradient: LinearGradient(
                    colors: [
                      statutBgColor,
                      statutBgColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getBienIcon(bien.type),
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
                      bien.nom,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bien.adresse,
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
                  color: statutColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statutColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  bien.statut,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statutColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  bien.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${bien.loyer.toStringAsFixed(0)} \$',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: statutColor,
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

  IconData _getBienIcon(String type) {
    switch (type) {
      case 'Appartement':
        return Icons.apartment_rounded;
      case 'Studio':
        return Icons.single_bed_rounded;
      case 'Maison':
        return Icons.home_rounded;
      case 'Duplex':
        return Icons.domain_rounded;
      case 'Loft':
        return Icons.roofing_rounded;
      default:
        return Icons.home_work_rounded;
    }
  }
}
