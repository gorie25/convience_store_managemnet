import 'package:flutter/material.dart';

class AddImportGoodsDialog extends StatefulWidget {
  final void Function(String maPN, String ngayNhap, String nhaCungCap, String tongTien) onAdd;
  const AddImportGoodsDialog({super.key, required this.onAdd});

  @override
  State<AddImportGoodsDialog> createState() => _AddImportGoodsDialogState();
}

class _AddImportGoodsDialogState extends State<AddImportGoodsDialog> {
  final _maPNController = TextEditingController();
  final _ngayNhapController = TextEditingController();
  final _nhaCungCapController = TextEditingController();
  final _tongTienController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                child: Text('THÊM PHIẾU NHẬP HÀNG', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maPNController,
              decoration: const InputDecoration(labelText: 'Mã phiếu nhập'),
            ),
            TextField(
              controller: _ngayNhapController,
              decoration: const InputDecoration(labelText: 'Ngày nhập'),
            ),
            TextField(
              controller: _nhaCungCapController,
              decoration: const InputDecoration(labelText: 'Nhà cung cấp'),
            ),
            TextField(
              controller: _tongTienController,
              decoration: const InputDecoration(labelText: 'Tổng tiền'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onAdd(
                      _maPNController.text.trim(),
                      _ngayNhapController.text.trim(),
                      _nhaCungCapController.text.trim(),
                      _tongTienController.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm phiếu nhập'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
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
