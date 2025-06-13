import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/ca_lam_viec/QLCAController.dart';
import 'package:is201_prj_store_management/screens/ca_lam_viec/GUI_TTCA.dart';

class GuiQLCA extends StatefulWidget {
  const GuiQLCA({super.key});

  @override
  State<GuiQLCA> createState() => _GuiQLCAState();
}

class _GuiQLCAState extends State<GuiQLCA> {
  final QLCAController controller = Get.put(QLCAController());
  int selectedIndex = -1;
  String? idSelected;
  final debounce = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    controller.fetchCaLamViec();
  }

  @override
  Widget build(BuildContext context) {
    return HienThiDSCA();
  }

  void XuLyYeuCauThemCA() {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const GUI_TTCA(),
    );
  }

  void XuLyYeuCauXemChiTietCA(String maCLV) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Chi tiết ca làm việc $maCLV'),
        content: FutureBuilder<Map<String, dynamic>?>(
          future: controller.getCaLamViecByID(maCLV),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Không tìm thấy thông tin ca làm việc');
            }
            
            final ca = snapshot.data!;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã ca: ${ca['MACLV'] ?? ''}'),
                Text('Tên ca: ${ca['TENCA'] ?? ''}'),
                Text('Giờ bắt đầu: ${ca['GIOBD'] ?? ''}'),
                Text('Giờ kết thúc: ${ca['GIOKT'] ?? ''}'),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget HienThiDSCA() {
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
                    XuLyYeuCauThemCA();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.green, size: 32),
                  tooltip: 'Xem chi tiết',
                  onPressed: () {
                    if (idSelected != null) {
                      XuLyYeuCauXemChiTietCA(idSelected!);
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
              final caLamViecList = controller.calamviec;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  columns: const [
                    DataColumn(label: Text('Mã ca')),
                    DataColumn(label: Text('Tên ca')),
                    DataColumn(label: Text('Giờ bắt đầu')),
                    DataColumn(label: Text('Giờ kết thúc')),
                  ],
                  rows: List.generate(caLamViecList.length, (index) {
                    final ca = caLamViecList[index];
                    return DataRow(
                      selected: selectedIndex == index,
                      onSelectChanged: (selected) {
                        setState(() {
                          selectedIndex = selected == true ? index : -1;
                          idSelected = selected == true ? ca['MACLV'] : null;
                        });
                      },
                      cells: [
                        DataCell(Text(ca['MACLV'] ?? '')),
                        DataCell(Text(ca['TENCA'] ?? '')),
                        DataCell(Text(ca['GIOBD'] ?? '')),
                        DataCell(Text(ca['GIOKT'] ?? '')),
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