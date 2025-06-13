class HoaDon {
  int? id;
  String maHD;
  String maNV;
  String maKH;
  String ngayHD;
  double tongTien;

  HoaDon({this.id, required this.maHD, required this.maNV, required this.maKH, required this.ngayHD, required this.tongTien});

  Map<String, dynamic> toMap() => {
    'id': id,
    'MAHD': maHD,
    'MANV': maNV,
    'MAKH': maKH,
    'NGAYHD': ngayHD,
    'TONGTIEN': tongTien,
  };
}
