import 'package:get/get.dart';
import '../../db/db_helper.dart';

class CaLVController extends GetxController {
  var calv = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCaLVs();
  }

  void fetchCaLVs() async {
    isLoading.value = true;
    calv.value = (await DBHelper.getAllCaLV()).cast<Map<String, dynamic>>();
    isLoading.value = false;
  }

  Future<void> addCaLV(Map<String, dynamic> data) async {
    await DBHelper.insertInstance('CHAMCONG', 'CA', data);
    fetchCaLVs();
  }

  Future<void> updateCaLV(Map<String, dynamic> data, String id) async {
    await DBHelper.updateInstance('CHAMCONG', 'CA', id, data);
    fetchCaLVs();
  }
}
