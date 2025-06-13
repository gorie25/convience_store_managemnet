import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/db/db_helper.dart';

class DangNhapController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxString role = ''.obs;
  Future<bool> XuLyYeuCauDangNhap() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final nhanViens = await DBHelper.getAllNhanVien();
    final user = nhanViens.firstWhereOrNull(
      (nv) => nv['MANV'] == username || nv['TENNV'] == username,
    );
    if (user == null) return false;
    if (user['PASSWORD'] == password) {
      role.value = user['VAITRO'] ?? 'NhanVien';
      return true;
    }
    return false;
  }
}
