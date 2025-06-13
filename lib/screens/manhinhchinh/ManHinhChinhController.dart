import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:is201_prj_store_management/screens/khachhang/khachhang_screen.dart';
import 'package:is201_prj_store_management/screens/hoadon/hoadon_screen.dart';
import 'package:is201_prj_store_management/screens/sanpham/sanpham_screen.dart';
import 'package:is201_prj_store_management/screens/khuyenmai/khuyenmai_screen.dart';
import 'package:is201_prj_store_management/screens/nhanvien/GUI_QLNV.dart';
import 'package:is201_prj_store_management/screens/ca_lam_viec/calv_screen.dart';
import 'package:is201_prj_store_management/screens/statistic/statistic_screen.dart';
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
      HoaDonScreen(),
      SanPhamScreen(),
      if (role != 'NhanVien') KhuyenMaiScreen(),
      KhachHangScreen(),
      if (role != 'NhanVien') GuiQLNV(),
      CaLVScreen(),
      StatisticScreen(),
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
