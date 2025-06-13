import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  final List<String> months = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];
  final List<double> revenue = [
    1000, 2000, 1500, 3000, 2500, 1800, 2200, 2100, 2300, 1700, 1600, 2000
  ];

   StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thống kê'), centerTitle: true), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Biểu đồ doanh thu theo tháng', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _LineChartPainter(months: months, revenue: revenue),
                child: Container(),
              ),
            ),
            SizedBox(height: 32),
            Text('Biểu đồ doanh thu dạng cột', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: CustomPaint(
                painter: _BarChartPainter(months: months, revenue: revenue),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> revenue;
  _LineChartPainter({required this.months, required this.revenue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
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
        text: TextSpan(text: months[i], style: TextStyle(fontSize: 12, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 25));
    }
    // Draw Y labels
    for (int i = 0; i <= 5; i++) {
      final y = size.height - 30 - i * (size.height - 50) / 5;
      final value = (revenue.reduce((a, b) => a > b ? a : b) / 5 * i).round();
      final tp = TextPainter(
        text: TextSpan(text: value.toString(), style: TextStyle(fontSize: 10, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    // Draw line
    final maxY = revenue.reduce((a, b) => a > b ? a : b);
    final points = List.generate(revenue.length, (i) {
      final x = 40 + i * stepX;
      final y = size.height - 30 - (revenue[i] / maxY) * (size.height - 50);
      return Offset(x, y);
    });
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
    // Draw points
    final pointPaint = Paint()..color = Colors.deepPurple;
    for (final p in points) {
      canvas.drawCircle(p, 4, pointPaint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BarChartPainter extends CustomPainter {
  final List<String> months;
  final List<double> revenue;
  _BarChartPainter({required this.months, required this.revenue});

  @override
  void paint(Canvas canvas, Size size) {
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
        text: TextSpan(text: months[i], style: TextStyle(fontSize: 12, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 25));
    }
    // Draw Y labels
    final maxY = revenue.reduce((a, b) => a > b ? a : b);
    for (int i = 0; i <= 5; i++) {
      final y = size.height - 30 - i * (size.height - 50) / 5;
      final value = (maxY / 5 * i).round();
      final tp = TextPainter(
        text: TextSpan(text: value.toString(), style: TextStyle(fontSize: 10, color: Colors.black)),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }
    // Draw bars
    final barWidth = stepX * 0.6;
    final barPaint = Paint()..color = Colors.orange;
    for (int i = 0; i < revenue.length; i++) {
      final x = 40 + i * stepX - barWidth / 2;
      final y = size.height - 30 - (revenue[i] / maxY) * (size.height - 50);
      canvas.drawRect(Rect.fromLTWH(x, y, barWidth, size.height - 30 - y), barPaint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
