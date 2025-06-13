import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/sanpham/sanpham_controller.dart';
import 'package:is201_prj_store_management/screens/sanpham/add/sanpham_add_screen.dart';
import 'package:is201_prj_store_management/screens/sanpham/edit/sanpham_edit_screen.dart';
import 'package:is201_prj_store_management/screens/sanpham/delete/sanpham_delete_screen.dart';

class SanPhamScreen extends StatefulWidget {
  const SanPhamScreen({super.key});

  @override
  State<SanPhamScreen> createState() => _SanPhamScreenState();
}

class _SanPhamScreenState extends State<SanPhamScreen> {
  final SanPhamController controller = Get.put(SanPhamController());
  int selectedIndex = -1;
  String? idSelected;

  @override
  void initState() {
    super.initState();
    controller.fetchSanPham();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
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
                      hintText: 'Nhập thông tin sản phẩm tìm kiếm',
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
                      builder: (_) => SanPhamAddScreen(),
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
                        builder: (_) => SanPhamEditScreen(idSanPham: idSelected!),
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
                        builder: (_) => SanPhamDeleteScreen(idSanPham: idSelected!),
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
              final sanphamList = controller.sanpham;
              return DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Text('Mã SP')),
                  DataColumn(label: Text('Tên SP')),
                  DataColumn(label: Text('Đơn vị')),
                  DataColumn(label: Text('Giá')),
                  DataColumn(label: Text('Số lượng')),
                ],
                rows: List.generate(sanphamList.length, (index) {
                  final sp = sanphamList[index];
                  return DataRow(
                    selected: selectedIndex == index,
                    onSelectChanged: (selected) {
                      setState(() {
                        selectedIndex = selected == true ? index : -1;
                        idSelected = selected == true ? sp['MASP'] : null;
                      });
                    },
                    cells: [
                      DataCell(Align(alignment: Alignment.centerLeft, child: Text(sp['MASP'] ?? ''))),
                      DataCell(Align(alignment: Alignment.centerLeft, child: Text(sp['TENSP'] ?? ''))),
                      DataCell(Align(alignment: Alignment.centerLeft, child: Text(sp['DONVI'] ?? ''))),
                      DataCell(Align(alignment: Alignment.centerLeft, child: Text('${sp['GIA'] ?? ''}'))),
                      DataCell(Align(alignment: Alignment.centerLeft, child: Text('${sp['SOLUONG'] ?? ''}'))),
                    ],
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }
}
