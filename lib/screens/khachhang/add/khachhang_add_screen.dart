import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../khachhang_controller.dart';

class KhachHangAddScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  KhachHangAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KhachHangController>();
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF0F8FA),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text('THÊM KHÁCH HÀNG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên khách hàng'),
            ),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(labelText: 'Giới tính'),
            ),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Ngày sinh'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'TENKH': nameController.text.trim(),
                      'GIOITINH': genderController.text.trim(),
                      'NGAYSINH': dobController.text.trim(),
                      'SDT': phoneController.text.trim(),
                    };
                    await controller.addKhachHang(data);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm khách hàng'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Hủy'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
