import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'QLTK_Controller.dart';

class QLTK_GUI extends StatefulWidget {
  const QLTK_GUI({super.key});

  @override
  State<QLTK_GUI> createState() => _QLTK_GUIState();
}

class _QLTK_GUIState extends State<QLTK_GUI> with SingleTickerProviderStateMixin {
  final QLTK_Controller controller = Get.put(QLTK_Controller());
  late TabController _tabController;
  final List<int> availableYears = List.generate(10, (index) => DateTime.now().year - index);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    controller.fetchThongKeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê dữ liệu'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.table_chart), text: 'Dạng bảng'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Biểu đồ cột'),
            Tab(icon: Icon(Icons.show_chart), text: 'Biểu đồ đường'),
            Tab(icon: Icon(Icons.info), text: 'Thông tin TK'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() => DropdownButton<int>(
              value: controller.selectedYear.value,
              items: availableYears.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text('Năm $year'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.updateSelectedYear(value);
                }
              },
              style: const TextStyle(color: Colors.black),
            )),
          ),
        ],
      ),      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return TabBarView(
          controller: _tabController,
          children: [
            HienThiDanhSachSanPham(),
            HienThiColumnChart(),
            HienThiLineChart(),
            LayThongTinTHD(),
          ],
        );
      }),
    );
  }  // Hiển thị dạng bảng
  Widget HienThiDanhSachSanPham() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê doanh thu theo tháng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Tháng')),
              DataColumn(label: Text('Doanh thu')),
              DataColumn(label: Text('Số lượng SP')),
              DataColumn(label: Text('Khách hàng')),
            ],
            rows: List.generate(controller.months.length, (index) {
              final month = controller.months[index];
              final revenue = controller.revenueData.isEmpty ? 0.0 : controller.revenueData[index];
              final productQty = controller.productQuantityData.isEmpty ? 0.0 : controller.productQuantityData[index];
              final customerCount = controller.customerCountData.isEmpty ? 0.0 : controller.customerCountData[index];
              
              return DataRow(
                cells: [
                  DataCell(Text('Tháng $month')),
                  DataCell(Text('${revenue.toStringAsFixed(0)} VND')),
                  DataCell(Text('${productQty.toStringAsFixed(0)}')),
                  DataCell(Text('${customerCount.toStringAsFixed(0)}')),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  // Hiển thị biểu đồ cột
  Widget HienThiColumnChart() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biểu đồ cột doanh thu theo tháng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: CustomPaint(
              painter: BarChartPainter(
                months: controller.months,
                revenue: controller.revenueData.toList(),
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Biểu đồ cột số lượng sản phẩm bán ra',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: CustomPaint(
              painter: BarChartPainter(
                months: controller.months,
                revenue: controller.productQuantityData.toList(),
                barColor: Colors.green,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
  // Hiển thị biểu đồ đường
  Widget HienThiLineChart() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Biểu đồ đường doanh thu theo tháng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: CustomPaint(
              painter: LineChartPainter(
                months: controller.months,
                revenue: controller.revenueData.toList(),
              ),
              child: Container(),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Biểu đồ đường số lượng khách hàng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: CustomPaint(
              painter: LineChartPainter(
                months: controller.months,
                revenue: controller.customerCountData.toList(),
                lineColor: Colors.blue,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
  // Hiển thị thông tin thống kê
  Widget LayThongTinTHD() {
    // Tính toán các chỉ số thống kê
    double totalRevenue = controller.revenueData.fold(0, (sum, item) => sum + item);
    double totalProducts = controller.productQuantityData.fold(0, (sum, item) => sum + item);
    double totalCustomers = controller.customerCountData.fold(0, (sum, item) => sum + item);
    
    // Tìm tháng có doanh thu cao nhất
    int maxRevenueMonth = 0;
    double maxRevenue = 0;
    for (int i = 0; i < controller.revenueData.length; i++) {
      if (controller.revenueData[i] > maxRevenue) {
        maxRevenue = controller.revenueData[i];
        maxRevenueMonth = i;
      }
    }
    
    // Tìm tháng có doanh thu thấp nhất
    int minRevenueMonth = 0;
    double minRevenue = double.maxFinite;
    for (int i = 0; i < controller.revenueData.length; i++) {
      if (controller.revenueData[i] < minRevenue && controller.revenueData[i] > 0) {
        minRevenue = controller.revenueData[i];
        minRevenueMonth = i;
      }
    }
    
    // Tính trung bình doanh thu
    double avgRevenue = totalRevenue / controller.months.length;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng kết thống kê năm',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildStatisticCard(
            title: 'Tổng doanh thu',
            value: '${totalRevenue.toStringAsFixed(0)} VND',
            icon: Icons.attach_money,
            color: Colors.green,
          ),
          _buildStatisticCard(
            title: 'Tổng sản phẩm bán ra',
            value: '${totalProducts.toStringAsFixed(0)} sản phẩm',
            icon: Icons.shopping_cart,
            color: Colors.blue,
          ),
          _buildStatisticCard(
            title: 'Tổng khách hàng',
            value: '${totalCustomers.toStringAsFixed(0)} khách hàng',
            icon: Icons.people,
            color: Colors.orange,
          ),
          _buildStatisticCard(
            title: 'Tháng có doanh thu cao nhất',
            value: 'Tháng ${controller.months[maxRevenueMonth]}: ${maxRevenue.toStringAsFixed(0)} VND',
            icon: Icons.trending_up,
            color: Colors.red,
          ),
          _buildStatisticCard(
            title: 'Tháng có doanh thu thấp nhất',
            value: 'Tháng ${controller.months[minRevenueMonth]}: ${minRevenue.toStringAsFixed(0)} VND',
            icon: Icons.trending_down,
            color: Colors.purple,
          ),
          _buildStatisticCard(
            title: 'Doanh thu trung bình mỗi tháng',
            value: '${avgRevenue.toStringAsFixed(0)} VND',
            icon: Icons.calculate,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> revenue;
  final Color lineColor;
  
  LineChartPainter({required this.months, required this.revenue, this.lineColor = Colors.deepPurple});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    
    // Draw axis
    canvas.drawLine(Offset(40, size.height - 30), Offset(size.width, size.height - 30), axisPaint); // X
    canvas.drawLine(Offset(40, size.height - 30), Offset(40, 0), axisPaint); // Y
    
    // Draw X labels
    final double stepX = (size.width - 50) / (months.length - 1);
    for (int i = 0; i < months.length; i++) {
      final x = 40 + i * stepX;
      final tp = TextPainter(
        text: TextSpan(text: months[i], style: const TextStyle(fontSize: 12, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 25));
    }
    
    // Draw Y labels
    final maxY = revenue.isEmpty ? 1.0 : revenue.reduce((a, b) => a > b ? a : b);
    for (int i = 0; i <= 5; i++) {
      final y = size.height - 30 - i * (size.height - 50) / 5;
      final value = (maxY / 5 * i).round();
      final tp = TextPainter(
        text: TextSpan(text: value.toString(), style: const TextStyle(fontSize: 10, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    
    // Draw line
    if (revenue.isNotEmpty) {
      final points = List.generate(revenue.length, (i) {
        final x = 40 + i * stepX;
        final y = size.height - 30 - (revenue[i] / maxY) * (size.height - 50);
        return Offset(x, y);
      });
      
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
      
      // Draw points
      final pointPaint = Paint()..color = lineColor;
      for (final p in points) {
        canvas.drawCircle(p, 4, pointPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> revenue;
  final Color barColor;
  
  BarChartPainter({required this.months, required this.revenue, this.barColor = Colors.orange});

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;
    
    // Draw axis
    canvas.drawLine(Offset(40, size.height - 30), Offset(size.width, size.height - 30), axisPaint); // X
    canvas.drawLine(Offset(40, size.height - 30), Offset(40, 0), axisPaint); // Y
    
    // Draw X labels
    final double stepX = (size.width - 50) / (months.length);
    for (int i = 0; i < months.length; i++) {
      final x = 40 + (i + 0.5) * stepX;
      final tp = TextPainter(
        text: TextSpan(text: months[i], style: const TextStyle(fontSize: 12, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 25));
    }
    
    // Draw Y labels
    final maxY = revenue.isEmpty ? 1.0 : revenue.reduce((a, b) => a > b ? a : b);
    for (int i = 0; i <= 5; i++) {
      final y = size.height - 30 - i * (size.height - 50) / 5;
      final value = (maxY / 5 * i).round();
      final tp = TextPainter(
        text: TextSpan(text: value.toString(), style: const TextStyle(fontSize: 10, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    
    // Draw bars
    if (revenue.isNotEmpty) {
      final barWidth = stepX * 0.6;
      final barPaint = Paint()..color = barColor;
      
      for (int i = 0; i < revenue.length; i++) {
        final x = 40 + (i + 0.5) * stepX - barWidth / 2;
        final y = size.height - 30 - (revenue[i] / maxY) * (size.height - 50);
        canvas.drawRect(Rect.fromLTWH(x, y, barWidth, size.height - 30 - y), barPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}