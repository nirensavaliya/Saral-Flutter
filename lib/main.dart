import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Global.dart';
import 'package:saral/View/Screen/Dashboard/View/Dashboard.dart';
import 'package:saral/View/Screen/Login/view/Login_screen.dart';
import 'package:saral/View/Screen/Splash/view/Spalsh_Screen.dart';
import 'package:saral/View/Utils/App_Pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global();
  await GetStorage.init();

  runApp(ToastificationWrapper(child: const MyApp()));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final token = GetStorageHelper.readString(GetStorageHelper.token);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: AppPages.routes,
        home: SplashScreen(),
        theme: ThemeData(
        ),
      ),
    );
  }
}

