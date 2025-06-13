import 'package:get/get.dart';
import '../../db/db_helper.dart';

class KhuyenMaiController extends GetxController {
  var khuyenmai = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhuyenMai();
  }

  void fetchKhuyenMai() async {
    isLoading.value = true;
    khuyenmai.value = (await DBHelper.getAllKhuyenMai()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> addKhuyenMai(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('KHUYENMAI', 'MAKM', data);
    fetchKhuyenMai();
  }

  Future<void> updateKhuyenMai(Map<String, dynamic> data, String id) async {
    await DBHelper.updateInstance('KHUYENMAI', 'MAKM', id, data);
    fetchKhuyenMai();
  }

  Future<void> deleteKhuyenMai(String id) async {
    await DBHelper.deleteInstance('KHUYENMAI', 'MAKM', id);
    fetchKhuyenMai();
  }

  Future<Map<String, dynamic>?> getKhuyenMaiByID(String id) async {
    return await DBHelper.getInstanceByID('KHUYENMAI', 'MAKM', id);
  }
}
