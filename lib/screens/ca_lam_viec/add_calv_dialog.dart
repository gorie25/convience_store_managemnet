import 'package:flutter/material.dart';

class AddCaLVDialog extends StatefulWidget {
  final void Function(String maCa, String tenCa, String gioBD, String gioKT) onAdd;
  const AddCaLVDialog({super.key, required this.onAdd});

  @override
  State<AddCaLVDialog> createState() => _AddCaLVDialogState();
}

class _AddCaLVDialogState extends State<AddCaLVDialog> {
  final _maCaController = TextEditingController();
  final _tenCaController = TextEditingController();
  final _gioBDController = TextEditingController();
  final _gioKTController = TextEditingController();

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
                child: Text('THÊM CA LÀM VIỆC', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _maCaController,
              decoration: const InputDecoration(labelText: 'Mã ca'),
            ),
            TextField(
              controller: _tenCaController,
              decoration: const InputDecoration(labelText: 'Tên ca'),
            ),
            TextField(
              controller: _gioBDController,
              decoration: const InputDecoration(labelText: 'Giờ bắt đầu'),
            ),
            TextField(
              controller: _gioKTController,
              decoration: const InputDecoration(labelText: 'Giờ kết thúc'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onAdd(
                      _maCaController.text.trim(),
                      _tenCaController.text.trim(),
                      _gioBDController.text.trim(),
                      _gioKTController.text.trim(),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Thêm ca'),
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
