import 'package:flutter/material.dart';
import 'package:gestion_loyer/pages/biens_page.dart';
import 'package:gestion_loyer/pages/dashboard_page.dart';
import 'package:gestion_loyer/pages/locataires_page.dart';
import 'package:gestion_loyer/pages/paiements_page.dart';
import 'package:gestion_loyer/pages/parametres_page.dart';

class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MainPageAdminState();
}

class _MainPageAdminState extends State<MainPageAdmin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    PaiementsPage(),
    LocatairesPage(),
    BiensPage(),
    ParametresPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Accueil',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.payment_outlined,
                  selectedIcon: Icons.payment_rounded,
                  label: 'Paiement',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.people_outlined,
                  selectedIcon: Icons.people_rounded,
                  label: 'Locataires',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.home_work_outlined,
                  selectedIcon: Icons.home_work_rounded,
                  label: 'Appartements',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'Params',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected ? selectedIcon : icon),
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : Colors.grey.shade600,
                size: 26,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : Colors.grey.shade600,
                fontSize: isSelected ? 13 : 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
