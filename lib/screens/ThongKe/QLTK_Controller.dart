import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repository/HoaDonRepository.dart';

class QLTK_Controller extends GetxController {
  var doanhthuThang = <Map<String, dynamic>>[].obs;
  var soluongSP = <Map<String, dynamic>>[].obs;
  var khachHang = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var selectedYear = DateTime.now().year.obs;
  
  // Danh sách các tháng
  final List<String> months = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];
  
  // Dữ liệu doanh thu theo tháng
  var revenueData = <double>[].obs;
  
  // Dữ liệu số lượng sản phẩm bán ra theo tháng
  var productQuantityData = <double>[].obs;
  
  // Dữ liệu số lượng khách hàng theo tháng
  var customerCountData = <double>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchThongKeData();
  }
  
  // Cập nhật năm được chọn và tải dữ liệu mới
  void updateSelectedYear(int year) {
    selectedYear.value = year;
    fetchThongKeData();
  }
    // Lấy dữ liệu thống kê
  Future<void> fetchThongKeData() async {
    isLoading.value = true;
    
    try {
      // Tải dữ liệu doanh thu theo tháng
      await LayDoanhThuTheoThang();
      
      // Tải dữ liệu số lượng sản phẩm bán ra
      await LaySoLuongSanPham();
      
      // Tải dữ liệu số lượng khách hàng
      await LaySoLuongKhachHang();
      
      // Cập nhật dữ liệu cho biểu đồ
      CapNhatDuLieuBieuDo();
    } catch (e) {
      HienThiTBLoi('Lỗi khi tải dữ liệu thống kê: ${e.toString()}');
    }
    
    isLoading.value = false;
  }
    // Lấy dữ liệu doanh thu theo tháng
  Future<void> LayDoanhThuTheoThang() async {
    final year = selectedYear.value.toString();
    final hoaDons = await HoaDonRepository.layDSHD();
    
    // Lọc hóa đơn theo năm được chọn
    final filteredHD = hoaDons.where((hd) {
      final ngayLap = hd['NGAYLAP'] ?? '';
      return ngayLap.contains(year);
    }).toList();
    
    // Phân loại doanh thu theo tháng
    Map<String, double> doanhThuMap = {};
    for (var hd in filteredHD) {
      final ngayLap = hd['NGAYLAP'] ?? '';
      final thang = _extractMonth(ngayLap);
      final tongTien = double.tryParse(hd['TONGTIEN'].toString()) ?? 0.0;
      
      doanhThuMap[thang] = (doanhThuMap[thang] ?? 0) + tongTien;
    }
    
    // Chuyển đổi map thành list để lưu trữ
    doanhthuThang.value = months.map((month) {
      return {
        'thang': month,
        'doanhthu': doanhThuMap[month] ?? 0.0
      };
    }).toList();
  }
    // Lấy dữ liệu số lượng sản phẩm bán ra
  Future<void> LaySoLuongSanPham() async {
    // Mô phỏng: Trong thực tế cần truy vấn CSDL
    
    // Mẫu dữ liệu
    Map<String, double> slspMap = {};
    for (var month in months) {
      slspMap[month] = (month.hashCode % 100) * 5.0 + 200; // Dữ liệu mẫu
    }
    
    soluongSP.value = months.map((month) {
      return {
        'thang': month,
        'soluong': slspMap[month] ?? 0.0
      };
    }).toList();
  }
    // Lấy dữ liệu số lượng khách hàng
  Future<void> LaySoLuongKhachHang() async {
    // Mô phỏng: Trong thực tế cần truy vấn CSDL
    
    // Mẫu dữ liệu
    Map<String, double> khMap = {};
    for (var month in months) {
      khMap[month] = (month.hashCode % 40) * 3.0 + 50; // Dữ liệu mẫu
    }
    
    khachHang.value = months.map((month) {
      return {
        'thang': month,
        'soluong': khMap[month] ?? 0.0
      };
    }).toList();
  }
    // Cập nhật dữ liệu cho biểu đồ
  void CapNhatDuLieuBieuDo() {
    revenueData.value = doanhthuThang.map((item) => item['doanhthu'] as double).toList();
    productQuantityData.value = soluongSP.map((item) => item['soluong'] as double).toList();
    customerCountData.value = khachHang.map((item) => item['soluong'] as double).toList();
  }
  
  // Lấy tháng từ chuỗi ngày
  String _extractMonth(String dateString) {
    // Mẫu dateString: 'DD/MM/YYYY'
    final parts = dateString.split('/');
    if (parts.length >= 2) {
      return parts[1]; // Trả về MM
    }
    return '01';
  }
  
  // Hiển thị thông báo lỗi
  void HienThiTBLoi(String message) {
    Get.snackbar(
      'Lỗi',
      message,
      backgroundColor: Colors.red.withOpacity(0.2),
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.error, color: Colors.red),
    );
  }
  
  // Hiển thị thông báo thành công
  void HienThiTBThanhCong(String message) {
    Get.snackbar(
      'Thành công',
      message,
      backgroundColor: Colors.green.withOpacity(0.2),
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }
}