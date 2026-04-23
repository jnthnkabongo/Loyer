import 'package:flutter/material.dart';
import 'package:gestion_loyer/services/api_service.dart';

class BiensPage extends StatefulWidget {
  const BiensPage({super.key});

  @override
  State<BiensPage> createState() => _BiensPageState();
}

class _BiensPageState extends State<BiensPage> {
  bool _isLoading = false;
  bool _hasError = false;

  Map<String, dynamic>? _loadLogements;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _selectedLogement;

  List<dynamic>? _filteredLogements;
  List<dynamic>? _listeLocataires;

  final TextEditingController _searchController = TextEditingController();

  String _selectedStatut = 'tous'; // Filtre de statut par défaut

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterLogements);
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
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      await _loadUserData();
      await _loadLogementsData();
      await _loadLocataires();
    } catch (e) {
      debugPrint("Erreur globale : $e");
    }

    setState(() {
      _hasError = true;
    });

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  // ===============================
  // USER
  // ===============================
  Future<void> _loadUserData() async {
    final user = await ApiService.recupererData("user");

    if (!mounted) return;

    setState(() {
      _userData = user;
    });
  }

  // ===============================
  // LOGEMENTS
  // ===============================
  Future<void> _loadLogementsData() async {
    final loadLogements = await ApiService.getLogements();

    if (!mounted) return;

    setState(() {
      _loadLogements = loadLogements;
      _filteredLogements = _loadLogements?['liste_biens'] ?? [];
    });
  }

  // ===============================
  // LOCATAIRES
  // ===============================
  Future<void> _loadLocataires() async {
    final listelocataires = await ApiService.getLocatairesCond();

    if (!mounted) return;

    setState(() {
      _listeLocataires = listelocataires['locataires'] as List<dynamic>?;
    });
  }

  //Creation d'un logement
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _villeController = TextEditingController();
  final TextEditingController _loyerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //Creation d'un contrat
  final TextEditingController _nomContratController = TextEditingController();
  final TextEditingController _locataireIdController = TextEditingController();
  final TextEditingController _dateDebutController = TextEditingController();
  final TextEditingController _dateFinController = TextEditingController();
  final TextEditingController _loyenMensuelController = TextEditingController();
  final TextEditingController _garantieController = TextEditingController();
  int? _selectedLocataireId;

  void _filterLogements() {
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    List<dynamic> baseList = _loadLogements?['liste_biens'] ?? [];

    // Filtrer par texte de recherche
    if (query.isNotEmpty) {
      baseList = baseList.where((logement) {
        final nom = (logement['nom'] ?? '').toString().toLowerCase();
        final type = (logement['type'] ?? '').toString().toLowerCase();
        final adresse = (logement['adresse'] ?? '').toString().toLowerCase();
        final ville = (logement['ville'] ?? '').toString().toLowerCase();
        return nom.contains(query) ||
            type.contains(query) ||
            adresse.contains(query) ||
            ville.contains(query);
      }).toList();
    }

    // Filtrer par statut
    if (_selectedStatut != 'tous') {
      baseList = baseList.where((logement) {
        final statut = (logement['statut'] ?? '').toString().toLowerCase();
        return statut == _selectedStatut;
      }).toList();
    }

    setState(() {
      _filteredLogements = baseList;
    });
  }

  void _showAddLogementDialog() {
    bool modalLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
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
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: DropdownButtonFormField<String>(
                            initialValue: _typeController.text.isEmpty
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
                        const SizedBox(height: 5),
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
                        SizedBox(height: 5),
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
                        SizedBox(height: 5),
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
                        SizedBox(height: 5),
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

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              horizontal: 60,
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
                      const SizedBox(width: 16),
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
                          onPressed: modalLoading
                              ? null
                              : () async {
                                  modalSetState(() {
                                    modalLoading = true;
                                  });

                                  try {
                                    await _addLogement();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                  modalSetState(() {
                                    modalLoading = false;
                                  });
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: modalLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
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
                  ),
                  SizedBox(height: 5),
                ],
              ),
            );
          },
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
        'loyer': _loyerController.text.isNotEmpty
            ? double.tryParse(_loyerController.text) ?? 0.0
            : 0.0,
        'statut': 'disponible', // Champ requis par l'API
        'description': _descriptionController.text,
      };
      print("Données envoyées: $requestData");

      final response = await ApiService.addLogement(requestData);
      print("Réponse API: $response");

      if (response['status'] == true) {
        Navigator.of(context).pop();
        _clearForm();
        _loadLogementsData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logement ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Erreur lors de l\'ajout du logement');
      }
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

  void _showAddContratDialog(Map<String, dynamic> logement) {
    // Stocker le logement sélectionné pour l'utiliser dans la création du contrat
    _selectedLogement = logement;
    bool modalLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetStates) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Création contrat de bail ${logement['nom']}',
                    style: const TextStyle(
                      fontSize: 16,
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
                            controller: _nomContratController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nom contrat',
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
                                Icons.file_copy,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: DropdownButtonFormField<int>(
                            initialValue: _selectedLocataireId,
                            decoration: InputDecoration(
                              hintText: 'Sélectionner un locataire',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey.shade900,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedLocataireId = value;
                              });
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                            items:
                                _listeLocataires?.map((locataire) {
                                  return DropdownMenuItem<int>(
                                    value: locataire['id'],
                                    child: Text(
                                      locataire['nom'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _dateDebutController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                // "${pickedDate.day.toString().padLeft(2, '0')}/"
                                // "${pickedDate.month.toString().padLeft(2, '0')}/"
                                // "${pickedDate.year}";

                                _dateDebutController.text = formattedDate;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Le date du début du contrat',
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),

                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _dateFinController,
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                // "${pickedDate.day.toString().padLeft(2, '0')}/"
                                // "${pickedDate.month.toString().padLeft(2, '0')}/"
                                // "${pickedDate.year}";

                                _dateFinController.text = formattedDate;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Date de fin du contrat',
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _loyenMensuelController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Loyer mensuel',
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
                                Icons.money,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _garantieController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Garantie',
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
                                Icons.payment,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _clearContratForm();
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
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
                          onPressed: modalLoading
                              ? null
                              : () async {
                                  modalSetStates(() {
                                    modalLoading = true;
                                  });

                                  try {
                                    await _addContratLocataire();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                  modalSetStates(() {
                                    modalLoading = false;
                                  });
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 70,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: modalLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
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
                  ),
                  SizedBox(height: 5),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _clearContratForm() {
    _nomContratController.clear();
    _locataireIdController.clear();
    _dateDebutController.clear();
    _dateFinController.clear();
    _loyenMensuelController.clear();
    _garantieController.clear();
  }

  Future<void> _addContratLocataire() async {
    if (_nomContratController.text.isEmpty ||
        _selectedLocataireId == null ||
        _dateDebutController.text.isEmpty ||
        _dateFinController.text.isEmpty ||
        _loyenMensuelController.text.isEmpty ||
        _garantieController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      debugPrint(
        "Les champs vides : ${_nomContratController.text}, $_selectedLocataireId, ${_dateDebutController.text}, ${_dateFinController.text}, ${_loyenMensuelController.text}, ${_garantieController.text}",
      );
      return;
    }

    try {
      final requestData = {
        'nom_contrat': _nomContratController.text,
        'locataire_id': _selectedLocataireId,
        'bien_id': _selectedLogement?['id'],
        'date_debut': _dateDebutController.text,
        'date_fin': _dateFinController.text,
        'loyer_mensuel': _loyenMensuelController.text,
        'garantie': _garantieController.text,
      };

      final response = await ApiService.addContratLocataire(requestData);
      debugPrint("Response: $response");
      debugPrint("Données du contrat : $requestData");
      if (mounted) {
        Navigator.of(context).pop();
        _clearContratForm();
        _loadLogementsData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contrat ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(child: CircularProgressIndicator()),
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
                      horizontal: 12,
                      //vertical: 12,
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
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Rechercher un logement...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Color(0xFF374151),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filtre par statut
                PopupMenuButton<String>(
                  icon: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFF3B82F6),
                      size: 20,
                    ),
                  ),
                  onSelected: (String value) {
                    setState(() {
                      _selectedStatut = value;
                      _applyFilters();
                    });
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'tous',
                      child: Text('Tous les statuts'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'disponible',
                      child: Text('Disponible'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'occupe',
                      child: Text('Occupé'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'maintenance',
                      child: Text('En maintenance'),
                    ),
                  ],
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
      padding: const EdgeInsets.all(15),
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
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
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
                  const SizedBox(width: 6),
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
                      horizontal: 10,
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
                  Icon(Icons.money, size: 16, color: Colors.grey.shade600),
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
                  Icon(Icons.home_work, size: 16, color: Colors.grey.shade600),
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
          Positioned(
            top: 50,
            right: 10,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey.shade600,
                size: 20,
              ),
              onSelected: (String value) {
                _handleMenuAction(value, logement);
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'contrat',
                  child: Row(
                    children: [
                      Icon(
                        Icons.assignment_rounded,
                        size: 16,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text('Contrat', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 8),
                      Text('Modifier', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Text('Supprimer', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
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

  void _handleMenuAction(String action, Map<String, dynamic> logement) {
    switch (action) {
      case 'contrat':
        _showAddContratDialog(logement);
      case 'edit':
        // TODO: Implémenter la modification du logement
        print('Modifier le logement: ${logement['nom']}');
        break;
      case 'delete':
        _showDeleteConfirmationDialog(logement);
        break;
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> logement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer le logement "${logement['nom']}" ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implémenter la suppression du logement
                print('Supprimer le logement: ${logement['nom']}');
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

// import 'package:flutter/material.dart';
// import 'package:gestion_loyer/services/api_service.dart';

// class BiensPage extends StatefulWidget {
//   const BiensPage({super.key});

//   @override
//   State<BiensPage> createState() => _BiensPageState();
// }

// class _BiensPageState extends State<BiensPage> {
//   bool _isLoading = true;
//   bool _hasError = false;

//   Map<String, dynamic>? _userData;
//   Map<String, dynamic>? _loadLogements;
//   List<dynamic> _filteredLogements = [];
//   List<dynamic> _listeLocataires = [];

//   final TextEditingController _searchController = TextEditingController();

//   String _selectedStatut = "tous";

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_applyFilters);
//     _initPage();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   // ===============================
//   // CHARGEMENT GLOBAL
//   // ===============================
//   Future<void> _initPage() async {
//     setState(() {
//       _isLoading = true;
//       _hasError = false;
//     });

//     try {
//       await Future.wait([
//         _loadUserData(),
//         _loadLogementsData(),
//         _loadLocataires(),
//       ]);
//     } catch (e) {
//       debugPrint("Erreur globale : $e");

//       setState(() {
//         _hasError = true;
//       });
//     }

//     if (!mounted) return;

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   // ===============================
//   // USER
//   // ===============================
//   Future<void> _loadUserData() async {
//     final user = await ApiService.recupererData("user");

//     if (!mounted) return;

//     setState(() {
//       _userData = user;
//     });
//   }

//   // ===============================
//   // LOGEMENTS
//   // ===============================
//   Future<void> _loadLogementsData() async {
//     final data = await ApiService.getLogements();

//     if (!mounted) return;

//     setState(() {
//       _loadLogements = data;
//       _filteredLogements = List<dynamic>.from(data['liste_biens'] ?? []);
//     });
//   }

//   // ===============================
//   // LOCATAIRES
//   // ===============================
//   Future<void> _loadLocataires() async {
//     final data = await ApiService.getLocatairesCond();

//     if (!mounted) return;

//     setState(() {
//       _listeLocataires = List<dynamic>.from(data['locataires'] ?? []);
//     });
//   }

//   // ===============================
//   // FILTRE
//   // ===============================
//   void _applyFilters() {
//     if (_loadLogements == null) return;

//     List<dynamic> baseList = List<dynamic>.from(
//       _loadLogements!['liste_biens'] ?? [],
//     );

//     final query = _searchController.text.toLowerCase();

//     if (query.isNotEmpty) {
//       baseList = baseList.where((logement) {
//         final nom = (logement['nom'] ?? '').toString().toLowerCase();

//         final type = (logement['type'] ?? '').toString().toLowerCase();

//         final ville = (logement['ville'] ?? '').toString().toLowerCase();

//         final adresse = (logement['adresse'] ?? '').toString().toLowerCase();

//         return nom.contains(query) ||
//             type.contains(query) ||
//             ville.contains(query) ||
//             adresse.contains(query);
//       }).toList();
//     }

//     if (_selectedStatut != "tous") {
//       baseList = baseList.where((logement) {
//         return (logement['statut'] ?? '').toString().toLowerCase() ==
//             _selectedStatut;
//       }).toList();
//     }

//     setState(() {
//       _filteredLogements = baseList;
//     });
//   }

//   // ===============================
//   // DIALOGS
//   // ===============================
//   void _showAddLogementDialog() {
//     final nomController = TextEditingController();
//     final typeController = TextEditingController();
//     final adresseController = TextEditingController();
//     final villeController = TextEditingController();
//     final loyerController = TextEditingController();
//     final descriptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Ajouter un logement'),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.8,
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: nomController,
//                     decoration: const InputDecoration(
//                       labelText: 'Nom du logement',
//                       prefixIcon: Icon(Icons.home),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(
//                       labelText: 'Type',
//                       prefixIcon: Icon(Icons.home_work),
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: 'Maison', child: Text('Maison')),
//                       DropdownMenuItem(
//                         value: 'Appartement',
//                         child: Text('Appartement'),
//                       ),
//                       DropdownMenuItem(value: 'Bureau', child: Text('Bureau')),
//                       DropdownMenuItem(
//                         value: 'Boutique',
//                         child: Text('Boutique'),
//                       ),
//                     ],
//                     onChanged: (value) => typeController.text = value ?? '',
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: adresseController,
//                     decoration: const InputDecoration(
//                       labelText: 'Adresse',
//                       prefixIcon: Icon(Icons.location_on),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: villeController,
//                     decoration: const InputDecoration(
//                       labelText: 'Ville',
//                       prefixIcon: Icon(Icons.location_city),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: loyerController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: 'Loyer mensuel',
//                       prefixIcon: Icon(Icons.attach_money),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: descriptionController,
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       prefixIcon: Icon(Icons.description),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Annuler'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (nomController.text.isEmpty ||
//                     typeController.text.isEmpty ||
//                     adresseController.text.isEmpty ||
//                     villeController.text.isEmpty ||
//                     loyerController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Tous les champs sont obligatoires'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                   return;
//                 }

//                 try {
//                   final requestData = {
//                     'nom': nomController.text,
//                     'type': typeController.text.toLowerCase(),
//                     'adresse': adresseController.text,
//                     'ville': villeController.text,
//                     'loyer': double.parse(loyerController.text),
//                     'statut': 'disponible',
//                     'description': descriptionController.text,
//                   };

//                   final response = await ApiService.addLogement(requestData);

//                   if (response['status'] == true) {
//                     Navigator.of(context).pop();
//                     _loadLogementsData();
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Logement ajouté avec succès'),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   } else {
//                     throw Exception('Erreur lors de l\'ajout du logement');
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Erreur: ${e.toString()}'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: const Text('Ajouter'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ===============================
//   // CARDS
//   // ===============================
//   Widget _buildBienCard(Map<String, dynamic> logement) {
//     // Déterminer la couleur de fond selon le statut
//     Color statutBgColor;
//     String statut = logement['statut'] ?? 'Disponible';

//     switch (statut.toLowerCase()) {
//       case 'disponible':
//         statutBgColor = const Color(0xFF10B981);
//         break;
//       case 'occupé':
//       case 'occupe':
//         statutBgColor = const Color(0xFF3B82F6);
//         break;
//       case 'maintenance':
//         statutBgColor = const Color(0xFFF59E0B);
//         break;
//       case 'indisponible':
//         statutBgColor = const Color(0xFFEF4444);
//         break;
//       default:
//         statutBgColor = const Color(0xFF6B7280);
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.08),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//         border: Border.all(
//           color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
//           width: 1,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           statutBgColor,
//                           statutBgColor.withValues(alpha: 0.8),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Icon(
//                       _getBienIcon(logement['type'] ?? 'Appartement'),
//                       color: Colors.white,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           logement['nom'] ?? 'Sans nom',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1F2937),
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           logement['adresse'] ?? '',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: statutBgColor.withValues(alpha: 0.1),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: statutBgColor.withValues(alpha: 0.3),
//                         width: 1,
//                       ),
//                     ),
//                     child: Text(
//                       statut,
//                       style: TextStyle(
//                         color: statutBgColor,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Icon(Icons.home, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(
//                     '${logement['loyer'] ?? '0'} \$/mois',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Icon(Icons.info, size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(
//                     logement['type'] ?? 'Non assigné',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Positioned(
//             top: 50,
//             right: 10,
//             child: PopupMenuButton<String>(
//               icon: Icon(
//                 Icons.more_vert,
//                 color: Colors.grey.shade600,
//                 size: 20,
//               ),
//               onSelected: (String value) {
//                 _handleMenuAction(value, logement);
//               },
//               itemBuilder: (BuildContext context) => [
//                 PopupMenuItem<String>(
//                   value: 'edit',
//                   child: Row(
//                     children: [
//                       Icon(Icons.edit, size: 16, color: Colors.grey.shade700),
//                       const SizedBox(width: 8),
//                       Text('Modifier', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 ),
//                 PopupMenuItem<String>(
//                   value: 'delete',
//                   child: Row(
//                     children: [
//                       Icon(Icons.delete, size: 16, color: Colors.red.shade700),
//                       const SizedBox(width: 8),
//                       Text('Supprimer', style: TextStyle(fontSize: 14)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getBienIcon(String? type) {
//     switch (type?.toLowerCase()) {
//       case 'appartement':
//         return Icons.apartment_rounded;
//       case 'studio':
//         return Icons.single_bed_rounded;
//       case 'maison':
//         return Icons.home_rounded;
//       case 'duplex':
//         return Icons.domain_rounded;
//       case 'loft':
//         return Icons.roofing_rounded;
//       default:
//         return Icons.home_work_rounded;
//     }
//   }

//   void _handleMenuAction(String action, Map<String, dynamic> logement) {
//     switch (action) {
//       case 'edit':
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Modification bientôt disponible')),
//         );
//         break;
//       case 'delete':
//         _showDeleteConfirmationDialog(logement);
//         break;
//     }
//   }

//   void _showDeleteConfirmationDialog(Map<String, dynamic> logement) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirmer la suppression'),
//           content: Text(
//             'Êtes-vous sûr de vouloir supprimer le logement "${logement['nom']}" ?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Annuler'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Suppression bientôt disponible'),
//                     backgroundColor: Colors.orange,
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Supprimer',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ===============================
//   // UI
//   // ===============================
//   @override
//   Widget build(BuildContext context) {
//     // LOADING
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     // ERREUR
//     if (_hasError) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, size: 70, color: Colors.red),
//               const SizedBox(height: 15),
//               const Text(
//                 "Erreur lors du chargement",
//                 style: TextStyle(fontSize: 18),
//               ),
//               const SizedBox(height: 15),
//               ElevatedButton(
//                 onPressed: _initPage,
//                 child: const Text("Réessayer"),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // PAGE
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Biens"),
//         backgroundColor: const Color(0xFF3B82F6),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddLogementDialog,
//         backgroundColor: const Color(0xFF3B82F6),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),

//       body: Column(
//         children: [
//           const SizedBox(height: 12),

//           // SEARCH
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: "Rechercher un logement",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // FILTRE
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15),
//             child: DropdownButtonFormField<String>(
//               value: _selectedStatut,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               items: const [
//                 DropdownMenuItem(value: "tous", child: Text("Tous")),
//                 DropdownMenuItem(
//                   value: "disponible",
//                   child: Text("Disponible"),
//                 ),
//                 DropdownMenuItem(value: "occupe", child: Text("Occupé")),
//               ],
//               onChanged: (value) {
//                 _selectedStatut = value!;
//                 _applyFilters();
//               },
//             ),
//           ),

//           const SizedBox(height: 12),

//           // LISTE
//           Expanded(
//             child: _filteredLogements.isEmpty
//                 ? const Center(child: Text("Aucun logement trouvé"))
//                 : RefreshIndicator(
//                     onRefresh: _initPage,
//                     child: ListView.builder(
//                       itemCount: _filteredLogements.length,
//                       itemBuilder: (context, index) {
//                         final logement = _filteredLogements[index];
//                         return _buildBienCard(logement);
//                       },
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
