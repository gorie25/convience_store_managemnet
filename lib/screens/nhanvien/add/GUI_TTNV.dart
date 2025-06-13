import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller_QLNV.dart';

class GuiTTNV extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  GuiTTNV({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QLNVController>();
    final maNVMoi = controller.layMaNVMoi();
    final maNVController = TextEditingController(text: maNVMoi);

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
                child: Text(
                  'THÊM NHÂN VIÊN',
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
              decoration: InputDecoration(labelText: 'Mã nhân viên'),
              controller: maNVController,
              enabled: false,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên nhân viên'),
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
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: salaryController,
              decoration: const InputDecoration(labelText: 'Lương'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: roleController.text.isNotEmpty ? roleController.text : null,
              decoration: const InputDecoration(labelText: 'Vai trò'),
              items: const [
                DropdownMenuItem(value: 'NhanVien', child: Text('Nhân viên')),
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                roleController.text = value ?? '';
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                   
                    XacNhanTTNV(context);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm nhân viên'),
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
  Future<void> XacNhanTTNV(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty ||
        dobController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        salaryController.text.trim().isEmpty ||
        roleController.text.trim().isEmpty) {
      HienThiTBLoi();
    } else {
      final controller = Get.find<QLNVController>();
      final maNVMoi = controller.layMaNVMoi();
      final data = {
        'MANV': maNVMoi,
        'TENNV': nameController.text.trim(),
        'GIOITINH': genderController.text.trim(),
        'NGAYSINH': dobController.text.trim(),
        'DIACHI': addressController.text.trim(),
        'SDT': phoneController.text.trim(),
        'EMAIL': emailController.text.trim(),
        'LUONG': int.tryParse(salaryController.text.trim()) ?? 0,
        'VAITRO': roleController.text.trim(),
        'PASSWORD': '123456',
      };
      await controller.ThemNV(data);
    }
    // Nếu hợp lệ, có thể xử lý tiếp ở đây (chưa làm gì)
  }
}


void HienThiTBLoi() {
  Get.snackbar(
    'Lỗi',
    'Vui lòng nhập đầy đủ thông tin nhân viên!',
    backgroundColor: Colors.red.shade100,
    colorText: Colors.black,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 2),
  );
}
