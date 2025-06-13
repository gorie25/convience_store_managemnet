class NhanVien {
  final String maNV;
  final String tenNV;
  final String gioiTinh;
  final String ngaySinh;
  final String diaChi;
  final String sdt;
  final String email;
  final int luong;
  final String vaiTro;
  final String password;

  NhanVien({
    required this.maNV,
    required this.tenNV,
    required this.gioiTinh,
    required this.ngaySinh,
    required this.diaChi,
    required this.sdt,
    required this.email,
    required this.luong,
    required this.vaiTro,
    required this.password,
  });

  factory NhanVien.fromMap(Map<String, dynamic> map) {
    return NhanVien(
      maNV: map['MANV'] ?? '',
      tenNV: map['TENNV'] ?? '',
      gioiTinh: map['GIOITINH'] ?? '',
      ngaySinh: map['NGAYSINH'] ?? '',
      diaChi: map['DIACHI'] ?? '',
      sdt: map['SDT'] ?? '',
      email: map['EMAIL'] ?? '',
      luong: map['LUONG'] is int ? map['LUONG'] : int.tryParse(map['LUONG']?.toString() ?? '0') ?? 0,
      vaiTro: map['VAITRO'] ?? '',
      password: map['PASSWORD'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'MANV': maNV,
      'TENNV': tenNV,
      'GIOITINH': gioiTinh,
      'NGAYSINH': ngaySinh,
      'DIACHI': diaChi,
      'SDT': sdt,
      'EMAIL': email,
      'LUONG': luong,
      'VAITRO': vaiTro,
      'PASSWORD': password,
    };
  }

  @override
  String toString() {
    return 'NhanVien(MANV: $maNV, TENNV: $tenNV, GIOITINH: $gioiTinh, NGAYSINH: $ngaySinh, DIACHI: $diaChi, SDT: $sdt, EMAIL: $email, LUONG: $luong, VAITRO: $vaiTro, PASSWORD: $password)';
  }
}
