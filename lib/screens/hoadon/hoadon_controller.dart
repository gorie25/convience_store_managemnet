import 'package:get/get.dart';
import '../../db/db_helper.dart';

class HoaDonController extends GetxController {
  var hoadon = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHoaDon();
  }

  void fetchHoaDon() async {
    isLoading.value = true;
    hoadon.value = (await DBHelper.getAllHoaDon()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> addHoaDon(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('HOADON', 'HD', data);
    fetchHoaDon();
  }

  Future<void> updateHoaDon(Map<String, dynamic> data, String id) async {
    await DBHelper.updateInstance('HOADON', 'HD', id, data);
    fetchHoaDon();
  }

  Future<void> deleteHoaDon(String id) async {
    await DBHelper.deleteInstance('HOADON', 'HD', id);
    fetchHoaDon();
  }

  Future<Map<String, dynamic>?> getHoaDonByID(String id) async {
    return await DBHelper.getInstanceByID('HOADON', 'HD', id);
  }
}
