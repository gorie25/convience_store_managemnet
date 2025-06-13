import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db/db_helper.dart';
import '../../repository/KhuyenMaiRepository.dart';

class QLKMController extends GetxController {
  var khuyenmai = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhuyenMai();
  }

  // Phương thức sinh mã KM tự động
  String layMaKMMoi() {
    final maList =
        khuyenmai
            .map((km) => km['MAKM']?.toString() ?? '')
            .where((ma) => ma.startsWith('KM'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('KM', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'KM${newNum.toString().padLeft(3, '0')}';
  }

  void fetchKhuyenMai() async {
    isLoading.value = true;
    khuyenmai.value = (await DBHelper.getAllKhuyenMai()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> XuLyYeuCauThemKM(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('KHUYENMAI', 'MAKM', data);
    fetchKhuyenMai();
    HienThiTBThanhCong(message: 'Thêm khuyến mãi thành công');
  }

  Future<void> XuLyYeuCauSuaKM(Map<String, dynamic> data) async {
    await DBHelper.updateInstance('KHUYENMAI', data);
    fetchKhuyenMai();
    HienThiTBThanhCong(message: 'Cập nhật khuyến mãi thành công');
  }

  Future<bool> XuLyYeuCauXoaKM(String maKM) async {
    try {
      await DBHelper.deleteInstance('KHUYENMAI', maKM);
      fetchKhuyenMai();
      HienThiTBThanhCong(
        message: 'Xóa khuyến mãi thành công',
        backgroundColor: Colors.red,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xóa khuyến mãi: ${e.toString()}',
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

  Future<Map<String, dynamic>?> getKhuyenMaiByID(String maKM) async {
    return await DBHelper.getInstanceByID('KHUYENMAI', 'MAKM', maKM);
  }

  // Phương thức tìm kiếm khuyến mãi
  Future<void> XuLyYeuCauTimKiem(String tuKhoa) async {
    isLoading.value = true;
    
    if (tuKhoa.isEmpty) {
      khuyenmai.value = (await DBHelper.getAllKhuyenMai()).cast<Map<String, dynamic>>();
    } else {
      final dsKhuyenMai = (await DBHelper.getAllKhuyenMai()).cast<Map<String, dynamic>>();
      final tuKhoaLowerCase = tuKhoa.toLowerCase();
      
      khuyenmai.value = dsKhuyenMai.where((km) {
        final tenKM = (km['TENKM'] ?? '').toString().toLowerCase();
        return tenKM.contains(tuKhoaLowerCase);
      }).toList();
    }
    
    isLoading.value = false;
    
    if (khuyenmai.isEmpty && tuKhoa.isNotEmpty) {
      HienThiTBTimKiem(
        message: 'Không tìm thấy khuyến mãi phù hợp',
        backgroundColor: Colors.orange,
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