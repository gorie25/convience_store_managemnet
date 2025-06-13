import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db/db_helper.dart';
import '../../repository/KhachHangRepository.dart';

class KhachHangController extends GetxController {
  var khachhang = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhachHang();
  }

  // Phương thức sinh mã KH tự động
  String layMaKHMoi() {
    final maList =
        khachhang
            .map((kh) => kh['MAKH']?.toString() ?? '')
            .where((ma) => ma.startsWith('KH'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('KH', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'KH${newNum.toString().padLeft(3, '0')}';
  }

  void fetchKhachHang() async {
    isLoading.value = true;
    khachhang.value = await KhachHangRepository.layDSKH();
    isLoading.value = false;
  }

  Future<void> XuLyYeuCauThemKH(Map<String, dynamic> data) async {
    await KhachHangRepository.themKH(data);
    fetchKhachHang();
    HienThiTBThanhCong(message: 'Thêm khách hàng thành công');
  }

  Future<void> XuLyYeuCauSuaKH(Map<String, dynamic> data) async {
    await KhachHangRepository.suaKH(data);
    fetchKhachHang();
    HienThiTBThanhCong(message: 'Cập nhật khách hàng thành công');
  }

  Future<bool> XuLyYeuCauXoaKH(String maKH) async {
    try {
      // Thực hiện xóa khách hàng
      await KhachHangRepository.xoaKH(maKH);
      
      // Cập nhật danh sách khách hàng
      fetchKhachHang();
      
      // Hiển thị thông báo thành công
      HienThiTBThanhCong(
        message: 'Xóa khách hàng thành công',
        backgroundColor: Colors.green,
      );
      
      return true;
    } catch (e) {
      // Xử lý lỗi nếu có
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xóa khách hàng: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.2),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.error, color: Colors.red),
      );
      return false;
    }
  }

  // Key truyền vào là mã khách hàng (MAKH)
  Future<Map<String, dynamic>?> getKhachHangByID(String maKH) async {
    return await DBHelper.getInstanceByID('KHACHHANG', 'MAKH', maKH);
  }

  // Phương thức tìm kiếm khách hàng
  Future<void> XuLyYeuCauTimKiem(String tuKhoa) async {
    isLoading.value = true;
    
    if (tuKhoa.isEmpty) {
      // Nếu từ khóa trống, hiển thị tất cả khách hàng
      khachhang.value = await KhachHangRepository.layDSKH();
    } else {
      // Tìm kiếm khách hàng dựa trên từ khóa
      final dsKhachHang = await KhachHangRepository.layDSKH();
      final tuKhoaLowerCase = tuKhoa.toLowerCase();
      
      khachhang.value = dsKhachHang.where((kh) {
        final tenKH = (kh['TENKH'] ?? '').toString().toLowerCase();
        final sdt = (kh['SDT'] ?? '').toString();
        return tenKH.contains(tuKhoaLowerCase) || sdt.contains(tuKhoa);
      }).toList();
    }
    
    isLoading.value = false;
    
    // Hiển thị thông báo kết quả tìm kiếm
    if (khachhang.isEmpty) {
      HienThiTBTimKiem(
        message: 'Không tìm thấy khách hàng phù hợp',
        backgroundColor: Colors.orange,
      );
    } else if (tuKhoa.isNotEmpty) {
      HienThiTBTimKiem(
        message: 'Đã tìm thấy ${khachhang.length} khách hàng phù hợp',
        backgroundColor: Colors.blue,
      );
    }
  }

  // Hiển thị thông báo thành công
  void HienThiTBThanhCong({
    String title = 'Thông báo',
    required String message,
    Color backgroundColor = Colors.green,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor.withOpacity(0.2),
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.green),
      borderRadius: 10,
    );
  }
  
  // Hiển thị thông báo tìm kiếm
  void HienThiTBTimKiem({
    String title = 'Thông báo',
    required String message,
    Color backgroundColor = Colors.blue,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor.withOpacity(0.2),
      colorText: Colors.black,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.search, color: Colors.blue),
      borderRadius: 10,
    );
  }
}