import 'package:flutter/material.dart';
import 'package:gestion_loyer/services/api_service.dart';

class ImpaiementsPage extends StatefulWidget {
  const ImpaiementsPage({super.key, this.locataireId, this.locataireNom});

  final int? locataireId;
  final String? locataireNom;
  //final String? title;

  static List<Map<String, dynamic>> filterPaymentsByLocataireId(
    List<dynamic> paiements,
    int locataireId,
  ) {
    final filtered = paiements.where((paiement) {
      final locataire = paiement['contrat']?['locataire'];
      final id = locataire is Map ? locataire['id'] : null;
      return id == locataireId;
    }).toList();

    filtered.sort((a, b) {
      final aDate =
          DateTime.tryParse(a['mois_concerne']?.toString() ?? '') ??
          DateTime(1970);
      final bDate =
          DateTime.tryParse(b['mois_concerne']?.toString() ?? '') ??
          DateTime(1970);
      return bDate.compareTo(aDate);
    });

    return filtered.cast<Map<String, dynamic>>();
  }

  @override
  State<ImpaiementsPage> createState() => _ImpaiementsPagePageState();
}

class _ImpaiementsPagePageState extends State<ImpaiementsPage> {
  bool _isLoading = false;
  List<dynamic> _paiements = [];

  @override
  void initState() {
    super.initState();
    _loadPaiements();
  }

  @override
  void didUpdateWidget(covariant ImpaiementsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.locataireId != widget.locataireId) {
      _loadPaiements();
    }
  }

  Future<void> _loadPaiements() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.getPaiements();
      final paiements = data['liste_paiements'] as List<dynamic>? ?? [];

      final filtered = widget.locataireId == null
          ? paiements
          : ImpaiementsPage.filterPaymentsByLocataireId(
              paiements,
              widget.locataireId!,
            );

      if (!mounted) return;
      setState(() {
        _paiements = filtered;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _paiements = [];
      });
      debugPrint('Erreur lors du chargement des paiements: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatMonth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mois inconnu';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return value;
    }

    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];

    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return 'Date inconnue';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        // backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Historique des paiements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
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
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du locataire
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBEAFE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF2563EB),
                          size: 22,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          widget.locataireId != null
                              ? 'Paiements de ${widget.locataireNom ?? 'locataire #${widget.locataireId}'}'
                              : 'Historique des paiements',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Liste des paiements
                Expanded(
                  child: _paiements.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),

                              const SizedBox(height: 16),

                              Text(
                                widget.locataireId != null
                                    ? 'Aucun paiement trouvé pour ce locataire.'
                                    : 'Aucun paiement enregistré pour le moment.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                          itemCount: _paiements.length,
                          itemBuilder: (context, index) {
                            final paiement = _paiements[index];

                            final mois =
                                paiement['mois_concerne'] ?? 'Mois inconnu';

                            final montant = paiement['montant'] ?? 0;

                            final datePaiement = paiement['date_paiement'];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),

                                leading: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDBEAFE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),

                                title: Text(
                                  _formatMonth(mois.toString()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                subtitle: Text(
                                  'Payé le ${_formatDate(datePaiement?.toString())}',
                                ),

                                trailing: Text(
                                  '${montant.toString()} \$',
                                  style: const TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
