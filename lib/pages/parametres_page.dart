import 'package:flutter/material.dart';

class ParametresPage extends StatelessWidget {
  ParametresPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header profil utilisateur
            Container(
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
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      backgroundImage: const AssetImage(
                        'assets/image/fond.jpeg',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Admin Van Mut',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'admin@vanmut.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Administrateur',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section Compte
            _buildSettingsSection('Compte', Icons.person_rounded, [
              _buildSettingsItem(
                'Informations personnelles',
                'Modifiez vos informations',
                Icons.person_outline_rounded,
                () {},
              ),
              _buildSettingsItem(
                'Mot de passe',
                'Changez votre mot de passe',
                Icons.lock_outline_rounded,
                () {},
              ),
              _buildSettingsItem(
                'Authentification',
                'Configurez la double authentification',
                Icons.security_rounded,
                () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Section Préférences
            _buildSettingsSection('Préférences', Icons.tune_rounded, [
              _buildSettingsItem(
                'Notifications',
                'Gérez les notifications push',
                Icons.notifications_outlined,
                () {},
              ),
              _buildSettingsItem(
                'Langue',
                'Français',
                Icons.language_outlined,
                () {},
              ),
              _buildSettingsItem(
                'Thème',
                'Clair',
                Icons.palette_outlined,
                () {},
              ),
              _buildSettingsItem(
                'Monnaie',
                'USD \$',
                Icons.attach_money_outlined,
                () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Section Application
            _buildSettingsSection('Application', Icons.apps_rounded, [
              _buildSettingsItem(
                'Sauvegarde',
                'Configurez la sauvegarde automatique',
                Icons.cloud_upload_outlined,
                () {},
              ),
              _buildSettingsItem(
                'Exportation',
                'Exportez vos données',
                Icons.file_download_outlined,
                () {},
              ),
              _buildSettingsItem(
                'À propos',
                'Version 1.0.0',
                Icons.info_outline_rounded,
                () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Section Support
            _buildSettingsSection('Support', Icons.support_agent_rounded, [
              _buildSettingsItem(
                'Aide',
                'Consultez notre centre d\'aide',
                Icons.help_outline_rounded,
                () {},
              ),
              _buildSettingsItem(
                'Contact',
                'Contactez notre support',
                Icons.mail_outline_rounded,
                () {},
              ),
              _buildSettingsItem(
                'Signaler un problème',
                'Signalez un bug ou problème',
                Icons.bug_report_outlined,
                () {},
              ),
            ]),

            const SizedBox(height: 24),

            // Bouton déconnexion
            Container(
              width: double.infinity,
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
                  color: Colors.red.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Déconnexion',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          'Déconnectez-vous de votre compte',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> items,
  ) {
    return Container(
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
      ),
      child: Column(
        children: [
          // Header de section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // Items de la section
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.grey.shade600, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
