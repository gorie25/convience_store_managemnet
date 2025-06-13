import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/repository/SanPhamRepository.dart';
import '../../db/db_helper.dart';

class QLSPController extends GetxController {
  var sanpham = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSanPham();
  }

  // Phương thức sinh mã SP tự động
  String layMaSPMoi() {
    final maList =
        sanpham
            .map((sp) => sp['MASP']?.toString() ?? '')
            .where((ma) => ma.startsWith('SP'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('SP', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'SP${newNum.toString().padLeft(3, '0')}';
  }

  void fetchSanPham() async {
    isLoading.value = true;
    sanpham.value = await SanPhamRepository.layDSSP();
    isLoading.value = false;
  }

  Future<void> XuLyYeuCauThemSP(Map<String, dynamic> data) async {
    await SanPhamRepository.themSP(data);
    fetchSanPham();
    
  }

  Future<void> XuLyYeuCauSuaSP(Map<String, dynamic> data) async {
    await SanPhamRepository.suaSP(data);
    fetchSanPham();
  }

  Future<bool> XoaXuLyYeuCauXoaSP(String maSP) async {
    try {
      // Thực hiện xóa sản phẩm
      await SanPhamRepository.xoaSP(maSP);
      
      // Cập nhật danh sách sản phẩm
      fetchSanPham();
      
      // Hiển thị thông báo thành công
      HienThiTBThanhCong(
        message: 'Xóa sản phẩm thành công',
        backgroundColor: Colors.green,
      );
      
      return true;
    } catch (e) {
      // Xử lý lỗi nếu có
      Get.snackbar(
        'Lỗi',
        'Đã xảy ra lỗi khi xóa sản phẩm: ${e.toString()}',
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
  
  // Thêm phương thức HienThiTBThanhCong nếu chưa có
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

  // Key truyền vào là mã sản phẩm (MASP)
  Future<Map<String, dynamic>?> getSanPhamByID(String maSP) async {
    return await DBHelper.getInstanceByID('SANPHAM', 'MASP', maSP);
  }
  Future<void> XuLyYeuCauTimKiem(String tuKhoa) async {
    isLoading.value = true;
    
    if (tuKhoa.isEmpty) {
      // Nếu từ khóa trống, hiển thị tất cả sản phẩm
      sanpham.value = await SanPhamRepository.layDSSP();
    } else {
      // Tìm kiếm sản phẩm dựa trên từ khóa
      final dsSanPham = await SanPhamRepository.layDSSP();
      final tuKhoaLowerCase = tuKhoa.toLowerCase();
      
      sanpham.value = dsSanPham.where((sp) {
        final tenSP = (sp['TENSP'] ?? '').toString().toLowerCase();
        return tenSP.contains(tuKhoaLowerCase);
      }).toList();
    }
    
    isLoading.value = false;
    
    // Hiển thị thông báo kết quả tìm kiếm
    if (sanpham.isEmpty) {
      HienThiTBTimKiem(
        message: 'Không tìm thấy sản phẩm phù hợp',
        backgroundColor: Colors.orange,
      );
    } else if (tuKhoa.isNotEmpty) {
      HienThiTBTimKiem(
        message: 'Đã tìm thấy ${sanpham.length} sản phẩm phù hợp',
        backgroundColor: Colors.blue,
      );
    }
  }
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