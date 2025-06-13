import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repository/CaLamViecRepository.dart';
import '../../db/db_helper.dart';

class QLCAController extends GetxController {
  var calamviec = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCaLamViec();
  }

  // Phương thức sinh mã CA tự động
  String layMaCAMoi() {
    final maList =
        calamviec
            .map((ca) => ca['MACLV']?.toString() ?? '')
            .where((ma) => ma.startsWith('CA'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('CA', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'CA${newNum.toString().padLeft(3, '0')}';
  }

  void fetchCaLamViec() async {
    isLoading.value = true;
    calamviec.value = await CaLamViecRepository.layDSCLV();
    isLoading.value = false;
  }

  Future<void> XuLyYeuCauThemCA(Map<String, dynamic> data) async {
    await CaLamViecRepository.themCLV(data);
    fetchCaLamViec();
    HienThiTBThanhCong(message: 'Thêm ca làm việc thành công');
  }

  Future<Map<String, dynamic>?> getCaLamViecByID(String maCLV) async {
    return await CaLamViecRepository.layCLVTheoMa(maCLV);
  }

  // Phương thức tìm kiếm ca làm việc
  Future<void> XuLyYeuCauTimKiem(String tuKhoa) async {
    isLoading.value = true;
    
    if (tuKhoa.isEmpty) {
      // Nếu từ khóa trống, hiển thị tất cả ca làm việc
      calamviec.value = await CaLamViecRepository.layDSCLV();
    } else {
      // Tìm kiếm ca làm việc dựa trên từ khóa
      final dsCaLamViec = await CaLamViecRepository.layDSCLV();
      final tuKhoaLowerCase = tuKhoa.toLowerCase();
      
      calamviec.value = dsCaLamViec.where((ca) {
        final tenCa = (ca['TENCA'] ?? '').toString().toLowerCase();
        final gioBD = (ca['GIOBD'] ?? '').toString();
        final gioKT = (ca['GIOKT'] ?? '').toString();
        
        return tenCa.contains(tuKhoaLowerCase) || 
               gioBD.contains(tuKhoa) || 
               gioKT.contains(tuKhoa);
      }).toList();
    }
    
    isLoading.value = false;
    
    // Hiển thị thông báo kết quả tìm kiếm
    if (calamviec.isEmpty && tuKhoa.isNotEmpty) {
      HienThiTBTimKiem(
        message: 'Không tìm thấy ca làm việc phù hợp',
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