import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Controller_QLNV.dart';

class GuiTTNV extends StatefulWidget {
  final bool isThemNV;
  final String? maNV; // Mã nhân viên khi chỉnh sửa

  const GuiTTNV({super.key, this.isThemNV = true, this.maNV});

  @override
  State<GuiTTNV> createState() => _GuiTTNVState();
}

class _GuiTTNVState extends State<GuiTTNV> {
  final TextEditingController maNVController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final QLNVController controller = Get.find<QLNVController>();
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

    if (widget.isThemNV) {
       HienThiMaNV();
    } else if (widget.maNV != null) {
      // Nếu là sửa nhân viên
      final nhanVien = await controller.getNhanVienByID(widget.maNV!);
      if (nhanVien != null) {
        maNVController.text = nhanVien['MANV'] ?? '';
        nameController.text = nhanVien['TENNV'] ?? '';
        genderController.text = nhanVien['GIOITINH'] ?? '';
        dobController.text = nhanVien['NGAYSINH'] ?? '';
        addressController.text = nhanVien['DIACHI'] ?? '';
        phoneController.text = nhanVien['SDT'] ?? '';
        emailController.text = nhanVien['EMAIL'] ?? '';
        salaryController.text = (nhanVien['LUONG'] ?? 0).toString();
        roleController.text = nhanVien['VAITRO'] ?? '';
      }
    }

    setState(() {
      isLoading = false;
    });
  }
   void HienThiMaNV() {
    String maNVMoi = controller.layMaNVMoi();
    maNVController.text = maNVMoi;
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
                        widget.isThemNV ? 'THÊM NHÂN VIÊN' : 'SỬA NHÂN VIÊN',
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
                    decoration: const InputDecoration(labelText: 'Mã nhân viên'),
                    controller: maNVController,
                    enabled: false,
                  ),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên nhân viên'),
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
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: salaryController,
                    decoration: const InputDecoration(labelText: 'Lương'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    value: roleController.text.isNotEmpty ? roleController.text : null,
                    decoration: const InputDecoration(labelText: 'Vai trò'),
                    items: const [
                      DropdownMenuItem(value: 'NhanVien', child: Text('Nhân viên')),
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    ],
                    onChanged: (value) {
                      roleController.text = value ?? '';
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {

                              final data = {
      'MANV': maNVController.text,
      'TENNV': nameController.text.trim(),
      'GIOITINH': genderController.text.trim(),
      'NGAYSINH': dobController.text.trim(),
      'DIACHI': addressController.text.trim(),
      'SDT': phoneController.text.trim(),
      'EMAIL': emailController.text.trim(),
      'LUONG': int.tryParse(salaryController.text.trim()) ?? 0,
      'VAITRO': roleController.text.trim(),
    };

                          await xacNhanTTNV(context);
                          if(widget.isThemNV) {
                            ThemNV(data, controller);
                          } else {
                            SuaNV(data, controller);
                          }
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: Text(widget.isThemNV ? 'Thêm nhân viên' : 'Cập nhật'),
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

  Future<void> xacNhanTTNV(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        genderController.text.trim().isEmpty ||
        dobController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        salaryController.text.trim().isEmpty ||
        roleController.text.trim().isEmpty) {
      hienThiTBLoi();
      return;
    }
    }
  }
  void ThemNV(Map<String, dynamic> data, QLNVController controller) async {
      data['PASSWORD'] = '123456';
      await controller.ThemNV(data);
  }
  void SuaNV(Map<String, dynamic> data,QLNVController controller) async {
      await controller.SuaNV(data); 
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Có lỗi xảy ra vui lòng kiểm tra lại thông tin',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
