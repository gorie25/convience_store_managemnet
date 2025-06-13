import 'package:is201_prj_store_management/db/db_helper.dart';

class SanPhamRepository {
  // Lấy danh sách sản phẩm
  static Future<List<Map<String, dynamic>>> layDSSP() async {
    return await DBHelper.getAllSanPham();
  }

  // Thêm sản phẩm mới
  static Future<void> themSP(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('SANPHAM', data);
  }

  // Sửa thông tin sản phẩm
  static Future<void> suaSP(Map<String, dynamic> data) async {
    await DBHelper.updateInstance('SANPHAM', data);
  }

  // Xóa sản phẩm
  static Future<void> xoaSP(String maSP) async {
    await DBHelper.deleteInstance('SANPHAM', maSP);
  }

  
}