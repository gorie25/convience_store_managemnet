import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/core/utils.dart';
import '../khuyenmai_controller.dart';

class KhuyenMaiEditScreen extends StatefulWidget {
  final String idKhuyenMai;
  const KhuyenMaiEditScreen({super.key, required this.idKhuyenMai});

  @override
  State<KhuyenMaiEditScreen> createState() => _KhuyenMaiEditScreenState();
}

class _KhuyenMaiEditScreenState extends State<KhuyenMaiEditScreen> {
  final nameController = TextEditingController();
  final productController = TextEditingController();
  final discountController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  late final KhuyenMaiController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<KhuyenMaiController>();
    _loadKhuyenMai();
  }
  Future<void> _loadKhuyenMai() async {
    final data = await controller.getKhuyenMaiByID(widget.idKhuyenMai);
    if (data != null) {
      nameController.text = data['TENKM'] ?? '';
      productController.text = data['MASP'] ?? '';
      discountController.text = data['PHANTRAM']?.toString() ?? '';
      startDateController.text = data['NGAYBATDAU'] ?? '';
      endDateController.text = data['NGAYKETTHUC'] ?? '';
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
                child: Text('SỬA', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                  setState(() {
                    startDateController.text = date;
                  });
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
                  setState(() {
                    endDateController.text = date;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [                ElevatedButton(
                  onPressed: () async {
                    final data = {
                      'MAKM': widget.idKhuyenMai,
                      'TENKM': nameController.text,
                      'MASP': productController.text,
                      'PHANTRAM': double.tryParse(discountController.text) ?? 0.0,
                      'NGAYBATDAU': startDateController.text,
                      'NGAYKETTHUC': endDateController.text,
                    };
                    await controller.updateKhuyenMai(data, widget.idKhuyenMai);
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
