import 'package:get/get.dart';
import 'package:is201_prj_store_management/db/db_helper.dart';

class DangNhapRepository {
  // Trả về thông tin nhân viên nếu tìm thấy, ngược lại trả về null
  static Future<Map<String, dynamic>?> timTTDangNhap(String username) async {
    final nhanViens = await DBHelper.getAllNhanVien();
    return nhanViens.firstWhereOrNull(
      (nv) => nv['MANV'] == username || nv['TENNV'] == username,
    );
  }
}
