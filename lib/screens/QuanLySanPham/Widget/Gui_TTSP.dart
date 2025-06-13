import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../QLSQP_Controller.dart';

class GUI_TTSP extends StatefulWidget {
  final bool isThemSP;
  final String? maSP; // Mã sản phẩm khi chỉnh sửa

  const GUI_TTSP({super.key, this.isThemSP = true, this.maSP});

  @override
  State<GUI_TTSP> createState() => _GUI_TTSPState();
}

class _GUI_TTSPState extends State<GUI_TTSP> {
  final TextEditingController maSPController = TextEditingController();
  final TextEditingController tenSPController = TextEditingController();
  final TextEditingController donViController = TextEditingController();
  final TextEditingController giaController = TextEditingController();
  final TextEditingController soLuongController = TextEditingController();
  final QLSPController controller = Get.find<QLSPController>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    if (widget.isThemSP) {
      // Nếu là thêm sản phẩm, tạo mã SP mới
      LayMaSP();
    } else if (widget.maSP != null) {
      // Nếu là sửa sản phẩm
      final sanPham = await controller.getSanPhamByID(widget.maSP!);
      if (sanPham != null) {
        maSPController.text = sanPham['MASP'] ?? '';
        tenSPController.text = sanPham['TENSP'] ?? '';
        donViController.text = sanPham['DONVI'] ?? '';
        giaController.text = (sanPham['GIA'] ?? 0).toString();
        soLuongController.text = (sanPham['SOLUONG'] ?? 0).toString();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void LayMaSP() {
    String maSPMoi = controller.layMaSPMoi();
    maSPController.text = maSPMoi;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF0F8FA),
        child: isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        widget.isThemSP ? 'THÊM SẢN PHẨM' : 'SỬA SẢN PHẨM',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Mã sản phẩm'),
                    controller: maSPController,
                    enabled: false,
                  ),
                  TextField(
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
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final data = {
                            'MASP': maSPController.text,
                            'TENSP': tenSPController.text.trim(),
                            'DONVI': donViController.text.trim(),
                            'GIA': double.tryParse(giaController.text.trim()) ?? 0.0,
                            'SOLUONG': int.tryParse(soLuongController.text.trim()) ?? 0,
                          };

                          if (await xacNhanTTSP(context)) {
                            if (widget.isThemSP) {
                              await ThemSP(data);
                            } else {
                              await SuaSP(data);
                            }
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: Text(widget.isThemSP ? 'Thêm sản phẩm' : 'Cập nhật'),
                      ),
                      ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Hủy'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<bool> xacNhanTTSP(BuildContext context) async {
    if (tenSPController.text.trim().isEmpty ||
        donViController.text.trim().isEmpty ||
        giaController.text.trim().isEmpty ||
        soLuongController.text.trim().isEmpty) {
      hienThiTBLoi();
      return false;
    }
    return true;
  }
  
  Future<void> ThemSP(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauThemSP(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm sản phẩm: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }
  
  Future<void> SuaSP(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauSuaSP(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật sản phẩm: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Vui lòng nhập đầy đủ thông tin sản phẩm!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}