
import 'package:get/get.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Screen/AddToCart/view/AddToCart.dart';
import 'package:saral/View/Screen/ContactUs/view/ContactUs.dart';
import 'package:saral/View/Screen/Dashboard/View/Dashboard.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/Login/Controller/LoginController.dart';
import 'package:saral/View/Screen/Login/view/Login_screen.dart';
import 'package:saral/View/Screen/Product/Controller/productController.dart';
import 'package:saral/View/Screen/Product/view/ProductScreen.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Screen/ProductDetail/view/productDetailView.dart';
import 'package:saral/View/Screen/Profile/controller/ProfileController.dart';
import 'package:saral/View/Screen/Profile/view/ProfileScreen.dart';
import 'package:saral/View/Screen/SaleData/controllers/sales_order_controller.dart';
import 'package:saral/View/Screen/SaleData/views/sales_order_view.dart';
import 'package:saral/View/Screen/Splash/Controller/Splash_Controller.dart';
import 'package:saral/View/Screen/Splash/view/Spalsh_Screen.dart';
import 'package:saral/View/Screen/customerViewScreen.dart';
import 'package:saral/View/Utils/App_Routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ), GetPage(
      name: AppRoutes.homeScreen,
      page: () => Home(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.dashboardScreen,
      page: () => Dashboard(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.productScreen,
      page: () => ProductScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductController>(() => ProductController());
      }),
    ),
    GetPage(
      name: AppRoutes.productDetailViewScreen,
      page: () => ProductDetailView(itemListModelData: null),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductDetailController>(() => ProductDetailController());
      }),
    ),
    GetPage(
      name: AppRoutes.addToCartScreen,
      page: () => AddToCart(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddToCartController>(() => AddToCartController());
      }),
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>( () => ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.contactUsScreen,
      page: () => Contactus(),

    ),
    GetPage(
      name: AppRoutes.customerViewScreen,
      page: () => Customerviewscreen(),
    ),
    GetPage(
      name: AppRoutes.saleOrderScreen,
      page: () => SalesOrderView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SalesOrderController>( () => SalesOrderController());
      }),
    ),
  ];
}