import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/QuanLyDangNhap/DangNhapController.dart';

class GuiTrangDangNhap extends StatelessWidget {
  final DangNhapController controller = Get.put(DangNhapController());
  final RxBool showPassword = false.obs;

  GuiTrangDangNhap({super.key});

  Widget build(BuildContext context) {
    return HienThiTrangDangNhap(controller, showPassword);
  }

  Widget HienThiTrangDangNhap(
    DangNhapController controller,
    RxBool showPassword,
  ) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon2.png', width: 50, height: 50),
                  SizedBox(width: 16),
                  Text(
                    'ĐĂNG NHẬP HỆ THỐNG',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 32),
              TextField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  labelText: 'Tài khoản',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: !showPassword.value,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => showPassword.value = !showPassword.value,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (controller.usernameController.text.trim().isEmpty ||
                      controller.passwordController.text.trim().isEmpty) {
                    HienThiThongBaoLoi();
                  } else {
                    bool result = await controller.XuLyYeuCauDangNhap();
                    if (result) {
                      HienThiTBDangNhapThanhCong();
                      await Future.delayed(const Duration(seconds: 2));
                      ChuyenManHinh();
                    } else {
                      HienThiThongBaoLoi();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Đăng nhập',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget HienThiThongBaoLoi() {
    Get.snackbar(
      'Lỗi',
      'Tài khoản hoặc mật khẩu chưa đúng. Vui lòng nhập lại.',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
    return SizedBox.shrink();
  }

  Widget HienThiTBDangNhapThanhCong() {
    Get.snackbar(
      'Thông báo',
      'Đăng nhập thành công.',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
    return SizedBox.shrink();
  }

  void ChuyenManHinh() {
    final DangNhapController controller = Get.find<DangNhapController>();
    Get.offAllNamed('/home', arguments: {'role': controller.role.value});
  }
}
