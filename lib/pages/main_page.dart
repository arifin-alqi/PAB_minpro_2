import 'package:flutter/material.dart';
import 'navbar.dart';
import 'form_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBg = isDark ? const Color(0xFF1A2E1E) : Colors.white;
    final navBorder = isDark
        ? const Color(0xFF4ADE80).withOpacity(0.12)
        : const Color(0xFFBBF7D0);
    final activeColor = const Color(0xFF4ADE80);
    final inactiveColor = isDark ? Colors.white24 : Colors.grey[400]!;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // FAB di tengah navbar
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4ADE80),
        foregroundColor: const Color(0xFF0F1A12),
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormPage()),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: navBg,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: navBorder, width: 0.5)),
          ),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab Home
              _navItem(
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),

              // Spacer untuk FAB notch
              const SizedBox(width: 72),

              // Tab Profil
              _navItem(
                index: 1,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? activeColor.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                color: isActive ? activeColor : inactiveColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}