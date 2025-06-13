import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_import_goods_dialog.dart';

class ImportGoodsScreen extends StatelessWidget {
  const ImportGoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho UI demo
    final List<Map<String, dynamic>> demoData = [
      {'MAPN': 'PN001', 'NGAYNHAP': '2024-06-01', 'NHACUNGCAP': 'Công ty A', 'TONGTIEN': 2000000},
      {'MAPN': 'PN002', 'NGAYNHAP': '2024-06-02', 'NHACUNGCAP': 'Công ty B', 'TONGTIEN': 1500000},
      {'MAPN': 'PN003', 'NGAYNHAP': '2024-06-03', 'NHACUNGCAP': 'Công ty C', 'TONGTIEN': 1800000},
      {'MAPN': 'PN004', 'NGAYNHAP': '2024-06-04', 'NHACUNGCAP': 'Công ty D', 'TONGTIEN': 2200000},
      {'MAPN': 'PN005', 'NGAYNHAP': '2024-06-05', 'NHACUNGCAP': 'Công ty E', 'TONGTIEN': 1700000},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Quản lý nhập hàng')),
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
                      hintText: 'Nhập thông tin nhập hàng tìm kiếm',
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
                      builder: (_) => AddImportGoodsDialog(
                        onAdd: (maPN, ngayNhap, nhaCungCap, tongTien) {
                          // TODO: Gọi controller để thêm phiếu nhập hàng mới
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Mã phiếu nhập')),
                  DataColumn(label: Text('Ngày nhập')),
                  DataColumn(label: Text('Nhà cung cấp')),
                  DataColumn(label: Text('Tổng tiền')),
                ],
                rows: demoData.map((pn) => DataRow(cells: [
                  DataCell(Text(pn['MAPN'] ?? '')),
                  DataCell(Text(pn['NGAYNHAP'] ?? '')),
                  DataCell(Text(pn['NHACUNGCAP'] ?? '')),
                  DataCell(Text('${pn['TONGTIEN'] ?? ''}')),
                ])).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
