import 'package:flutter/material.dart';

/// Hiển thị date picker chuẩn Việt Nam, trả về chuỗi dd/MM/yyyy hoặc null nếu không chọn
Future<String?> showDatePickerVN(BuildContext context) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900, 1, 1),
    lastDate: DateTime(2025, 12, 31),
    locale: const Locale('vi', 'VN'),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blueAccent, // header background color
            onPrimary: Colors.white, // header text color
            onSurface: Colors.black, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueAccent, // button text color
              textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          dialogBackgroundColor: const Color(0xFFF0F8FA),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.deepOrange, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        child: child!,
      );
    },
  );
  if (picked == null) return null;
  return '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
}
