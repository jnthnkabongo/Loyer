import 'package:flutter/material.dart';
import 'package:gestion_loyer/services/api_service.dart';

class PaiementsPage extends StatefulWidget {
  const PaiementsPage({super.key});

  @override
  State<PaiementsPage> createState() => _PaiementsPageState();
}

class _PaiementsPageState extends State<PaiementsPage> {
  bool _isLoading = false;
  bool _hasError = false;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _loadPaiements;

  List<dynamic>? _filteredPaiements;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPaiements);
    _initPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //===============================
  // CHARGEMENT GLOBAL
  // ==============================
  Future<void> _initPage() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await _loadPaiementsData();
      await _loadData();
    } catch (e) {
      debugPrint("Erreur globale : $e");
    }

    if (!mounted) return;
    setState(() {
      _hasError = true;
    });

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final userData = await ApiService.recupererData('user');
    //print("Les informations de l'utilisateur: $userData");

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _userData = userData;
    });
  }

  void _filterPaiements() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _filteredPaiements = _loadPaiements?['liste_paiements'] ?? [];
      });
      return;
    }

    final filtered = (_loadPaiements?['liste_paiements'] ?? []).where((
      paiement,
    ) {
      final nomClient = (paiement['nom_client'] ?? '').toString().toLowerCase();
      final appartement = (paiement['appartement'] ?? '')
          .toString()
          .toLowerCase();
      return nomClient.contains(query) || appartement.contains(query);
    }).toList();

    if (!mounted) return;
    setState(() {
      _filteredPaiements = filtered;
    });
  }

  Future<void> _loadPaiementsData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final loadPaiements = await ApiService.getPaiements();
    //print("Les informations des paiements: $loadPaiements");

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _loadPaiements = loadPaiements;
      _filteredPaiements = _loadPaiements?['liste_paiements'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadPaiements == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                "Erreur lors du chargement des données",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
                  child: _userData?['photo'] != null
                      ? ClipOval(
                          child: Image.network(
                            'https://mecanismenationaldesuivi.alwaysdata.net/public/storage/${_userData?['photo']}',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
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
          const SizedBox(height: 16),

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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Rechercher un paiement...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                            ),
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
            child:
                (_loadPaiements == null ||
                    _loadPaiements!['liste_paiements'] == null)
                ? const Center(child: Text("Aucun paiement trouvé"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredPaiements?.length ?? 0,
                    itemBuilder: (context, index) {
                      final paiement = _filteredPaiements![index];
                      return _buildPaiementCard(paiement);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaiementCard(Map<String, dynamic> paiement) {
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
                      'Paiement de ${paiement['contrat']?['locataire']?['prenom'] ?? 'Aucun locataire'} ${paiement['contrat']?['locataire']?['nom'] ?? 'Aucun locataire'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      paiement['contrat']?['bien']?['nom'] ??
                          'Aucun appartement',
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
                  paiement['statut'] ?? 'Aucun statut',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E40AF),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date de création",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DateTime.parse(paiement['created_at']).day.toString().padLeft(2, '0')}/${DateTime.parse(paiement['created_at']).month.toString().padLeft(2, '0')}/${DateTime.parse(paiement['created_at']).year}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mode de paiement",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      paiement['mode_paiement'] ?? 'Non spécifié',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mois concerné",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      paiement['mois_concerne'] ?? 'Non spécifié',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Montant",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${double.tryParse(paiement['montant']?.toString() ?? '0')?.toStringAsFixed(0) ?? '0'} \$',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E40AF),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                onSelected: (String value) {
                  _handleMenuAction(value, paiement);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'Modifier',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text('Modifier', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Supprimer',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> paiement) {
    switch (action) {
      case 'Modifier':
        //print('Supprimer le paiement: ${paiement['id']}');
        break;
      case 'Supprimer':
        _showDeleteConfirmationDialog(paiement);
        //print('Modifier le paiement: ${paiement['id']}');
        break;
    }
  }

  //Modal de suppresion

  void _showDeleteConfirmationDialog(Map<String, dynamic> paiement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppresssion du paiement'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ce paiement de ${paiement['contrat']?['locataire']?['prenom'] ?? 'Aucun locataire'} de ${paiement['montant']}\$ ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService.deletePaiement({'id': paiement['id']});

                  _loadPaiementsData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Paiement supprimé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Fermer le dialog après le succès
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  //Fermer le dialog apres l'erreur
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
