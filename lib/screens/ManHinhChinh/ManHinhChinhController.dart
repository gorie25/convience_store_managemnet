import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:is201_prj_store_management/screens/QuanLySanPham/GUI_QLSP.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhachHang/GUI_QLKH.dart';
import 'package:is201_prj_store_management/screens/QuanLyHoaDon/GUI_QLHD.dart';
import 'package:is201_prj_store_management/screens/QuanLyKhuyenMai/GUI_QLKM.dart';
import 'package:is201_prj_store_management/screens/QuanLyNhanVien/GUI_QLNV.dart';
import 'package:is201_prj_store_management/screens/QuanLyCaLamViec/GUI_QLCA.dart';
import 'package:is201_prj_store_management/screens/ThongKe/GUI_QLTK.dart';
import 'package:is201_prj_store_management/screens/nhap_hang/import_goods_screen.dart';

class ManHinhChinhController extends GetxController {
  // Trả về danh sách màn hình và sidebar item dựa trên role
  Map<String, dynamic> layGiaoDienTrangChu(String? role) {
    final screens = <Widget>[
      Center(
        child: Image.asset(
          'assets/grocerystore.png',
          fit: BoxFit.contain,
          width: 800,
          height: 800,
        ),
      ),
      GuiQLHD(),
      if (role != 'NhanVien') KhuyenMaiScreen(),
      GuiQLKH(),
      if (role != 'NhanVien') GuiQLNV(),
      GuiQLCA(),
      QLTK_GUI(),
      if (role != 'NhanVien') ImportGoodsScreen(),
    ];

    final items = [
      {'icon': Icons.home, 'label': 'Trang Chủ'},
      {'icon': Icons.receipt_long, 'label': 'Hóa Đơn'},
      {'icon': Icons.shopping_bag, 'label': 'Sản Phẩm'},
      if (role != 'NhanVien')
        {'icon': Icons.local_offer, 'label': 'Khuyến Mại'},
      {'icon': Icons.people, 'label': 'Khách Hàng'},
      if (role != 'NhanVien') {'icon': Icons.badge, 'label': 'Nhân Viên'},
      {'icon': Icons.schedule, 'label': 'Chốt Ca'},
      {'icon': Icons.bar_chart, 'label': 'Thống Kê'},
      if (role != 'NhanVien') {'icon': Icons.warehouse, 'label': 'Kho Hàng'},
    ];

    return {'screens': screens, 'items': items};
  }
  String kiemTraQuyen() {
    final args = Get.arguments;
    if (args != null && args['role'] != null) {
      return args['role'] as String;
    }
    return 'NhanVien';
  }
}
