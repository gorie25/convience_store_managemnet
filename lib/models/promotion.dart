class KhuyenMai {
  final String maKM;
  final String tenKM;
  final int phanTram;
  final String ngayBatDau;
  final String ngayKetThuc;

  KhuyenMai({
    required this.maKM,
    required this.tenKM,
    required this.phanTram,
    required this.ngayBatDau,
    required this.ngayKetThuc,
  });

  factory KhuyenMai.fromMap(Map<String, dynamic> map) {
    return KhuyenMai(
      maKM: map['MAKM'] ?? '',
      tenKM: map['TENKM'] ?? '',
      phanTram: map['PHANTRAM'] is int ? map['PHANTRAM'] : int.tryParse(map['PHANTRAM']?.toString() ?? '0') ?? 0,
      ngayBatDau: map['NGAYBATDAU'] ?? '',
      ngayKetThuc: map['NGAYKETTHUC'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MAKM': maKM,
      'TENKM': tenKM,
      'PHANTRAM': phanTram,
      'NGAYBATDAU': ngayBatDau,
      'NGAYKETTHUC': ngayKetThuc,
    };
  }

  @override
  String toString() {
    return 'KhuyenMai(MAKM: $maKM, TENKM: $tenKM, PHANTRAM: $phanTram, NGAYBATDAU: $ngayBatDau, NGAYKETTHUC: $ngayKetThuc)';
  }
}
