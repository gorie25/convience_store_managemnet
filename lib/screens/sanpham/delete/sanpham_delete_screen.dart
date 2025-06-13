import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../sanpham_controller.dart';

class SanPhamDeleteScreen extends StatelessWidget {
  final String idSanPham;

  const SanPhamDeleteScreen({super.key, required this.idSanPham});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SanPhamController>();
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF0F8FA),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Center(
                child: Text('XÓA SẢN PHẨM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Bạn có chắc muốn xóa sản phẩm này?', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller.deleteSanPham(idSanPham);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Xóa'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
