import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/QuanLySanPham/QLSQP_Controller.dart';
import 'package:is201_prj_store_management/screens/QuanLySanPham/Widget/Gui_TTSP.dart';


class GuiQLSP extends StatefulWidget {
  const GuiQLSP({super.key});

  @override
  State<GuiQLSP> createState() => _GuiQLSPState();
}

class _GuiQLSPState extends State<GuiQLSP> {
  final QLSPController controller = Get.put(QLSPController());
  int selectedIndex = -1;
  String? idSelected;

  @override
  void initState() {
    super.initState();
    controller.fetchSanPham();
  }

  @override
  Widget build(BuildContext context) {
    return HienThiDSSP();
  }
  void XuLyYeuCauSuaSP(String maSP) {
    showDialog(
      context: context,
      builder: (_) => GUI_TTSP(
        isThemSP: false,
        maSP: maSP,
      ),
    );
  }
  void XuLyYeuCauThemSP(
  ) {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => GUI_TTSP(),
    );
  }

  Widget HienThiDSSP() {
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
                    XuLyYeuCauThemSP();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.cyan, size: 32),
                  tooltip: 'Sửa',
                  onPressed: () async {
                    if (idSelected != null) {
                      XuLyYeuCauSuaSP(idSelected!);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  tooltip: 'Xóa',
                  onPressed: () {
                    if (idSelected != null) {
                      controller.XuLyYeuCauSuaSP({'MASP': idSelected});
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