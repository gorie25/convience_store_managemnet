import 'package:is201_prj_store_management/db/db_helper.dart';

class NhanVienRepository {
  // Lấy danh sách nhân viên
  static Future<List<Map<String, dynamic>>> layDSNV() async {
    return await DBHelper.getAllNhanVien();
  }

  // Thêm nhân viên mới
  static Future<void> themNV(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('NHANVIEN', data);
  }

  // Sửa thông tin nhân viên
  static Future<void> suaNV(String maNV, Map<String, dynamic> data) async {
    await DBHelper.updateInstance('NHANVIEN', 'MANV', maNV, data);
  }

  // Xóa nhân viên
  static Future<void> xoaNV(String maNV) async {
    await DBHelper.deleteInstance('NHANVIEN', 'MANV', maNV);
  }
}
