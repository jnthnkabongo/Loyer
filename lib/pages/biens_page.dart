import 'package:flutter/material.dart';
import 'package:gestion_loyer/services/api_service.dart';
import 'package:http/http.dart';

class BiensPage extends StatefulWidget {
  const BiensPage({super.key});

  @override
  State<BiensPage> createState() => _BiensPageState();
}

class _BiensPageState extends State<BiensPage> {
  Map<String, dynamic>? _loadLogements;
  bool _isLoading = false;
  List<dynamic>? _filteredLogements;
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _userData;

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _loyerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLogementsData();
    _loadData();
    _searchController.addListener(_filterLogements);
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final userData = await ApiService.recupererData('user');
    print("Les informations de l'utilisateur: $userData");

    setState(() {
      _isLoading = false;
      _userData = userData;
    });
  }

  void _filterLogements() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredLogements = _loadLogements?['liste_biens'] ?? [];
      });
      return;
    }

    final filtered = (_loadLogements?['liste_biens'] ?? []).where((paiement) {
      final nomClient = (paiement['nom_client'] ?? '').toString().toLowerCase();
      final appartement = (paiement['appartement'] ?? '')
          .toString()
          .toLowerCase();
      return nomClient.contains(query) || appartement.contains(query);
    }).toList();

    setState(() {
      _filteredLogements = filtered;
    });
  }

  void _showAddLogementDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ajouter un logement',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _nomController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Entrez le nom du logement',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.home,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _typeController.text.isEmpty
                              ? null
                              : _typeController.text,
                          decoration: InputDecoration(
                            hintText: 'Sélectionner le type',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: Icon(
                              Icons.home_work,
                              color: Color(0xFF3B82F6),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          items: const [
                            DropdownMenuItem<String>(
                              value: 'Maison',
                              child: Text('Maison'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Appartement',
                              child: Text('Appartement'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Bureau',
                              child: Text('Bureau'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Boutique',
                              child: Text('Boutique'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _typeController.text = value ?? '';
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _adresseController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Adresse du logement',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.location_on,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _villeController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Ville',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.location_city,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _loyerController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Prix de location (\$)',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.attach_money,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Description',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            prefixIcon: const Icon(
                              Icons.description,
                              color: Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _clearForm();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  _addLogement();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ajouter',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _nomController.clear();
    _typeController.clear();
    _adresseController.clear();
    _villeController.clear();
    _loyerController.clear();
    _descriptionController.clear();
  }

  Future<void> _addLogement() async {
    print("Méthode _addLogement appelée");
    if (_nomController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _adresseController.text.isEmpty ||
        _villeController.text.isEmpty ||
        _loyerController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tous les champs sont obligatoires'),

          backgroundColor: Colors.red,
        ),
      );
      debugPrint(
        "Les champs vides : ${_nomController.text.isEmpty} ${_typeController.text.isEmpty} ${_adresseController.text.isEmpty} ${_villeController.text.isEmpty} ${_loyerController.text.isEmpty} ${_descriptionController.text.isEmpty}",
      );
      return;
    }

    try {
      final requestData = {
        'nom': _nomController.text,
        'type': _typeController.text.toLowerCase(),
        'adresse': _adresseController.text,
        'ville': _villeController.text,
        'loyer': double.parse(_loyerController.text),
        'statut': 'disponible', // Champ requis par l'API
        'description': _descriptionController.text,
      };
      print("Données envoyées: $requestData");

      final response = await ApiService.addLogement(requestData);
      print("Réponse API: $response");

      // Fermer le modal et réinitialiser le formulaire
      Navigator.of(context).pop();
      _clearForm();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logement ajouté avec succès'),
          backgroundColor: Colors.green,
        ),
      );

      // Rafraîchir la liste des logements
      _loadLogementsData();
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    print("Ajout d'un nouveau logement");
  }

  Future<void> _loadLogementsData() async {
    setState(() {
      _isLoading = true;
    });

    final loadLogements = await ApiService.getLogements();
    print("Les informations des logements: ${loadLogements}");

    setState(() {
      _isLoading = false;
      _loadLogements = loadLogements;
      _filteredLogements = _loadLogements?['liste_biens'] ?? [];
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

    if (_loadLogements == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Text(
            "Erreur lors du chargement des données",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLogementDialog();
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
                  child: _userData?['photo'] != null
                      ? ClipOval(
                          child: Image.network(
                            'http://10.0.2.2:8000/storage/${_userData?['photo']}',
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
            child:
                (_loadLogements == null ||
                    _loadLogements!['liste_biens'] == null)
                ? const Center(child: Text("Aucun logements trouvés"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredLogements?.length ?? 0,
                    itemBuilder: (context, index) {
                      final logement = _filteredLogements![index];
                      return _buildBienCard(logement);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBienCard(logement) {
    // Determine background color based on property status
    Color statutBgColor;
    String statut = logement['statut'] ?? 'Disponible';

    switch (statut.toLowerCase()) {
      case 'disponible':
        statutBgColor = const Color(0xFF10B981);
        break;
      case 'occupé':
      case 'occupe':
        statutBgColor = const Color(0xFF3B82F6);
        break;
      case 'maintenance':
        statutBgColor = const Color(0xFFF59E0B);
        break;
      case 'indisponible':
        statutBgColor = const Color(0xFFEF4444);
        break;
      default:
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
                  _getBienIcon(logement['type'] ?? 'Appartement'),
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
                      logement['nom'] ?? 'Sans nom',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      logement['adresse'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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
                  color: statutBgColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statutBgColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  statut,
                  style: TextStyle(
                    color: statutBgColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.home, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${logement['loyer'] ?? '0'} \$/mois',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.info, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                logement['type'] ?? 'Non assigné',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getBienIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'appartement':
        return Icons.apartment_rounded;
      case 'studio':
        return Icons.single_bed_rounded;
      case 'maison':
        return Icons.home_rounded;
      case 'duplex':
        return Icons.domain_rounded;
      case 'loft':
        return Icons.roofing_rounded;
      default:
        return Icons.home_work_rounded;
    }
  }
}
