import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repository/HoaDonRepository.dart';
import '../../db/db_helper.dart';

class QLHDController extends GetxController {
  var hoadon = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHoaDon();
  }

  // Phương thức sinh mã HD tự động
  String layMaHDMoi() {
    final maList =
        hoadon
            .map((hd) => hd['MAHD']?.toString() ?? '')
            .where((ma) => ma.startsWith('HD'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('HD', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'HD${newNum.toString().padLeft(3, '0')}';
  }

  void fetchHoaDon() async {
    isLoading.value = true;
    hoadon.value = await HoaDonRepository.layDSHD();
    isLoading.value = false;
  }

  Future<void> XuLyYeuCauThemHD(Map<String, dynamic> data) async {
    await HoaDonRepository.themHD(data);
    fetchHoaDon();
    HienThiTBThanhCong(message: 'Thêm hóa đơn thành công');
  }

  Future<void> XuLyYeuCauThemCTHD(Map<String, dynamic> data) async {
    await HoaDonRepository.themCTHD(data);
    HienThiTBThanhCong(message: 'Thêm chi tiết hóa đơn thành công');
  }

  Future<Map<String, dynamic>?> getHoaDonByID(String maHD) async {
    return await HoaDonRepository.layHDTheoMa(maHD);
  }

  // Phương thức tìm kiếm hóa đơn
  Future<void> XuLyYeuCauTimKiem(String tuKhoa) async {
    isLoading.value = true;
    
    if (tuKhoa.isEmpty) {
      // Nếu từ khóa trống, hiển thị tất cả hóa đơn
      hoadon.value = await HoaDonRepository.layDSHD();
    } else {
      // Tìm kiếm hóa đơn dựa trên từ khóa
      final dsHoaDon = await HoaDonRepository.layDSHD();
      
      hoadon.value = dsHoaDon.where((hd) {
        final maHD = (hd['MAHD'] ?? '').toString();
        final maKH = (hd['MAKH'] ?? '').toString();
        final maNV = (hd['MANV'] ?? '').toString();
        final ngayLap = (hd['NGAYLAP'] ?? '').toString();
        
        return maHD.contains(tuKhoa) || 
               maKH.contains(tuKhoa) || 
               maNV.contains(tuKhoa) || 
               ngayLap.contains(tuKhoa);
      }).toList();
    }
    
    isLoading.value = false;
    
    // Hiển thị thông báo kết quả tìm kiếm
    if (hoadon.isEmpty && tuKhoa.isNotEmpty) {
      HienThiTBTimKiem(
        message: 'Không tìm thấy hóa đơn phù hợp',
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