import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:is201_prj_store_management/screens/ManHinhChinh/ManHinhChinhController.dart';


class GuiManHinhChinh extends StatefulWidget {
  const GuiManHinhChinh({Key? key}) : super(key: key);

  @override
  _GuiManHinhChinhState createState() => _GuiManHinhChinhState();
}

class _GuiManHinhChinhState extends State<GuiManHinhChinh> {
  int selectedIndex = 0;
  late String role;
  final ManHinhChinhController mainController = Get.put(
    ManHinhChinhController(),
  );

  @override
  void initState() {
    super.initState();
    role = mainController.kiemTraQuyen();
  }
  @override
  Widget build(BuildContext context) {
    final data = mainController.layGiaoDienTrangChu(role);
    final List<Widget> screens = data['screens'];
    final List items = data['items'];

    return Scaffold(body: hienThiTrangChuTheoQuyen(items, screens));
  }
   Widget hienThiTrangChuTheoQuyen(List items, List<Widget> screens) {
    return Row(
      children: [
        Container(
          width: 220,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(height: 32),
              Icon(Icons.store, size: 64, color: Colors.deepPurple),
              SizedBox(height: 8),
              Text(
                'Cửa hàng tiện lợi Vui vẻ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder:
                      (context, index) => ListTile(
                        leading: Icon(
                          items[index]['icon'] as IconData,
                          color:
                              selectedIndex == index ? Colors.deepPurple : null,
                        ),
                        title: Text(
                          items[index]['label'] as String,
                          style: TextStyle(
                            color:
                                selectedIndex == index
                                    ? Colors.deepPurple
                                    : null,
                          ),
                        ),
                        selected: selectedIndex == index,
                        onTap: () => setState(() => selectedIndex = index),
                      ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Đăng Xuất', style: TextStyle(color: Colors.red)),
                onTap:
                    () => Navigator.of(context).pushReplacementNamed('/login'),
              ),
            ],
          ),
        ),
        Expanded(child: screens[selectedIndex]),
      ],
    );
  } 
}
