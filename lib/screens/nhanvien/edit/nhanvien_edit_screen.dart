import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:collection';
import '../Controller_QLNV.dart';

class NhanVienEditScreen extends StatefulWidget {
  final String idNhanVien;
  const NhanVienEditScreen({super.key, required this.idNhanVien});

  @override
  State<NhanVienEditScreen> createState() => _NhanVienEditScreenState();
}

class _NhanVienEditScreenState extends State<NhanVienEditScreen> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final salaryController = TextEditingController();
  final roleController = TextEditingController();
  late final QLNVController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<QLNVController>();
    _loadNhanVien();
  }

  Future<void> _loadNhanVien() async {
    final data = await controller.getNhanVienByID(widget.idNhanVien);
    if (data != null) {
      nameController.text = data['TENNV'] ?? '';
      genderController.text = data['GIOITINH'] ?? '';
      dobController.text = data['NGAYSINH'] ?? '';
      addressController.text = data['DIACHI'] ?? '';
      phoneController.text = data['SDT'] ?? '';
      emailController.text = data['EMAIL'] ?? '';
      salaryController.text = data['LUONG']?.toString() ?? '';
      roleController.text = data['VAITRO'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
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
                child: Text('SỬA NHÂN VIÊN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
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
            TextField(
              controller: roleController,
              decoration: const InputDecoration(labelText: 'Vai trò'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'MANV': widget.idNhanVien,
                      'TENNV': nameController.text.trim(),
                      'GIOITINH': genderController.text.trim(),
                      'NGAYSINH': dobController.text.trim(),
                      'DIACHI': addressController.text.trim(),
                      'SDT': phoneController.text.trim(),
                      'EMAIL': emailController.text.trim(),
                      'LUONG': int.tryParse(salaryController.text.trim()) ?? 0,
                      'VAITRO': roleController.text.trim(),
                    };
                    await controller.updateNhanVien(data, widget.idNhanVien);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Lưu thay đổi'),
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
