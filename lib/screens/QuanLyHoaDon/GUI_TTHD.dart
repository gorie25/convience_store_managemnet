// filepath: /home/tientruong/IS201_ Code Web-20250613T014042Z-1-001/IS201_ Code Web/is201_prj_store_management/lib/screens/hoadon/add/GUI_TTHD.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/hoadon/QLHDController.dart';
import 'package:is201_prj_store_management/core/utils.dart';

class GUI_TTHD extends StatefulWidget {
  const GUI_TTHD({super.key});

  @override
  State<GUI_TTHD> createState() => _GUI_TTHDState();
}

class _GUI_TTHDState extends State<GUI_TTHD> {
  final TextEditingController maHDController = TextEditingController();
  final TextEditingController maNVController = TextEditingController();
  final TextEditingController maKHController = TextEditingController();
  final TextEditingController ngayLapController = TextEditingController();
  final TextEditingController tongTienController = TextEditingController();
  final QLHDController controller = Get.find<QLHDController>();
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

    // Tạo mã HD mới
    LayMaHD();
    
    // Đặt ngày hôm nay làm ngày lập mặc định
    final now = DateTime.now();
    ngayLapController.text = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    
    // Mặc định tổng tiền là 0
    tongTienController.text = '0';

    setState(() {
      isLoading = false;
    });
  }

  void LayMaHD() {
    String maHDMoi = controller.layMaHDMoi();
    maHDController.text = maHDMoi;
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
                        'THÊM HÓA ĐƠN',
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
                    decoration: const InputDecoration(labelText: 'Mã hóa đơn'),
                    controller: maHDController,
                    enabled: false,
                  ),
                  TextField(
                    controller: maNVController,
                    decoration: const InputDecoration(labelText: 'Mã nhân viên'),
                  ),
                  TextField(
                    controller: maKHController,
                    decoration: const InputDecoration(labelText: 'Mã khách hàng'),
                  ),
                  TextField(
                    controller: ngayLapController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Ngày lập',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      final date = await showDatePickerVN(context);
                      if (date != null) {
                        ngayLapController.text = date;
                      }
                    },
                  ),
                  TextField(
                    controller: tongTienController,
                    decoration: const InputDecoration(labelText: 'Tổng tiền'),
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await xacNhanTTHD(context)) {
                            await ThemHD({
                              'MAHD': maHDController.text,
                              'MANV': maNVController.text.trim(),
                              'MAKH': maKHController.text.trim(),
                              'NGAYLAP': ngayLapController.text.trim(),
                              'TONGTIEN': double.tryParse(tongTienController.text.trim()) ?? 0.0,
                            });
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('Thêm hóa đơn'),
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

  Future<bool> xacNhanTTHD(BuildContext context) async {
    if (maNVController.text.trim().isEmpty ||
        maKHController.text.trim().isEmpty ||
        ngayLapController.text.trim().isEmpty) {
      hienThiTBLoi();
      return false;
    }
    return true;
  }
  
  Future<void> ThemHD(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauThemHD(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm hóa đơn: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Vui lòng nhập đầy đủ thông tin hóa đơn!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}