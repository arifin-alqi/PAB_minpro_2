import 'package:flutter/material.dart';
import '../models/transaksi.dart';

class DetailPage extends StatelessWidget {
  final Transaksi transaksi;
  const DetailPage({super.key, required this.transaksi});

  String _formatRupiah(double amount) {
    final str = amount.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result = '.$result';
      result = str[i] + result;
      count++;
    }
    return 'Rp $result';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final d = date.toLocal();
    const bulan = ['','Januari','Februari','Maret','April','Mei','Juni',
        'Juli','Agustus','September','Oktober','November','Desember'];
    return '${d.day} ${bulan[d.month]} ${d.year}, '
        '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F1A12) : const Color(0xFFF0FDF4);
    final cardColor = isDark ? const Color(0xFF1A2E1E) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF4ADE80).withOpacity(0.12)
        : const Color(0xFFBBF7D0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1F2937);
    final textMuted = isDark ? Colors.white38 : Colors.grey[500]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [

          // ── HEADER ──
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            backgroundColor:
                isDark ? const Color(0xFF1A2E1E) : const Color(0xFF166634),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Detail Transaksi',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 28),
                      // Avatar
                      Container(
                        width: 68,
                        height: 68,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF4ADE80).withOpacity(0.5),
                              width: 2),
                        ),
                        child: const Icon(Icons.person,
                            color: Color(0xFF4ADE80), size: 36),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        transaksi.nama,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_outlined,
                              color: Colors.white.withOpacity(0.5), size: 13),
                          const SizedBox(width: 4),
                          Text(
                            transaksi.noHp,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── BODY ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Pinjaman card (highlight) ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF15803D), Color(0xFF16A34A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pinjaman Diberikan',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatRupiah(transaksi.pinjaman),
                              style: const TextStyle(
                                  color: Color(0xFF4ADE80),
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFF4ADE80).withOpacity(0.4)),
                          ),
                          child: const Text(
                            '70%',
                            style: TextStyle(
                                color: Color(0xFF4ADE80),
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Nilai Taksiran ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ADE80).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.monetization_on_outlined,
                              color: Color(0xFF4ADE80), size: 20),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nilai Taksiran',
                                style: TextStyle(
                                    fontSize: 12, color: textMuted)),
                            const SizedBox(height: 3),
                            Text(
                              _formatRupiah(transaksi.nilaiTaksiran),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Section label ──
                  _sectionLabel('Informasi Barang', isDark),
                  const SizedBox(height: 10),

                  // ── Detail rows ──
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: cardBorder),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _detailRow(
                          isDark: isDark,
                          icon: Icons.inventory_2_outlined,
                          iconColor: const Color(0xFF4ADE80),
                          label: 'Jenis Barang',
                          value: transaksi.jenisBarang,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                        _divider(isDark),
                        _detailRow(
                          isDark: isDark,
                          icon: Icons.description_outlined,
                          iconColor: const Color(0xFF16A34A),
                          label: 'Deskripsi Barang',
                          value: transaksi.deskripsi,
                          textPrimary: textPrimary,
                          textMuted: textMuted,
                        ),
                        if (transaksi.createdAt != null) ...[
                          _divider(isDark),
                          _detailRow(
                            isDark: isDark,
                            icon: Icons.access_time_outlined,
                            iconColor: Colors.orange,
                            label: 'Tanggal Transaksi',
                            value: _formatDate(transaksi.createdAt),
                            textPrimary: textPrimary,
                            textMuted: textMuted,
                          ),
                        ],
                      ],
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

  Widget _detailRow({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color textPrimary,
    required Color textMuted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: textMuted)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isDark) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Divider(
          height: 1,
          color: isDark
              ? const Color(0xFF4ADE80).withOpacity(0.08)
              : const Color(0xFFBBF7D0),
        ),
      );
}