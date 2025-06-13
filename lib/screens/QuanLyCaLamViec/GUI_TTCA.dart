// filepath: /home/tientruong/IS201_ Code Web-20250613T014042Z-1-001/IS201_ Code Web/is201_prj_store_management/lib/screens/ca_lam_viec/GUI_TTCA.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'QLCAController.dart';

class GUI_TTCA extends StatefulWidget {
  const GUI_TTCA({super.key});

  @override
  State<GUI_TTCA> createState() => _GUI_TTCAState();
}

class _GUI_TTCAState extends State<GUI_TTCA> {
  final TextEditingController maCAController = TextEditingController();
  final TextEditingController tenCAController = TextEditingController();
  final TextEditingController gioBDController = TextEditingController();
  final TextEditingController gioKTController = TextEditingController();
  final QLCAController controller = Get.find<QLCAController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    // Tạo mã CA mới
    LayMaCA();

    setState(() {
      isLoading = false;
    });
  }

  void LayMaCA() {
    String maCAMoi = controller.layMaCAMoi();
    maCAController.text = maCAMoi;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF0F8FA),
        child: isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Text(
                        'THÊM CA LÀM VIỆC',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Mã ca làm việc'),
                    controller: maCAController,
                    enabled: false,
                  ),
                  TextField(
                    controller: tenCAController,
                    decoration: const InputDecoration(labelText: 'Tên ca'),
                  ),
                  TextField(
                    controller: gioBDController,
                    decoration: const InputDecoration(
                      labelText: 'Giờ bắt đầu',
                      hintText: 'vd: 08:00',
                    ),
                  ),
                  TextField(
                    controller: gioKTController,
                    decoration: const InputDecoration(
                      labelText: 'Giờ kết thúc',
                      hintText: 'vd: 12:00',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await xacNhanTTCA(context)) {
                            await ThemCA({
                              'MACLV': maCAController.text,
                              'TENCA': tenCAController.text.trim(),
                              'GIOBD': gioBDController.text.trim(),
                              'GIOKT': gioKTController.text.trim(),
                            });
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Thêm ca làm việc'),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Hủy'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<bool> xacNhanTTCA(BuildContext context) async {
    if (tenCAController.text.trim().isEmpty ||
        gioBDController.text.trim().isEmpty ||
        gioKTController.text.trim().isEmpty) {
      hienThiTBLoi();
      return false;
    }
    return true;
  }
  
  Future<void> ThemCA(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauThemCA(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm ca làm việc: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Vui lòng nhập đầy đủ thông tin ca làm việc!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}