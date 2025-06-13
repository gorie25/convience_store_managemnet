import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/db/db_helper.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhuyenMai/QLKMController.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhuyenMai/GUI_TTKM.dart';

class KhuyenMaiScreen extends StatefulWidget {
  const KhuyenMaiScreen({super.key});

  @override
  _KhuyenMaiScreenState createState() => _KhuyenMaiScreenState();
}

class _KhuyenMaiScreenState extends State<KhuyenMaiScreen> {
  final controller = Get.put(QLKMController());
  String? idSelected;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý khuyến mãi'), centerTitle: true),
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
                      hintText: 'Nhập thông tin khuyến mãi tìm kiếm',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    // TODO: Thêm logic tìm kiếm
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 36),
                  tooltip: 'Thêm',
                  onPressed: () async {
                    await showDialog<Map<String, dynamic>>(context: context, builder: (_) => const GUI_TTKM(isThemKM: true));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.cyan, size: 32),
                  tooltip: 'Sửa',
                  onPressed: () async {
                    if (idSelected != null) {
                      await showDialog(context: context, builder: (_) => GUI_TTKM(isThemKM: false, maKM: idSelected));
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
                            (context) => AlertDialog(
                              title: const Text('Xác nhận xóa'),
                              content: const Text('Bạn có chắc chắn muốn xóa khuyến mãi này không?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await controller.XuLyYeuCauXoaKM(idSelected!);
                                    setState(() {
                                      selectedIndex = -1;
                                      idSelected = null;
                                    });
                                  },
                                  child: const Text('Xác nhận'),
                                ),
                              ],
                            ),
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
              final khuyenmaiList = controller.khuyenmai;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columnSpacing: MediaQuery.of(context).size.width / 15,
                  columns: const [
                    DataColumn(label: Text('Mã KM')),
                    DataColumn(label: Text('Tên KM')),
                    DataColumn(label: Text('Phần trăm')),
                    DataColumn(label: Text('Ngày bắt đầu')),
                    DataColumn(label: Text('Ngày kết thúc')),
                  ],
                  rows: List.generate(khuyenmaiList.length, (index) {
                    final km = khuyenmaiList[index];
                    return DataRow(
                      selected: selectedIndex == index,
                      onSelectChanged: (selected) {
                        setState(() {
                          selectedIndex = selected == true ? index : -1;
                          idSelected = selected == true ? km['MAKM'] : null;
                        });
                      },
                      cells: [
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text(km['MAKM'] ?? ''))),
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text(km['TENKM'] ?? ''))),
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text('${km['PHANTRAM'] ?? ''}%'))),
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text(km['NGAYBATDAU'] ?? ''))),
                        DataCell(Align(alignment: Alignment.centerLeft, child: Text(km['NGAYKETTHUC'] ?? ''))),
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
