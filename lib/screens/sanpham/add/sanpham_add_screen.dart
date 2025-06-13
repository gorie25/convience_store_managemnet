import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../sanpham_controller.dart';

class SanPhamAddScreen extends StatelessWidget {
  final TextEditingController tenSPController = TextEditingController();
  final TextEditingController donViController = TextEditingController();
  final TextEditingController giaController = TextEditingController();
  final TextEditingController soLuongController = TextEditingController();

  SanPhamAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400, // Thu nhỏ chiều rộng dialog
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
                child: Text('THÊM SẢN PHẨM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),            TextField(
              controller: tenSPController,
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
            ),
            TextField(
              controller: donViController,
              decoration: const InputDecoration(labelText: 'Đơn vị'),
            ),
            TextField(
              controller: giaController,
              decoration: const InputDecoration(labelText: 'Giá'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: soLuongController,
              decoration: const InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [                ElevatedButton(
                  onPressed: () async {
                    final controller = Get.find<SanPhamController>();
                    final data = {
                      'TENSP': tenSPController.text,
                      'DONVI': donViController.text,
                      'GIA': double.tryParse(giaController.text) ?? 0.0,
                      'SOLUONG': int.tryParse(soLuongController.text) ?? 0,
                    };
                    await controller.addSanPham(data);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm sản phẩm'),
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
