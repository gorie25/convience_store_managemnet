class SanPham {
  final String maSP;
  final String tenSP;
  final String donVi;
  final int gia;
  final int soLuong;

  SanPham({
    required this.maSP,
    required this.tenSP,
    required this.donVi,
    required this.gia,
    required this.soLuong,
  });

  factory SanPham.fromMap(Map<String, dynamic> map) {
    return SanPham(
      maSP: map['MASP'] ?? '',
      tenSP: map['TENSP'] ?? '',
      donVi: map['DONVI'] ?? '',
      gia: map['GIA'] is int ? map['GIA'] : int.tryParse(map['GIA']?.toString() ?? '0') ?? 0,
      soLuong: map['SOLUONG'] is int ? map['SOLUONG'] : int.tryParse(map['SOLUONG']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MASP': maSP,
      'TENSP': tenSP,
      'DONVI': donVi,
      'GIA': gia,
      'SOLUONG': soLuong,
    };
  }

  @override
  String toString() {
    return 'SanPham(MASP: $maSP, TENSP: $tenSP, DONVI: $donVi, GIA: $gia, SOLUONG: $soLuong)';
  }
}
