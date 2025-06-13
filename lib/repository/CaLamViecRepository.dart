import 'package:is201_prj_store_management/db/db_helper.dart';

class CaLamViecRepository {
  // Lấy danh sách ca làm việc
  static Future<List<Map<String, dynamic>>> layDSCLV() async {
    return await DBHelper.getAllCaLV();
  }

  // Thêm ca làm việc mới
  static Future<void> themCLV(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('CALAMVIEC', data);
  }
  
  // Lấy thông tin chi tiết ca làm việc theo mã
  static Future<Map<String, dynamic>?> layCLVTheoMa(String maCLV) async {
    return await DBHelper.getInstanceByID('CALAMVIEC', 'MACLV', maCLV);
  }
  
  // Lấy danh sách ca làm việc theo nhân viên
  static Future<List<Map<String, dynamic>>> layDSCLVTheoNV(String maNV) async {
    final dsCLV = await layDSCLV();
    return dsCLV.where((clv) => clv['MANV'] == maNV).toList();
  }
  
  // Lấy danh sách ca làm việc theo ngày
  static Future<List<Map<String, dynamic>>> layDSCLVTheoNgay(String ngay) async {
    final dsCLV = await layDSCLV();
    return dsCLV.where((clv) => clv['NGAY'] == ngay).toList();
  }
}