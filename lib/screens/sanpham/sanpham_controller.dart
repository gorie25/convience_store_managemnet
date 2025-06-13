import 'package:get/get.dart';
import '../../db/db_helper.dart';

class SanPhamController extends GetxController {
  var sanpham = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSanPham();
  }

  void fetchSanPham() async {
    isLoading.value = true;
    sanpham.value = (await DBHelper.getAllSanPham()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> addSanPham(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('SANPHAM', 'MASP', data);
    fetchSanPham();
  }

  Future<void> updateSanPham(Map<String, dynamic> data, String id) async {
    await DBHelper.updateInstance('SANPHAM', 'MASP', id, data);
    fetchSanPham();
  }

  Future<void> deleteSanPham(String id) async {
    await DBHelper.deleteInstance('SANPHAM', 'MASP', id);
    fetchSanPham();
  }

  Future<Map<String, dynamic>?> getSanPhamByID(String id) async {
    return await DBHelper.getInstanceByID('SANPHAM', 'MASP', id);
  }
}
