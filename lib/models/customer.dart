class KhachHang {
  final String maKH;
  final String tenKH;
  final String gioiTinh;
  final String ngaySinh;
  final String sdt;

  KhachHang({
    required this.maKH,
    required this.tenKH,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.sdt,
  });

  factory KhachHang.fromMap(Map<String, dynamic> map) {
    return KhachHang(
      maKH: map['MAKH'] ?? '',
      tenKH: map['TENKH'] ?? '',
      gioiTinh: map['GIOITINH'] ?? '',
      ngaySinh: map['NGAYSINH'] ?? '',
      sdt: map['SDT'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MAKH': maKH,
      'TENKH': tenKH,
      'GIOITINH': gioiTinh,
      'NGAYSINH': ngaySinh,
      'SDT': sdt,
    };
  }

  @override
  String toString() {
    return 'KhachHang(MAKH: $maKH, TENKH: $tenKH, GIOITINH: $gioiTinh, NGAYSINH: $ngaySinh, SDT: $sdt)';
  }
}
