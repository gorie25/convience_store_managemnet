import 'package:is201_prj_store_management/db/db_helper.dart';

class KhuyenMaiRepository {
  // Lấy danh sách khuyến mãi
  static Future<List<Map<String, dynamic>>> layDSKM() async {
    return await DBHelper.getAllKhuyenMai();
  }

  // Thêm khuyến mãi mới
  static Future<void> themKM(Map<String, dynamic> data) async {
    await DBHelper.insertInstanceTest('KHUYENMAI', data);
  }

  // Sửa thông tin khuyến mãi
  static Future<void> suaKM(Map<String, dynamic> data) async {
    await DBHelper.updateInstance('KHUYENMAI', data);
  }

  // Xóa khuyến mãi
  static Future<void> xoaKM(String maKM) async {
    await DBHelper.deleteInstance('KHUYENMAI', maKM);
  }

  // Lấy thông tin chi tiết khuyến mãi theo mã
  static Future<Map<String, dynamic>?> layKMTheoMa(String maKM) async {
    return await DBHelper.getInstanceByID('KHUYENMAI', 'MAKM', maKM);
  }
  
  // Lấy danh sách khuyến mãi đang áp dụng (chưa hết hạn)
  static Future<List<Map<String, dynamic>>> layDSKMHieuLuc() async {
    final dsKhuyenMai = await layDSKM();
    final now = DateTime.now();
    
    return dsKhuyenMai.where((km) {
      // Kiểm tra ngày kết thúc
      if (km['NGAYKETTHUC'] != null) {
        try {
          final ngayKetThuc = DateTime.parse(km['NGAYKETTHUC']);
          return ngayKetThuc.isAfter(now);
        } catch (e) {
          return false;
        }
      }
      return false;
    }).toList();
  }
}