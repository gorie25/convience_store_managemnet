import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/khachhang/khachhang_controller.dart';
import '../../../models/customer.dart';

class KhachHangEditScreen extends StatefulWidget {
  final String idKhachHang;
  const KhachHangEditScreen({super.key, required this.idKhachHang});

  @override
  State<KhachHangEditScreen> createState() => _KhachHangEditScreenState();
}

class _KhachHangEditScreenState extends State<KhachHangEditScreen> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  late final KhachHangController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<KhachHangController>();
    _loadKhachHang();
  }

  Future<void> _loadKhachHang() async {
    final data = await controller.getKhachHangByID(widget.idKhachHang);
    if (data != null) {
      final kh = KhachHang.fromMap(data);
      nameController.text = kh.tenKH;
      genderController.text = kh.gioiTinh;
      dobController.text = kh.ngaySinh;
      phoneController.text = kh.sdt;
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
                child: Text('SỬA KHÁCH HÀNG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                    final kh = KhachHang(
                      maKH: widget.idKhachHang,
                      tenKH: nameController.text.trim(),
                      gioiTinh: genderController.text.trim(),
                      ngaySinh: dobController.text.trim(),
                      sdt: phoneController.text.trim(),
                    );
                    await controller.updateKhachHang(kh.toMap(), widget.idKhachHang);
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
