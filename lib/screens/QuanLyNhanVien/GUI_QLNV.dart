import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/db/db_helper.dart';
import 'package:is201_prj_store_management/screens/QuanLyNhanVien/GUI_TTNV.dart';
import 'package:is201_prj_store_management/screens/QuanLyNhanVien/Controller_QLNV.dart';

class GuiQLNV extends StatefulWidget {
  const GuiQLNV({super.key});

  @override
  State<GuiQLNV> createState() => _GuiQLNVState();
}

class _GuiQLNVState extends State<GuiQLNV> {
  final QLNVController controller = Get.put(QLNVController());
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    //controller.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return HienThiDSNV();
  }

  Widget HienThiDSNV() {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý nhân viên')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập thông tin nhân viên tìm kiếm',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 36),
                  tooltip: 'Thêm',
                  onPressed: () {
                    showDialog(context: context, builder: (_) => GuiTTNV());
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.cyan, size: 32),
                  tooltip: 'Sửa',
                  onPressed: () async {
                    if (selectedIndex < 0 || selectedIndex >= controller.nhanvien.length) return;
                    final nv = controller.nhanvien[selectedIndex];
                    showDialog(context: context, builder: (_) => GuiTTNV(isThemNV: false, maNV: nv['MANV']));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  tooltip: 'Xóa',
                  onPressed: () {
                    if (selectedIndex < 0 || selectedIndex >= controller.nhanvien.length) return;
                    final nv = controller.nhanvien[selectedIndex];
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: Text('Bạn có chắc chắn muốn xóa nhân viên ${nv['TENNV']} (${nv['MANV']})?'),
                            actions: [
                              // Nút Hủy
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Đóng hộp thoại
                                },
                                child: const Text('Hủy'),
                              ),
                              // Nút Xác nhận
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                onPressed: () async {
                                  // Đóng hộp thoại
                                  Navigator.pop(context);
                                  XuLiYeuCauXoaNV(nv['MANV'] ?? '');                                  
                                  // Reset lựa chọn
                                  setState(() {
                                    selectedIndex = -1;
                                  });
                                },
                                child: const Text('Xác nhận'),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Mã NV')),
                    DataColumn(label: Text('Tên NV')),
                    DataColumn(label: Text('Giới tính')),
                    DataColumn(label: Text('Ngày sinh')),
                    DataColumn(label: Text('Địa chỉ')),
                    DataColumn(label: Text('SĐT')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Lương')),
                    DataColumn(label: Text('Vai trò')),
                  ],
                  rows: List.generate(controller.nhanvien.length, (index) {
                    final nv = controller.nhanvien[index];
                    return DataRow(
                      selected: selectedIndex == index,
                      onSelectChanged: (selected) {
                        setState(() {
                          selectedIndex = selected == true ? index : -1;
                        });
                      },
                      cells: [
                        DataCell(Text(nv['MANV'] ?? '')),
                        DataCell(Text(nv['TENNV'] ?? '')),
                        DataCell(Text(nv['GIOITINH'] ?? '')),
                        DataCell(Text(nv['NGAYSINH'] ?? '')),
                        DataCell(Text(nv['DIACHI'] ?? '')),
                        DataCell(Text(nv['SDT'] ?? '')),
                        DataCell(Text(nv['EMAIL'] ?? '')),
                        DataCell(Text('${nv['LUONG'] ?? ''}')),
                        DataCell(Text(nv['VAITRO'] ?? '')),
                      ],
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  void XuLiYeuCauXoaNV (String maNV) async {
    await controller.XuLyYeuCauXoaNV(maNV);
    setState(() {
      selectedIndex = -1; // Reset lựa chọn sau khi xóa
    });
  }
}
