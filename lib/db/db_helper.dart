import 'package:hive_flutter/hive_flutter.dart';

class DBHelper {
  static Future<void> initDb() async {
    await Hive.initFlutter();
    await Hive.openBox('NHANVIEN');
    await Hive.openBox('KHACHHANG');
    await Hive.openBox('SANPHAM');
    await Hive.openBox('HOADON');
    await Hive.openBox('KHUYENMAI');
    await Hive.openBox('CTHD');
    await Hive.openBox('CHAMCONG');
    await Hive.openBox('NHAPHANG');
  }

  static Box getBox(String name) => Hive.box(name);
static Future<dynamic> insertInstanceTest(
    String table,
    Map<String, dynamic> data,
  ) async {
    final box = getBox(table);
    print('Data before add: $data');
    return await box.add(data);
  }
  static Future<dynamic> insertInstance(
    String table,
    String key,
    Map<String, dynamic> data,
  ) async {
    final box = getBox(table);
    final value = data[key]?.toString() ?? '';

    // Sinh mã tự động: prefix + số tăng dần (VD: NV001, KH001, SP001...)
    String prefix = key;
    if (key.startsWith('MA') && key.length > 2) {
      prefix = key.substring(2); // Loại bỏ 'MA' đầu, ví dụ: MANV -> NV
    }
    if (value.isEmpty || !value.startsWith(prefix)) {
      final allKeys =
          box.values
              .map((e) => (e as Map)[key]?.toString() ?? '')
              .where((ma) => ma.startsWith(prefix))
              .toList();
      int maxNum = 0;
      for (var ma in allKeys) {
        final numStr = ma.replaceAll(prefix, '');
        final num = int.tryParse(numStr) ?? 0;
        if (num > maxNum) maxNum = num;
      }
      final newNum = maxNum + 1;
      final newId = prefix + newNum.toString().padLeft(3, '0');
      data[key] = newId;
    } else {
      data[key] = value;
    }
    print('Data before add: $data');
    return await box.add(data);
  }

  // Lấy tất cả
  static Future<List<Map<String, dynamic>>> getAllNhanVien() async {
    final box = getBox('NHANVIEN');
    print('NHANVIEN: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllKhachHang() async {
    final box = getBox('KHACHHANG');
    print('KHACHHANG: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllSanPham() async {
    final box = getBox('SANPHAM');
    print('SANPHAM: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllHoaDon() async {
    final box = getBox('HOADON');
    print('HOADON: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllKhuyenMai() async {
    final box = getBox('KHUYENMAI');
    print('KHUYENMAI: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllCaLV() async {
    final box = getBox('CHAMCONG');
    print('CHAMCONG: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllNhapHang() async {
    final box = getBox('NHAPHANG');
    print('NHAPHANG: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<List<Map<String, dynamic>>> getAllCTHD() async {
    final box = getBox('CTHD');
    print('CTHD: ${box.values}');
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> updateInstance(
    String table,
    String key,
    String id,
    Map<String, dynamic> data,
  ) async {
    final box = getBox(table);
    final hiveKey = box.keys.firstWhere((k) {
      final item = box.get(k) as Map?;
      return item != null && item[key] == id;
    }, orElse: () => null);
    if (hiveKey != null) {
      await box.put(hiveKey, data);
    }
  }

  static Future<void> deleteInstance(
    String table,
    String key,
    String id,
  ) async {
    final box = getBox(table);
    final hiveKey = box.keys.firstWhere((k) {
      final item = box.get(k) as Map?;
      return item != null && item[key] == id;
    }, orElse: () => null);
    if (hiveKey != null) {
      await box.delete(hiveKey);
    }
  }

  static Future<void> clearTable(String table) async {
    final box = getBox(table);
    await box.clear();
  }

  static Future<Map<String, dynamic>?> getInstanceByID(
    String table,
    String key,
    String id,
  ) async {
    final box = getBox(table);
    try {
      final found = box.values.cast<Map>().firstWhere(
        (item) => item[key] == id,
      );
      return Map<String, dynamic>.from(found);
    } catch (e) {
      return null;
    }
  }
}
