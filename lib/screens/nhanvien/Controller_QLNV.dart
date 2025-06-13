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

  Future<void> updateNhanVien(Map<String, dynamic> data, String id) async {
    await NhanVienRepository.suaNV(id, data);
    fetchNhanVien();
  }

  Future<void> deleteNhanVien(String id) async {
    await NhanVienRepository.xoaNV(id);
    fetchNhanVien();
  }
   //Key truyền vào là mã nhân viên (MANV)
  Future<Map<String, dynamic>?> getNhanVienByID(String id) async {
    return await DBHelper.getInstanceByID('NHANVIEN', 'MANV', id);
  }
}
