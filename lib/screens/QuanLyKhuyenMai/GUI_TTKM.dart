import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'QLKMController.dart';
import 'package:is201_prj_store_management/core/utils.dart';

class GUI_TTKM extends StatefulWidget {
  final bool isThemKM;
  final String? maKM; // Mã khuyến mãi khi chỉnh sửa

  const GUI_TTKM({super.key, this.isThemKM = true, this.maKM});

  @override
  State<GUI_TTKM> createState() => _GUI_TTKMState();
}

class _GUI_TTKMState extends State<GUI_TTKM> {
  final TextEditingController maKMController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController productController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final QLKMController controller = Get.find<QLKMController>();
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

    if (widget.isThemKM) {
      // Nếu là thêm khuyến mãi, tạo mã KM mới
      LayMaKM();
    } else if (widget.maKM != null) {
      // Nếu là sửa khuyến mãi
      final khuyenMai = await controller.getKhuyenMaiByID(widget.maKM!);
      if (khuyenMai != null) {
        maKMController.text = khuyenMai['MAKM'] ?? '';
        nameController.text = khuyenMai['TENKM'] ?? '';
        productController.text = khuyenMai['MASP'] ?? '';
        discountController.text = (khuyenMai['PHANTRAM'] ?? 0).toString();
        startDateController.text = khuyenMai['NGAYBATDAU'] ?? '';
        endDateController.text = khuyenMai['NGAYKETTHUC'] ?? '';
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void LayMaKM() {
    String maKMMoi = controller.layMaKMMoi();
    maKMController.text = maKMMoi;
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
                        widget.isThemKM ? 'THÊM KHUYẾN MÃI' : 'SỬA KHUYẾN MÃI',
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
                    decoration: const InputDecoration(labelText: 'Mã khuyến mãi'),
                    controller: maKMController,
                    enabled: false,
                  ),
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
                    decoration: const InputDecoration(labelText: 'Chiết khấu (%)'),
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
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (await xacNhanTTKM(context)) {
                            final data = {
                              'MAKM': maKMController.text,
                              'TENKM': nameController.text.trim(),
                              'MASP': productController.text.trim(),
                              'PHANTRAM': double.tryParse(discountController.text.trim()) ?? 0.0,
                              'NGAYBATDAU': startDateController.text.trim(),
                              'NGAYKETTHUC': endDateController.text.trim(),
                            };

                            if (widget.isThemKM) {
                              await ThemKM(data);
                            } else {
                              await SuaKM(data);
                            }
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: Text(widget.isThemKM ? 'Thêm khuyến mãi' : 'Cập nhật'),
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

  Future<bool> xacNhanTTKM(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        productController.text.trim().isEmpty ||
        discountController.text.trim().isEmpty ||
        startDateController.text.trim().isEmpty ||
        endDateController.text.trim().isEmpty) {
      hienThiTBLoi();
      return false;
    }
    return true;
  }
  
  Future<void> ThemKM(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauThemKM(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể thêm khuyến mãi: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }
  
  Future<void> SuaKM(Map<String, dynamic> data) async {
    try {
      await controller.XuLyYeuCauSuaKM(data);
    } catch (e) {
      Get.snackbar(
        'Lỗi',
        'Không thể cập nhật khuyến mãi: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
      );
    }
  }

  void hienThiTBLoi() {
    Get.snackbar(
      'Lỗi',
      'Vui lòng nhập đầy đủ thông tin khuyến mãi!',
      backgroundColor: Colors.red.shade100,
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}