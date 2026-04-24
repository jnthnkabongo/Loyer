import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gestion_loyer/services/api_service.dart';

class LocatairesPage extends StatefulWidget {
  const LocatairesPage({super.key});

  @override
  State<LocatairesPage> createState() => _LocatairesPageState();
}

class _LocatairesPageState extends State<LocatairesPage> {
  bool _isLoading = false;
  final bool _hasError = false;

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? _loadLocataires;

  List<dynamic>? _listeBiens;
  List<dynamic>? _listeContrats;
  List<dynamic>? _filteredLocataires;

  final TextEditingController _searchController = TextEditingController();

  // Contrôleurs pour le formulaire d'ajout
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  int? _selectedLogementId;

  //Contrôleurs pour le formulaire de paiement loyer
  final TextEditingController _contratIdController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _moisConcerneController = TextEditingController();
  final TextEditingController _datePaiementController = TextEditingController();
  final TextEditingController _modePaiementController = TextEditingController();

  final TextEditingController _referrenceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_filterLocataires);
    _initPage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initPage() async {
    setState(() {});

    try {
      await _loadLocatairesData();
      await _loadData();
      await _loadListeBiens();
      await _loadListeContrats();
    } catch (e) {
      debugPrint("Erreur globale : $e");
    }
  }

  // @override
  // void dispose() {
  //   _searchController.removeListener(_filterLocataires);
  //   _searchController.dispose();
  //   _nomController.dispose();
  //   _prenomController.dispose();
  //   _emailController.dispose();
  //   _telephoneController.dispose();
  //   _adresseController.dispose();
  //   super.dispose();
  // }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final userData = await ApiService.recupererData('user');
    //print("Les informations de l'utilisateur: $userData");

    setState(() {
      _isLoading = false;
      _userData = userData;
    });
  }

  Future<void> _loadListeBiens() async {
    setState(() {
      _isLoading = true;
    });

    final listeBiens = await ApiService.getLogementsCond();
    //print("Les biens: $listeBiens");

    setState(() {
      _isLoading = false;
      _listeBiens = listeBiens['liste_biens'] as List<dynamic>?;
    });
  }

  void _filterLocataires() {
    final query = _searchController.text.toLowerCase();
    final allLocataires = _loadLocataires?['locataires'] ?? [];

    if (query.isEmpty) {
      setState(() {
        _filteredLocataires = allLocataires;
      });
    } else {
      setState(() {
        _filteredLocataires = allLocataires.where((locataire) {
          final nom = locataire['nom']?.toString().toLowerCase() ?? '';
          final prenom = locataire['prenom']?.toString().toLowerCase() ?? '';
          final email = locataire['email']?.toString().toLowerCase() ?? '';
          final telephone =
              locataire['telephone']?.toString().toLowerCase() ?? '';
          final appartement = locataire['biens']?.isNotEmpty == true
              ? locataire['biens'][0]['nom']?.toString().toLowerCase() ?? ''
              : '';

          return nom.contains(query) ||
              prenom.contains(query) ||
              email.contains(query) ||
              telephone.contains(query) ||
              appartement.contains(query);
        }).toList();
      });
    }
  }

  //Liste des contrats
  Future<void> _loadListeContrats() async {
    setState(() {
      _isLoading = true;
    });

    final listeContrats = await ApiService.getContrats();
    //print("Les contrats: $listeContrats");

    setState(() {
      _isLoading = false;
      _listeContrats = listeContrats['liste_contrats'] as List<dynamic>?;
    });
  }

  //Nettoyer formulaire apres enregistrement
  void _clearForm() {
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    _telephoneController.clear();
    _adresseController.clear();
    _selectedLogementId = null;
  }

  //Fonction d'enregistrement nouveau locataire
  Future<void> _addLocataire() async {
    if (_nomController.text.isEmpty || _prenomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom et le prénom sont obligatoires'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedLogementId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un bien immobilier'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final requestData = {
        'bien_id': _selectedLogementId?.toString() ?? '',
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'email': _emailController.text,
        'telephone': _telephoneController.text,
        'adresse': _adresseController.text,
      };

      // print('Données envoyées: $requestData');
      // print('bien_id value: $_selectedLogementId');
      // print('bien_id string: ${_selectedLogementId?.toString() ?? ''}');

      final response = await ApiService.addLocataire(requestData);

      //print('Réponse API: $response');

      // ✅ Vérifier la réponse API
      if (response['status'] == true) {
        Navigator.of(context).pop();
        _clearForm();
        _loadLocatairesData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Locataire ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception(response['message'] ?? 'Erreur inconnue');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //Modal d'ajout locataire
  void _showAddLocataireDialog() {
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
                    'Ajouter un locataire',
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
                          child: DropdownButtonFormField<int>(
                            initialValue: _selectedLogementId,
                            decoration: InputDecoration(
                              hintText: 'Sélectionner un type de logement',
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
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            items:
                                _listeBiens?.map((bien) {
                                  return DropdownMenuItem<int>(
                                    value: bien['id'],
                                    child: Text(
                                      bien['nom'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _selectedLogementId = value;
                              });
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              hintText: 'Entrez le nom du locataire',
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
                                Icons.person,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _prenomController,
                            decoration: InputDecoration(
                              hintText: 'Entrez le prénom du locataire',
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
                                Icons.person_outline,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Entrez l\'email du locataire',
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
                                Icons.email,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _telephoneController,
                            decoration: InputDecoration(
                              hintText: 'Entrez le téléphone du locataire',
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
                                Icons.phone,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _adresseController,
                            decoration: InputDecoration(
                              hintText: 'Entrez l\'adresse du locataire',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
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

                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
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
                            padding: EdgeInsets.symmetric(
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
                                  modalSetState(() {
                                    modalLoading = true;
                                  });
                                  try {
                                    await _addLocataire();
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
                              horizontal: 70,
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleLocataireAction(String action, Map<String, dynamic> locataire) {
    switch (action) {
      case 'modifier':
        // TODO: Implémenter la modification du locataire
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Modification de ${locataire['prenom']} ${locataire['nom']} bientôt disponible',
            ),
            backgroundColor: const Color(0xFF3B82F6),
          ),
        );
        break;
      case 'supprimer':
        _showDeleteConfirmationDialog(locataire);
        break;
      case 'loyer':
        _showAddPaiementLocataireDialog(locataire);
        break;
    }
  }

  void _showDeleteConfirmationDialog(Map<String, dynamic> locataire) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text(
            'Êtes-vous sûr de vouloir supprimer ${locataire['prenom']} ${locataire['nom']} ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await ApiService.deleteLocataire({'id': locataire['id']});

                  _loadLocatairesData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Locataire supprimé avec succès'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // Fermer le dialog apres le succès
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // Fermer le dialog après l'erreur
                  Navigator.of(context).pop();
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

  //Modal de paiement loyer locataire
  void _showAddPaiementLocataireDialog(Map<String, dynamic> locataire) {
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
                    'Paiement loyer ${locataire['prenom']}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10),
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
                          child: DropdownButtonFormField<String>(
                            initialValue: _contratIdController.text.isEmpty
                                ? null
                                : _contratIdController.text,
                            decoration: InputDecoration(
                              hintText: 'Sélectionner un contrat',
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
                                Icons.folder,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                            ),
                            items:
                                _listeContrats?.map((contrat) {
                                  return DropdownMenuItem<String>(
                                    value: contrat['id'].toString(),
                                    child: Text(
                                      contrat['nom_contrat'],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 15,
                                      ),
                                    ),
                                  );
                                }).toList() ??
                                [],
                            onChanged: (value) {
                              setState(() {
                                _contratIdController.text =
                                    value?.toString() ?? '';
                              });
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontFamily: 'Poppins',
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
                            controller: _montantController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Montant du loyer',
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFF8FAFC),
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(color: const Color(0xFFE2E8F0)),
                        //   ),
                        //   child: TextField(
                        //     controller: _datePaiementController,
                        //     keyboardType: TextInputType.datetime,
                        //     decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       hintText: 'Date de paiement (JJ/MM/AAAA)',
                        //       labelStyle: TextStyle(
                        //         color: Colors.grey.shade600,
                        //         fontSize: 15,
                        //         fontFamily: 'Poppins',
                        //       ),
                        //       hintStyle: TextStyle(
                        //         color: Colors.grey.shade400,
                        //         fontSize: 15,
                        //         fontFamily: 'Poppins',
                        //       ),
                        //       prefixIcon: const Icon(
                        //         Icons.calendar_today,
                        //         color: Color(0xFF3B82F6),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _datePaiementController,
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

                                _datePaiementController.text = formattedDate;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Le date de paiement',
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFF8FAFC),
                        //     borderRadius: BorderRadius.circular(10),
                        //     border: Border.all(color: const Color(0xFFE2E8F0)),
                        //   ),
                        //   child: TextField(
                        //     controller: _moisConcerneController,
                        //     decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       hintText: 'Mois concerné (JJ/MM/AAAA)',
                        //       labelStyle: TextStyle(
                        //         color: Colors.grey.shade600,
                        //         fontSize: 15,
                        //         fontFamily: 'Poppins',
                        //       ),
                        //       hintStyle: TextStyle(
                        //         color: Colors.grey.shade400,
                        //         fontSize: 15,
                        //         fontFamily: 'Poppins',
                        //       ),
                        //       prefixIcon: const Icon(
                        //         Icons.calendar_month,
                        //         color: Color(0xFF3B82F6),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _moisConcerneController,
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

                                _moisConcerneController.text = formattedDate;
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Le paiement concerne le mois...',
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
                          child: DropdownButtonFormField(
                            initialValue: _modePaiementController.text.isEmpty
                                ? null
                                : _modePaiementController.text,
                            decoration: InputDecoration(
                              hintText: 'Sélectionner le moyen de paiement',
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
                                Icons.wallet,
                                color: Color(0xFF3B82F6),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'cash',
                                child: Text('Cash'),
                              ),
                              DropdownMenuItem(
                                value: 'mobile_money',
                                child: Text('Mobile money'),
                              ),
                              DropdownMenuItem(
                                value: 'banque',
                                child: Text('Banque'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _modePaiementController.text = value ?? '';
                              });
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontFamily: 'Poppins',
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
                            controller: _referrenceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Réference',
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
                                Icons.receipt_long,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5),
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
                            _clearPaiementForm();
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
                                    await _addPaiementLocataire();
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
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
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

  void _clearPaiementForm() {
    _contratIdController.clear();
    _montantController.clear();
    _moisConcerneController.clear();
    _datePaiementController.clear();
    _modePaiementController.clear();
    _referrenceController.clear();
  }

  //Fonction d'enregistrement de paiement
  Future<void> _addPaiementLocataire() async {
    if (_contratIdController.text.isEmpty ||
        _montantController.text.isEmpty ||
        _moisConcerneController.text.isEmpty ||
        _datePaiementController.text.isEmpty ||
        _modePaiementController.text.isEmpty ||
        _referrenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
          backgroundColor: Colors.red,
        ),
      );
      // debugPrint(
      //   "Les champs vides : ${_contratIdController.text}, ${_montantController.text}, ${_moisConcerneController.text}, ${_datePaiementController.text}, ${_modePaiementController.text}, ${_referrenceController.text}",
      // );
      return;
    }
    try {
      final requestData = {
        'contrat_id': int.parse(_contratIdController.text),
        'montant': double.parse(_montantController.text),
        'mois_concerne': _moisConcerneController.text,
        'date_paiement': _datePaiementController.text,
        'mode_paiement': _modePaiementController.text,
        'statut': 'paye',
        'referrence': _referrenceController.text,
      };
      final response = await ApiService.addPaiementLocataire(requestData);
      //print("Response: $response");
      if (mounted) {
        Navigator.of(context).pop();
        _clearPaiementForm();
        _loadLocatairesData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paiement ajouté avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadLocatairesData() async {
    setState(() {
      _isLoading = true;
    });

    final loadLocataires = await ApiService.getLocataires();
    //print("Les informations des locatires : $loadLocataires");

    setState(() {
      _isLoading = false;
      _loadLocataires = loadLocataires;
      _filteredLocataires = _loadLocataires?['locataires'] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadLocataires == null) {
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
                              hintText: 'Rechercher un locataire...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade700,
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
            child:
                (_loadLocataires == null ||
                    _loadLocataires!['locataires'] == null)
                ? const Center(child: Text("Aucun locataire trouvé"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredLocataires?.length ?? 0,
                    itemBuilder: (context, index) {
                      final locataire = _filteredLocataires![index];
                      return _buildLocataireCard(locataire);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLocataireDialog();
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
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildLocataireCard(Map<String, dynamic> locataire) {
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
                      '${locataire['prenom'] ?? 'Aucun prenom'} ${locataire['nom'] ?? 'Aucun nom'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (locataire['biens'] != null &&
                              locataire['biens'].isNotEmpty)
                          ? locataire['biens'][0]['nom']
                          : 'Aucun appartement',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w900,
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
                  locataire['statut'] ?? 'Actif',
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
          const SizedBox(height: 2),
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
                        locataire['email'] ?? 'Aucun email',
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
                      locataire['telephone'] ?? 'Aucun téléphone',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Bouton 3 points pour les options
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                onSelected: (String value) {
                  _handleLocataireAction(value, locataire);
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'loyer',
                    child: Row(
                      children: [
                        Icon(Icons.payment, color: Color(0xFF234FEF), size: 18),
                        SizedBox(width: 12),
                        Text('Paiement loyer'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'modifier',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Color(0xFFEFAC2F), size: 18),
                        SizedBox(width: 12),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'supprimer',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Color(0xFFEF4444), size: 18),
                        SizedBox(width: 12),
                        Text('Supprimer'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 2),
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
                      'Entrée: ${locataire['created_at'] != null ? DateTime.parse(locataire['created_at']).toString().split(' ')[0] : 'Date inconnue'}',
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
                      '${locataire['biens'] != null && locataire['biens'].isNotEmpty ? locataire['biens'][0]['loyer'] : '0'} \$/mois',
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
