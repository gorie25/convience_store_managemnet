import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/hoadon/GUI_TTHD.dart';
import 'package:is201_prj_store_management/screens/hoadon/QLHDController.dart';

class GuiQLHD extends StatefulWidget {
  const GuiQLHD({super.key});

  @override
  State<GuiQLHD> createState() => _GuiQLHDState();
}

class _GuiQLHDState extends State<GuiQLHD> {
  final QLHDController controller = Get.put(QLHDController());
  int selectedIndex = -1;
  String? idSelected;
  final debounce = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller.fetchHoaDon();
  }

  @override
  Widget build(BuildContext context) {
    return HienThiDSHD();
  }

  void XuLyYeuCauThemHD() {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const GUI_TTHD(),
    );
  }

  void XuLyYeuCauXemChiTietHD(String maHD) {
    // TODO: Tạo màn hình xem chi tiết hóa đơn
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Chi tiết hóa đơn $maHD'),
        content: Text('Thông tin chi tiết hóa đơn sẽ hiển thị ở đây'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget HienThiDSHD() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý hóa đơn'),
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
                      hintText: 'Nhập thông tin hóa đơn tìm kiếm',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      debounce.run(() {
                        controller.XuLyYeuCauTimKiem(value);
                      });
                    },
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
                  onPressed: () {
                    XuLyYeuCauThemHD();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green, size: 32),
                  tooltip: 'Xem chi tiết',
                  onPressed: () {
                    if (idSelected != null) {
                      XuLyYeuCauXemChiTietHD(idSelected!);
                    }
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
              final hoaDonList = controller.hoadon;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Mã HĐ')),
                    DataColumn(label: Text('Mã NV')),
                    DataColumn(label: Text('Ngày lập')),
                    DataColumn(label: Text('Mã KH')),
                    DataColumn(label: Text('Tổng tiền')),
                  ],
                  rows: List.generate(hoaDonList.length, (index) {
                    final hd = hoaDonList[index];
                    return DataRow(
                      selected: selectedIndex == index,
                      onSelectChanged: (selected) {
                        setState(() {
                          selectedIndex = selected == true ? index : -1;
                          idSelected = selected == true ? hd['MAHD'] : null;
                        });
                      },
                      cells: [
                        DataCell(Text(hd['MAHD'] ?? '')),
                        DataCell(Text(hd['MANV'] ?? '')),
                        DataCell(Text(hd['NGAYLAP'] ?? '')),
                        DataCell(Text(hd['MAKH'] ?? '')),
                        DataCell(Text('${hd['TONGTIEN'] ?? 0} VND')),
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

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}