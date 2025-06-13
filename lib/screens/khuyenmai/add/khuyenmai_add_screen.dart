import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../khuyenmai_controller.dart';
import 'package:is201_prj_store_management/core/utils.dart';

class KhuyenMaiAddScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  KhuyenMaiAddScreen({super.key});

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
                child: Text('THÊM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên khuyến mãi'),
            ),
            TextField(
              controller: productController,
              decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
            ),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Chiết khấu'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: startDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Ngày bắt đầu',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePickerVN(context);
                if (date != null) {
                  startDateController.text = date;
                }
              },
            ),
            TextField(
              controller: endDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Ngày kết thúc',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final date = await showDatePickerVN(context);
                if (date != null) {
                  endDateController.text = date;
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [                ElevatedButton(
                  onPressed: () async {
                    final controller = Get.find<KhuyenMaiController>();
                    final data = {
                      'TENKM': nameController.text,
                      'MASP': productController.text,
                      'PHANTRAM': double.tryParse(discountController.text) ?? 0.0,
                      'NGAYBATDAU': startDateController.text,
                      'NGAYKETTHUC': endDateController.text,
                    };
                    await controller.addKhuyenMai(data);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm khuyến mãi'),
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
