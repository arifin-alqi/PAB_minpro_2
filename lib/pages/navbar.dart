import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaksi.dart';
import '../providers/theme_provider.dart';
import '../services/supabase_service.dart';
import 'form_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = SupabaseService();
  List<Transaksi> _daftarTransaksi = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  Future<void> _loadTransaksi() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getTransaksi();
      if (mounted) setState(() { _daftarTransaksi = data; _isLoading = false; });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Gagal memuat data', isError: true);
      }
    }
  }

  Future<void> _deleteTransaksi(int id, int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Transaksi', style: TextStyle(color: Colors.white)),
        content: const Text('Yakin ingin menghapus transaksi ini?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF4ADE80))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _service.deleteTransaksi(id);
      setState(() => _daftarTransaksi.removeAt(index));
      if (mounted) _showSnackBar('Transaksi berhasil dihapus');
    } catch (e) {
      if (mounted) _showSnackBar('Gagal menghapus', isError: true);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A2E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Yakin ingin keluar?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Color(0xFF4ADE80))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _service.signOut();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : const Color(0xFF16A34A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

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

  double get _totalPinjaman =>
      _daftarTransaksi.fold(0, (sum, t) => sum + t.pinjaman);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final bgColor = isDark ? const Color(0xFF0F1A12) : const Color(0xFFF0FDF4);
    final cardColor = isDark ? const Color(0xFF1A2E1E) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF4ADE80).withOpacity(0.12)
        : const Color(0xFFBBF7D0);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1F2937);
    final textMuted = isDark ? Colors.white38 : Colors.grey[500]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: _loadTransaksi,
        color: const Color(0xFF4ADE80),
        child: CustomScrollView(
          slivers: [

            // ── HEADER ──
            SliverToBoxAdapter(
              child: Container(
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
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4ADE80).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.storefront,
                                    color: Color(0xFF4ADE80), size: 18),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'GADAIIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ]),
                            Row(children: [
                              GestureDetector(
                                onTap: _loadTransaksi,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.refresh,
                                      color: Colors.white70, size: 18),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => themeProvider.toggleTheme(),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isDark ? Icons.dark_mode : Icons.light_mode,
                                    color: const Color(0xFF4ADE80),
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _logout,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.logout,
                                      color: Colors.white70, size: 18),
                                ),
                              ),
                            ]),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Transaksi Gadai',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ── STAT CARDS ──
                        Row(children: [
                          Expanded(
                            child: _statCard(
                              label: 'Total Transaksi',
                              value: '${_daftarTransaksi.length}',
                              icon: Icons.receipt_long_outlined,
                              cardColor: isDark
                                  ? const Color(0xFF233227)
                                  : Colors.white.withOpacity(0.18),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _statCard(
                              label: 'Total Pinjaman',
                              value: _formatRupiah(_totalPinjaman),
                              icon: Icons.account_balance_wallet_outlined,
                              cardColor: isDark
                                  ? const Color(0xFF233227)
                                  : Colors.white.withOpacity(0.18),
                              smallValue: true,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── SECTION TITLE ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Daftar Transaksi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ),
            ),

            // ── LIST ──
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF4ADE80)),
                ),
              )
            else if (_daftarTransaksi.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF4ADE80).withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.inbox_outlined,
                            size: 44, color: Color(0xFF4ADE80)),
                      ),
                      const SizedBox(height: 18),
                      Text('Belum ada transaksi',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: textPrimary)),
                      const SizedBox(height: 6),
                      Text('Tap tombol + untuk menambah',
                          style: TextStyle(fontSize: 13, color: textMuted)),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCard(
                      _daftarTransaksi[index],
                      index,
                      cardColor,
                      cardBorder,
                      textPrimary,
                      textMuted,
                    ),
                    childCount: _daftarTransaksi.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color cardColor,
    bool smallValue = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF4ADE80).withOpacity(0.2),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: const Color(0xFF4ADE80), size: 17),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: smallValue ? 14 : 22,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.6), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildCard(
    Transaksi t,
    int index,
    Color cardColor,
    Color borderColor,
    Color textPrimary,
    Color textMuted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => DetailPage(transaksi: t))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF15803D), Color(0xFF16A34A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.nama,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: textPrimary)),
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 12, color: textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(t.jenisBarang,
                            style: TextStyle(fontSize: 12, color: textMuted),
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4ADE80).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatRupiah(t.pinjaman),
                        style: const TextStyle(
                          color: Color(0xFF4ADE80),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(children: [
                _actionBtn(Icons.edit, Colors.orange, () async {
                  final hasil = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FormPage(transaksi: t)),
                  );
                  if (hasil != null)
                    setState(() => _daftarTransaksi[index] = hasil);
                }),
                const SizedBox(height: 6),
                _actionBtn(Icons.delete, Colors.red,
                    () => _deleteTransaksi(t.id!, index)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(9),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 17),
        onPressed: onTap,
      ),
    );
  }
}