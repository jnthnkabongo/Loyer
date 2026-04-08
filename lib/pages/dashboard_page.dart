import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = false;

  // Données exemples
  final double revenusMensuels = 8500.0;
  final double totalLoyersPerus = 125000.0;
  final int loyersEnRetard = 500;
  final int nombreLocataires = 18;

  @override
  Widget build(BuildContext context) {
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
        //centerTitle: true,
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
                    //child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header moderne
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.house_siding,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tableau de Bord',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Gérez votre immobilier en toute simplicité",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildQuickStat(
                                  'Revenus/Mois',
                                  '$revenusMensuels \$',
                                  Icons.trending_up_rounded,
                                  Colors.green.shade300,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              Expanded(
                                child: _buildQuickStat(
                                  'Appartements',
                                  '$nombreLocataires',
                                  Icons.home_work,
                                  Colors.blue.shade300,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              Expanded(
                                child: _buildQuickStat(
                                  'En Retard',
                                  '$loyersEnRetard',
                                  Icons.warning_rounded,
                                  Colors.orange.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cartes principales modernes
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildModernCard(
                              'Augmentation/Mois',
                              '${revenusMensuels.toStringAsFixed(0)} \$',
                              Icons.trending_up_rounded,
                              [
                                const Color(0xFF10B981),
                                const Color(0xFF059669),
                              ],
                              '',
                              '',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildModernCard(
                              'Total Loyers Perçus',
                              '${totalLoyersPerus.toStringAsFixed(0)} \$',
                              Icons.account_balance_wallet_rounded,
                              [
                                const Color(0xFF2563EB),
                                const Color(0xFF1E40AF),
                              ],
                              'Total cumulé',
                              '+8.2%',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModernCard(
                              'Loyers en Retard',
                              '${loyersEnRetard.toString()} \$',
                              Icons.warning_rounded,
                              [
                                const Color(0xFFF59E0B),
                                const Color(0xFFD97706),
                              ],
                              'À régulariser',
                              '-2.1%',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildModernCard(
                              'Appartem occupés',
                              nombreLocataires.toString(),
                              Icons.people_rounded,
                              [
                                const Color(0xFF8B5CF6),
                                const Color(0xFF7C3AED),
                              ],
                              'Actifs',
                              '+5.3%',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section détails moderne
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF667EEA),
                                    Color(0xFF764BA2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.analytics_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Détails du Mois',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1F2937),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Statistiques détaillées de votre activité',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Statistiques détaillées modernes
                        _buildModernDetailRow(
                          'Loyers attendus',
                          '${(revenusMensuels + (loyersEnRetard * 500)).toStringAsFixed(0)} \$',
                          Icons.calendar_today_rounded,
                          Colors.grey,
                          'Total prévu',
                        ),
                        _buildModernDetailRow(
                          'Loyers reçus',
                          '${(revenusMensuels - (loyersEnRetard * 500)).toStringAsFixed(0)} \$',
                          Icons.check_circle_rounded,
                          const Color(0xFF10B981),
                          'Montant collecté',
                        ),
                        _buildModernDetailRow(
                          'Taux de perception',
                          '${((revenusMensuels - (loyersEnRetard * 500)) / revenusMensuels * 100).toStringAsFixed(1)}%',
                          Icons.pie_chart_rounded,
                          const Color(0xFF2563EB),
                          'Efficacité',
                        ),
                        _buildModernDetailRow(
                          'Moyenne par locataire',
                          '${(revenusMensuels / nombreLocataires).toStringAsFixed(0)} \$',
                          Icons.person_outline_rounded,
                          const Color(0xFF8B5CF6),
                          'Revenu moyen',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildModernCard(
    String title,
    String value,
    IconData icon,
    List<Color> gradientColors,
    String subtitle,
    String trend,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              fontFamily: 'Poppins',
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.withValues(alpha: 0.6),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.withValues(alpha: 0.5),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDetailRow(
    String label,
    String value,
    IconData icon,
    Color color,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
