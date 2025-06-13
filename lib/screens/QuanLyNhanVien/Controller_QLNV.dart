import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/repository/NhanVienRepository.dart';
import '../../db/db_helper.dart';

class QLNVController extends GetxController {
  var nhanvien = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNhanVien();
  }
  String layMaNVMoi() {
    final maList =
        nhanvien
            .map((nv) => nv['MANV']?.toString() ?? '')
            .where((ma) => ma.startsWith('NV'))
            .toList();
    int maxNum = 0;
    for (var ma in maList) {
      final numStr = ma.replaceAll('NV', '');
      final num = int.tryParse(numStr) ?? 0;
      if (num > maxNum) maxNum = num;
    }
    final newNum = maxNum + 1;
    return 'NV${newNum.toString().padLeft(3, '0')}';
  }
  void fetchNhanVien() async {
    isLoading.value = true;
    nhanvien.value = (await DBHelper.getAllNhanVien()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> ThemNV(Map<String, dynamic> data) async {
    await NhanVienRepository.themNV(data);
    fetchNhanVien();
  }

  Future<void> SuaNV(Map<String, dynamic> data) async {
    await NhanVienRepository.suaNV(data);
    fetchNhanVien();
  }

  Future<void> XuLyYeuCauXoaNV(String id) async {
    await NhanVienRepository.xoaNV(id);
    HienThiTBThanhCong(
      message: 'Xóa nhân viên thành công',
      backgroundColor: Colors.red,
    );
    fetchNhanVien();
  }
   //Key truyền vào là mã nhân viên (MANV)
  Future<Map<String, dynamic>?> getNhanVienByID(String id) async {
    return await DBHelper.getInstanceByID('NHANVIEN', 'MANV', id);
  }
 void HienThiTBThanhCong({
    String title = 'Thông báo',
    required String message,
    Color backgroundColor = Colors.green,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.green),
      borderRadius: 10,
    );
  }
}

