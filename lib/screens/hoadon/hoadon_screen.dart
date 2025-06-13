import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'hoadon_controller.dart';
import 'add_hoadon_dialog.dart';

class HoaDonScreen extends StatelessWidget {
  final controller = Get.put(HoaDonController());

   HoaDonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho UI demo
    if (controller.hoadon.isEmpty) {
      controller.hoadon.value = [
        {'MAHD': 'HD001', 'MANV': 'NV01', 'NGAYHD': '2024-06-01', 'MAKH': 'KH01', 'TONGTIEN': 1200000},
        {'MAHD': 'HD002', 'MANV': 'NV02', 'NGAYHD': '2024-06-02', 'MAKH': 'KH02', 'TONGTIEN': 800000},
        {'MAHD': 'HD003', 'MANV': 'NV03', 'NGAYHD': '2024-06-03', 'MAKH': 'KH03', 'TONGTIEN': 950000},
        {'MAHD': 'HD004', 'MANV': 'NV01', 'NGAYHD': '2024-06-04', 'MAKH': 'KH04', 'TONGTIEN': 1500000},
        {'MAHD': 'HD005', 'MANV': 'NV02', 'NGAYHD': '2024-06-05', 'MAKH': 'KH05', 'TONGTIEN': 500000},
      ];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Quản lý hóa đơn'), centerTitle: true),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                    // TODO: Thêm logic tìm kiếm
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 36),
                  tooltip: 'Thêm',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AddHoaDonDialog(
                        onAdd: (maHD, maNV, ngayHD, maKH, tongTien) {
                          controller.addHoaDon({
                            'MAHD': maHD,
                            'MANV': maNV,
                            'NGAYHD': ngayHD,
                            'MAKH': maKH,
                            'TONGTIEN': tongTien,
                          });
                        },
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
                return Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Mã HĐ')),
                    DataColumn(label: Text('Mã NV')),
                    DataColumn(label: Text('Ngày HĐ')),
                    DataColumn(label: Text('Mã KH')),
                    DataColumn(label: Text('Tổng tiền')),
                  ],
                  rows: controller.hoadon.map((hd) => DataRow(cells: [
                    DataCell(Text(hd['MAHD'] ?? '')),
                    DataCell(Text(hd['MANV'] ?? '')),
                    DataCell(Text(hd['NGAYHD'] ?? '')),
                    DataCell(Text(hd['MAKH'] ?? '')),
                    DataCell(Text('${hd['TONGTIEN'] ?? ''}')),
                  ])).toList(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
