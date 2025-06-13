import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/khachhang/add/khachhang_add_screen.dart';
import 'package:is201_prj_store_management/screens/khachhang/delete/khachhang_delete_screen.dart';
import 'package:is201_prj_store_management/screens/khachhang/edit/khachhang_edit_screen.dart';
import 'package:is201_prj_store_management/screens/khachhang/khachhang_controller.dart';

class KhachHangScreen extends StatefulWidget {
  const KhachHangScreen({super.key});

  @override
  _KhachHangScreenState createState() => _KhachHangScreenState();
}

class _KhachHangScreenState extends State<KhachHangScreen> {
  final controller = Get.put(KhachHangController());
  String? idSelected;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho UI demo
    if (controller.khachhang.isEmpty) {
      controller.khachhang.value = [
        {'MAKH': 'KH01', 'TENKH': 'Nguyễn Văn A', 'GIOITINH': 'Nam', 'NGAYSINH': '1990-01-01', 'SDT': '0901234567'},
        {'MAKH': 'KH02', 'TENKH': 'Trần Thị B', 'GIOITINH': 'Nữ', 'NGAYSINH': '1992-02-02', 'SDT': '0912345678'},
        {'MAKH': 'KH03', 'TENKH': 'Lê Văn C', 'GIOITINH': 'Nam', 'NGAYSINH': '1988-03-03', 'SDT': '0923456789'},
        {'MAKH': 'KH04', 'TENKH': 'Phạm Thị D', 'GIOITINH': 'Nữ', 'NGAYSINH': '1995-04-04', 'SDT': '0934567890'},
        {'MAKH': 'KH05', 'TENKH': 'Hoàng Văn E', 'GIOITINH': 'Nam', 'NGAYSINH': '1993-05-05', 'SDT': '0945678901'},
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý khách hàng'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nhập thông tin khách hàng tìm kiếm',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                    ),
                    // TODO: Thêm logic tìm kiếm
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.blue,
                    size: 36,
                  ),
                  tooltip: 'Thêm',
                  onPressed: () async {
                    await showDialog<Map<String, dynamic>>(
                      context: context,
                      builder: (_) => KhachHangAddScreen(),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.cyan, size: 32),
                  tooltip: 'Sửa',
                  onPressed: () async {
                    if (idSelected != null) {
                      await showDialog(
                        context: context,
                        builder:
                            (_) =>
                                KhachHangEditScreen(idKhachHang: idSelected!),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  tooltip: 'Xóa',
                  onPressed: () {
                    if (idSelected != null) {
                      showDialog(
                        context: context,
                        builder:
                            (_) =>
                                KhachHangDeleteScreen(idKhachHang: idSelected!),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              final khachhangList = controller.khachhang;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Mã KH')),
                    DataColumn(label: Text('Tên KH')),
                    DataColumn(label: Text('Giới tính')),
                    DataColumn(label: Text('Ngày sinh')),
                    DataColumn(label: Text('SĐT')),
                  ],
                  rows: List.generate(khachhangList.length, (index) {
                    final kh = khachhangList[index];
                    return DataRow(
                      selected: selectedIndex == index,
                      onSelectChanged: (selected) {
                        setState(() {
                          selectedIndex = selected == true ? index : -1;
                          idSelected = selected == true ? kh['MAKH'] : null;
                        });
                      },
                      cells: [
                        DataCell(Text(kh['MAKH'] ?? '')),
                        DataCell(Text(kh['TENKH'] ?? '')),
                        DataCell(Text(kh['GIOITINH'] ?? '')),
                        DataCell(Text(kh['NGAYSINH'] ?? '')),
                        DataCell(Text(kh['SDT'] ?? '')),
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
}
