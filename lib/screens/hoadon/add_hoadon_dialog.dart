import 'package:flutter/material.dart';

class AddHoaDonDialog extends StatefulWidget {
  final void Function(String maHD, String maNV, String ngayHD, String maKH, String tongTien) onAdd;
  const AddHoaDonDialog({super.key, required this.onAdd});

  @override
  State<AddHoaDonDialog> createState() => _AddHoaDonDialogState();
}

class _AddHoaDonDialogState extends State<AddHoaDonDialog> {
  final _maHDController = TextEditingController();
  final _maNVController = TextEditingController();
  final _ngayHDController = TextEditingController();
  final _maKHController = TextEditingController();
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
                child: Text('THÊM HÓA ĐƠN', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maHDController,
              decoration: const InputDecoration(labelText: 'Mã hóa đơn'),
            ),
            TextField(
              controller: _maNVController,
              decoration: const InputDecoration(labelText: 'Mã nhân viên'),
            ),
            TextField(
              controller: _ngayHDController,
              decoration: const InputDecoration(labelText: 'Ngày hóa đơn'),
            ),
            TextField(
              controller: _maKHController,
              decoration: const InputDecoration(labelText: 'Mã khách hàng'),
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
                      _maHDController.text.trim(),
                      _maNVController.text.trim(),
                      _ngayHDController.text.trim(),
                      _maKHController.text.trim(),
                      _tongTienController.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm hóa đơn'),
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
