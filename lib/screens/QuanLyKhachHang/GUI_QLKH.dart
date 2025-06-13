import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhachHang/Widget/GUI_TTKH.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhachHang/QLKH_Controller.dart';

class GuiQLKH extends StatefulWidget {
  const GuiQLKH({super.key});

  @override
  State<GuiQLKH> createState() => _GuiQLKHState();
}

class _GuiQLKHState extends State<GuiQLKH> {
  final KhachHangController controller = Get.put(KhachHangController());
  int selectedIndex = -1;
  String? idSelected;
  final debounce = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller.fetchKhachHang();
  }

  @override
  Widget build(BuildContext context) {
    return HienThiDSKH();
  }

  void XuLyYeuCauSuaKH(String maKH) {
    showDialog(
      context: context,
      builder: (_) => GUI_TTKH(
        isThemKH: false,
        maKH: maKH,
      ),
    );
  }

  void XuLyYeuCauThemKH() {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => GUI_TTKH(),
    );
  }

  void XuLyYeuCauXoaKH(String maKH) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa khách hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              await controller.XuLyYeuCauXoaKH(maKH);
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

  Widget HienThiDSKH() {
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
                    XuLyYeuCauThemKH();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.cyan, size: 32),
                  tooltip: 'Sửa',
                  onPressed: () {
                    if (idSelected != null) {
                      XuLyYeuCauSuaKH(idSelected!);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 32),
                  tooltip: 'Xóa',
                  onPressed: () {
                    if (idSelected != null) {
                      XuLyYeuCauXoaKH(idSelected!);
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
                    DataColumn(label: Text('Địa chỉ')),
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
                        DataCell(Text(kh['DIACHI'] ?? '')),
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