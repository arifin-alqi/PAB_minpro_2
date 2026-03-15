import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/supabase_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final email = SupabaseService().currentUser?.email ?? '-';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : '?';

    final bgColor = isDark ? const Color(0xFF0F1A12) : const Color(0xFFF0FDF4);
    final cardColor = isDark ? const Color(0xFF1A2E1E) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF4ADE80).withOpacity(0.12)
        : const Color(0xFFBBF7D0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1F2937);
    final textMuted = isDark ? Colors.white38 : Colors.grey[500]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A2E1E), const Color(0xFF233227)]
                    : [const Color(0xFF166634), const Color(0xFF16A34A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Color(0xFF0F1A12),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Karyawan Aktif',
                        style: TextStyle(
                            color: Color(0xFF4ADE80),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info akun
                  _sectionLabel('Informasi Akun', isDark),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: email,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                          isDark: isDark,
                          showDivider: true,
                        ),
                        _infoRow(
                          icon: Icons.badge_outlined,
                          label: 'Role',
                          value: 'Petugas Gadai',
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                          isDark: isDark,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pengaturan tema
                  _sectionLabel('Pengaturan', isDark),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4ADE80).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: const Color(0xFF4ADE80),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tema Tampilan',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textPrimary)),
                                Text(
                                  isDark
                                      ? 'Mode Gelap aktif'
                                      : 'Mode Terang aktif',
                                  style: TextStyle(
                                      fontSize: 12, color: textMuted),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isDark,
                            onChanged: (_) => themeProvider.toggleTheme(),
                            activeColor: const Color(0xFF4ADE80),
                            activeTrackColor:
                                const Color(0xFF4ADE80).withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1A2E1E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: const Text('Logout',
                                style: TextStyle(color: Colors.white)),
                            content: const Text('Yakin ingin keluar?',
                                style: TextStyle(color: Colors.white70)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Batal',
                                    style: TextStyle(
                                        color: Color(0xFF4ADE80))),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                child: const Text('Logout',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await SupabaseService().signOut();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Logout',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark
                ? const Color(0xFF4ADE80)
                : const Color(0xFF15803D),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textPrimary,
    required Color textMuted,
    required bool isDark,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    Icon(icon, color: const Color(0xFF4ADE80), size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(fontSize: 12, color: textMuted)),
                    const SizedBox(height: 2),
                    Text(value,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textPrimary),
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: isDark
                ? const Color(0xFF4ADE80).withOpacity(0.08)
                : const Color(0xFFBBF7D0),
          ),
      ],
    );
  }
}