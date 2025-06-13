import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../khachhang_controller.dart';

class KhachHangDeleteScreen extends StatelessWidget {
  final String idKhachHang;

  const KhachHangDeleteScreen({super.key, required this.idKhachHang});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KhachHangController>();
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
                child: Text('XÓA KHÁCH HÀNG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Bạn có chắc chắn muốn xóa khách hàng này?', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await controller.deleteKhachHang(idKhachHang);
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
