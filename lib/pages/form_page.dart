import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaksi.dart';
import '../services/supabase_service.dart';

class FormPage extends StatefulWidget {
  final Transaksi? transaksi;
  const FormPage({super.key, this.transaksi});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _service = SupabaseService();
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noHpController = TextEditingController();
  final _jenisController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _nilaiController = TextEditingController();
  bool _isLoading = false;
  bool get _isEdit => widget.transaksi != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _namaController.text = widget.transaksi!.nama;
      _noHpController.text = widget.transaksi!.noHp;
      _jenisController.text = widget.transaksi!.jenisBarang;
      _deskripsiController.text = widget.transaksi!.deskripsi;
      _nilaiController.text =
          widget.transaksi!.nilaiTaksiran.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noHpController.dispose();
    _jenisController.dispose();
    _deskripsiController.dispose();
    _nilaiController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final double nilai =
          double.parse(_nilaiController.text.replaceAll('.', ''));
      final double pinjaman = nilai * 0.7;

      if (_isEdit) {
        final updated = Transaksi(
          id: widget.transaksi!.id,
          nama: _namaController.text.trim(),
          noHp: _noHpController.text.trim(),
          jenisBarang: _jenisController.text.trim(),
          deskripsi: _deskripsiController.text.trim(),
          nilaiTaksiran: nilai,
          pinjaman: pinjaman,
        );
        final result = await _service.updateTransaksi(updated);
        if (mounted) Navigator.pop(context, result);
      } else {
        final newT = Transaksi(
          nama: _namaController.text.trim(),
          noHp: _noHpController.text.trim(),
          jenisBarang: _jenisController.text.trim(),
          deskripsi: _deskripsiController.text.trim(),
          nilaiTaksiran: nilai,
          pinjaman: pinjaman,
        );
        final result = await _service.addTransaksi(newT);
        if (mounted) Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menyimpan: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? const Color(0xFF0F1A12) : const Color(0xFFF0FDF4);
    final cardColor = isDark ? const Color(0xFF1A2E1E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF4ADE80).withOpacity(0.15)
        : const Color(0xFFBBF7D0);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final labelColor = isDark ? Colors.white38 : Colors.grey[600]!;
    final iconColor =
        isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor:
            isDark ? const Color(0xFF1A2E1E) : const Color(0xFF166534),
        title: Text(
          _isEdit ? 'Edit Transaksi' : 'Tambah Transaksi',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.arrow_back, color: Colors.white, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Nama Nasabah ──
              _sectionLabel('Data Nasabah', isDark),
              const SizedBox(height: 10),
              _buildField(
                controller: _namaController,
                label: 'Nama Nasabah',
                hint: 'Masukkan nama lengkap nasabah',
                helperText: 'Sesuaikan dengan nama di KTP',
                icon: Icons.person_outline,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                labelColor: labelColor,
                iconColor: iconColor,
              ),
              const SizedBox(height: 14),

              // ── No HP ──
              _buildField(
                controller: _noHpController,
                label: 'Nomor HP',
                hint: 'Contoh: 08123456789',
                helperText: 'Hanya angka, tanpa tanda hubung atau spasi',
                icon: Icons.phone_outlined,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                labelColor: labelColor,
                iconColor: iconColor,
                type: TextInputType.number,
                // hanya izinkan angka
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nomor HP harus diisi';
                  if (v.length < 9) return 'Nomor HP minimal 9 digit';
                  if (v.length > 13) return 'Nomor HP maksimal 13 digit';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ── Data Barang ──
              _sectionLabel('Data Barang', isDark),
              const SizedBox(height: 10),
              _buildField(
                controller: _jenisController,
                label: 'Jenis Barang',
                hint: 'Contoh: Emas, Elektronik, Kendaraan',
                helperText: 'Kategori umum barang yang digadaikan',
                icon: Icons.inventory_2_outlined,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                labelColor: labelColor,
                iconColor: iconColor,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _deskripsiController,
                label: 'Deskripsi Barang',
                hint: 'Contoh: Kalung emas 18k, berat 5 gram',
                helperText: 'Deskripsikan kondisi dan detail barang secara singkat',
                icon: Icons.description_outlined,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                labelColor: labelColor,
                iconColor: iconColor,
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // ── Nilai Taksiran ──
              _sectionLabel('Nilai Pinjaman', isDark),
              const SizedBox(height: 10),
              _buildField(
                controller: _nilaiController,
                label: 'Nilai Taksiran (Rp)',
                hint: 'Contoh: 5000000',
                helperText: 'Nilai barang hasil estimasi petugas penaksir',
                icon: Icons.monetization_on_outlined,
                cardColor: cardColor,
                borderColor: borderColor,
                textColor: textColor,
                labelColor: labelColor,
                iconColor: iconColor,
                type: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nilai taksiran harus diisi';
                  if (double.tryParse(v) == null) return 'Masukkan angka yang valid';
                  if (double.parse(v) <= 0) return 'Nilai taksiran harus lebih dari 0';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // ── Info Box ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF4ADE80).withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xFF4ADE80), size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perhitungan Pinjaman',
                            style: TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Pinjaman yang diberikan sebesar 70% dari nilai taksiran barang. Contoh: taksiran Rp 1.000.000 → pinjaman Rp 700.000.',
                            style: TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Tombol Simpan ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _simpanData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ADE80),
                    foregroundColor: const Color(0xFF0F1A12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF0F1A12)))
                      : Icon(_isEdit ? Icons.save : Icons.add_circle_outline),
                  label: Text(
                    _isEdit ? 'Simpan Perubahan' : 'Tambah Transaksi',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Label section seperti "Data Nasabah", "Data Barang"
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
            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String helperText,
    required IconData icon,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
    required Color labelColor,
    required Color iconColor,
    TextInputType type = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: type,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              hintStyle: TextStyle(
                  color: labelColor.withOpacity(0.5), fontSize: 13),
              labelStyle: TextStyle(color: labelColor, fontSize: 13),
              prefixIcon: Icon(icon, color: iconColor, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
            ),
            validator: validator ??
                (v) => v == null || v.isEmpty ? '$label harus diisi' : null,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            helperText,
            style: TextStyle(
              fontSize: 11,
              color: labelColor.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}