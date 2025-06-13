import 'package:is201_prj_store_management/db/db_helper.dart';

class HoaDonRepository {
  // Lấy danh sách hóa đơn
  static Future<List<Map<String, dynamic>>> layDSHD() async {
    return await DBHelper.getAllHoaDon();
  }

  // Thêm hóa đơn mới
  static Future<void> themHD(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('HOADON', data);
  }
  
  // Thêm chi tiết hóa đơn
  static Future<void> themCTHD(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('CHITIETHOADON', data);
  }
  
  // Lấy thông tin chi tiết hóa đơn theo mã
  static Future<Map<String, dynamic>?> layHDTheoMa(String maHD) async {
    return await DBHelper.getInstanceByID('HOADON', 'MAHD', maHD);
  }
  
  // // Lấy chi tiết hóa đơn theo mã hóa đơn
  // static Future<List<Map<String, dynamic>>> layCTHDTheoMaHD(String maHD) async {
  //   return await DBHelper.getInstancesByColumn('CHITIETHOADON', 'MAHD', maHD);
  // }
  
  // Lấy danh sách hóa đơn theo khách hàng
  static Future<List<Map<String, dynamic>>> layDSHDTheoKH(String maKH) async {
    final dsHD = await layDSHD();
    return dsHD.where((hd) => hd['MAKH'] == maKH).toList();
  }
  
  // Lấy danh sách hóa đơn theo nhân viên
  static Future<List<Map<String, dynamic>>> layDSHDTheoNV(String maNV) async {
    final dsHD = await layDSHD();
    return dsHD.where((hd) => hd['MANV'] == maNV).toList();
  }
  
  // Lấy danh sách hóa đơn theo ngày
  static Future<List<Map<String, dynamic>>> layDSHDTheoNgay(String ngay) async {
    final dsHD = await layDSHD();
    return dsHD.where((hd) => hd['NGAYLAP'] == ngay).toList();
  }
  
//   // Tính tổng tiền hóa đơn
//   static Future<double> tinhTongTienHD(String maHD) async {
//     final chiTietList = ;
//     double tongTien = 0;
//     for (var ct in chiTietList) {
//       tongTien += (ct['SOLUONG'] ?? 0) * (ct['DONGIA'] ?? 0);
//     }
//     return tongTien;
//   }
// }
}