import 'package:get/get.dart';
import '../../db/db_helper.dart';

class KhachHangController extends GetxController {
  var khachhang = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhachHang();
  }

  void fetchKhachHang() async {
    isLoading.value = true;
    khachhang.value = (await DBHelper.getAllKhachHang()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> addKhachHang(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('KHACHHANG', 'MAKH', data);
    fetchKhachHang();
  }

  Future<void> updateKhachHang(Map<String, dynamic> data, String id) async {
    await DBHelper.updateInstance('KHACHHANG', 'MAKH', id, data);
    fetchKhachHang();
  }

  Future<void> deleteKhachHang(String id) async {
    await DBHelper.deleteInstance('KHACHHANG', 'MAKH', id);
    fetchKhachHang();
  }

  Future<Map<String, dynamic>?> getKhachHangByID(String id) async {
    return await DBHelper.getInstanceByID('KHACHHANG', 'MAKH', id);
  }
}
