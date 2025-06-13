import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/ca_lam_viec/calv_controller.dart';
import 'add_calv_dialog.dart';

class CaLVScreen extends StatelessWidget {
  final controller = Get.put(CaLVController());

  CaLVScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu cho UI demo
    if (controller.calv.isEmpty) {
      controller.calv.value = [
        {'MACA': 'CA01', 'TENCA': 'Sáng', 'GIOBD': '07:00', 'GIOKT': '11:00'},
        {'MACA': 'CA02', 'TENCA': 'Trưa', 'GIOBD': '11:00', 'GIOKT': '15:00'},
        {'MACA': 'CA03', 'TENCA': 'Chiều', 'GIOBD': '15:00', 'GIOKT': '19:00'},
        {'MACA': 'CA04', 'TENCA': 'Tối', 'GIOBD': '19:00', 'GIOKT': '23:00'},
        {'MACA': 'CA05', 'TENCA': 'Đêm', 'GIOBD': '23:00', 'GIOKT': '03:00'},
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý ca làm việc'),
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
                      hintText: 'Nhập thông tin ca làm việc tìm kiếm',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
                      builder: (_) => AddCaLVDialog(
                        onAdd: (maCa, tenCa, gioBD, gioKT) {
                          controller.addCaLV({
                            'MACA': maCa,
                            'TENCA': tenCa,
                            'GIOBD': gioBD,
                            'GIOKT': gioKT,
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
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Mã ca')),
                    DataColumn(label: Text('Tên ca')),
                    DataColumn(label: Text('Giờ bắt đầu')),
                    DataColumn(label: Text('Giờ kết thúc')),
                  ],
                  rows: controller.calv.map((ca) => DataRow(cells: [
                    DataCell(Text(ca['MACA'] ?? '')),
                    DataCell(Text(ca['TENCA'] ?? '')),
                    DataCell(Text(ca['GIOBD'] ?? '')),
                    DataCell(Text(ca['GIOKT'] ?? '')),
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
