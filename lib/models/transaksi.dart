class Transaksi {
  final int? id;          
  String nama;           
  String noHp;           
  String jenisBarang;     
  String deskripsi;      
  double nilaiTaksiran;   
  double pinjaman;      
  final DateTime? createdAt; 
  Transaksi({
    this.id,
    required this.nama,
    required this.noHp,
    required this.jenisBarang,
    required this.deskripsi,
    required this.nilaiTaksiran,
    required this.pinjaman,
    this.createdAt,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] as int?,
      nama: json['nama_lengkap'] ?? '',
      noHp: json['no_hp'] ?? '',
      jenisBarang: json['jn_brng'] ?? '',
      deskripsi: json['dskri_brng'] ?? '',
      nilaiTaksiran: double.tryParse(json['nilai_tafs']?.toString() ?? '0') ?? 0,
      pinjaman: double.tryParse(json['pinjaman']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_lengkap': nama,
      'no_hp': noHp,
      'jn_brng': jenisBarang,
      'dskri_brng': deskripsi,
      'nilai_tafs': nilaiTaksiran,
      'pinjaman': pinjaman,
    };
  }
}