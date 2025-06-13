import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../QLKH_Controller.dart';

class GUI_TTKH extends StatefulWidget {
  final bool isThemKH;
  final String? maKH; // Mã khách hàng khi chỉnh sửa

  const GUI_TTKH({super.key, this.isThemKH = true, this.maKH});

  @override
  State<GUI_TTKH> createState() => _GUI_TTKHState();
}

class _GUI_TTKHState extends State<GUI_TTKH> {
  final TextEditingController maKHController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final KhachHangController controller = Get.find<KhachHangController>();
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

    if (widget.isThemKH) {
      // Nếu là thêm khách hàng, tạo mã KH mới
      LayMaKH();
    } else if (widget.maKH != null) {
      // Nếu là sửa khách hàng
      final khachHang = await controller.getKhachHangByID(widget.maKH!);
      if (khachHang != null) {
        maKHController.text = khachHang['MAKH'] ?? '';
        nameController.text = khachHang['TENKH'] ?? '';
        genderController.text = khachHang['GIOITINH'] ?? '';
        dobController.text = khachHang['NGAYSINH'] ?? '';
        addressController.text = khachHang['DIACHI'] ?? '';
        phoneController.text = khachHang['SDT'] ?? '';
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void LayMaKH() {
    String maKHMoi = controller.layMaKHMoi();
    maKHController.text = maKHMoi;
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
                        widget.isThemKH ? 'THÊM KHÁCH HÀNG' : 'SỬA KHÁCH HÀNG',
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
                    decoration: const InputDecoration(labelText: 'Mã khách hàng'),
                    controller: maKHController,
                    enabled: false,
                  ),
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
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Địa chỉ'),
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
                          final data = {
                            'MAKH': maKHController.text,
                            'TENKH': nameController.text.trim(),
                            'GIOITINH': genderController.text.trim(),
                            'NGAYSINH': dobController.text.trim(),
                            'DIACHI': addressController.text.trim(),
                            'SDT': phoneController.text.trim(),
                          };

                          if (await xacNhanTTKH(context)) {
                            if (widget.isThemKH) {
                              await ThemKH(data);
                            } else {
                              await SuaKH(data);
                            }
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: Text(widget.isThemKH ? 'Thêm khách hàng' : 'Cập nhật'),
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

  Future<bool> xacNhanTTKH(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty ||
        dobController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      hienThiTBLoi();
      return false;
    }
    return true;
  }
  
  Future<void> ThemKH(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauThemKH(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm khách hàng: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }
  
  Future<void> SuaKH(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauSuaKH(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật khách hàng: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Vui lòng nhập đầy đủ thông tin khách hàng!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}