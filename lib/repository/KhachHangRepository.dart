import 'package:is201_prj_store_management/db/db_helper.dart';

class KhachHangRepository {
  // Lấy danh sách khách hàng
  static Future<List<Map<String, dynamic>>> layDSKH() async {
    return await DBHelper.getAllKhachHang();
  }

  // Thêm khách hàng mới
  static Future<void> themKH(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('KHACHHANG', data);
  }

  // Sửa thông tin khách hàng
  static Future<void> suaKH(Map<String, dynamic> data) async {
    await DBHelper.updateInstance('KHACHHANG', data);
  }

  // Xóa khách hàng
  static Future<void> xoaKH(String maKH) async {
    await DBHelper.deleteInstance('KHACHHANG', maKH);
  }

  // Lấy thông tin chi tiết khách hàng theo mã
  static Future<Map<String, dynamic>?> layKHTheoMa(String maKH) async {
    return await DBHelper.getInstanceByID('KHACHHANG', 'MAKH', maKH);
  }
}