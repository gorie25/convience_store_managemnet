import 'package:get/get.dart';
import 'package:is201_prj_store_management/screens/manhinhchinh/GuiManHinhChinh.dart';
import 'package:is201_prj_store_management/screens/dangnhap/GUI_TrangDangNhap.dart';


final appRoutes = [
  GetPage(name: '/login', page: () => GuiTrangDangNhap()),
  GetPage(name: '/home', page: () => GuiManHinhChinh()),

];
