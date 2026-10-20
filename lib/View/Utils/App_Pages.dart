
import 'package:get/get.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Screen/AddToCart/view/AddToCart.dart';
import 'package:saral/View/Screen/AddToCart/view/order_success_view.dart';
import 'package:saral/View/Screen/AddToCart/view/shipping_address_view.dart';
import 'package:saral/View/Screen/Admin/Controller/item_list_controller.dart';
import 'package:saral/View/Screen/Admin/Controller/offer_image_controller.dart';
import 'package:saral/View/Screen/Admin/Controller/promo_message_controller.dart';
import 'package:saral/View/Screen/Admin/Controller/show_report_controller.dart';
import 'package:saral/View/Screen/Admin/Controller/team_member_controller.dart';
import 'package:saral/View/Screen/Admin/Controller/admin_product_list_controller.dart';
import 'package:saral/View/Screen/Admin/View/admin_home_view.dart';
import 'package:saral/View/Screen/Admin/View/admin_product_list_view.dart';
import 'package:saral/View/Screen/Admin/View/admin_product_view.dart';
import 'package:saral/View/Screen/Admin/View/admin_promo_message_view.dart';
import 'package:saral/View/Screen/Admin/View/item_list_view.dart';
import 'package:saral/View/Screen/Admin/View/offer_image_view.dart';
import 'package:saral/View/Screen/Admin/View/show_report_view.dart';
import 'package:saral/View/Screen/Admin/View/team_member_form_view.dart';
import 'package:saral/View/Screen/Admin/View/team_member_list_view.dart';
import 'package:saral/View/Screen/ContactUs/view/ContactUs.dart';
import 'package:saral/View/Screen/Dashboard/View/Dashboard.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/Home/View/customer_team_members_view.dart';
import 'package:saral/View/Screen/Home/View/home_catalog_legacy_view.dart';
import 'package:saral/View/Screen/Login/Controller/Company_Controller.dart';
import 'package:saral/View/Screen/Login/Controller/LoginController.dart';
import 'package:saral/View/Screen/Login/view/Login_screen.dart';
import 'package:saral/View/Screen/Pdf%20View/View/pdf_view.dart';
import 'package:saral/View/Screen/Pending%20Sale%20Order/View/pending_sale_order_view.dart';
import 'package:saral/View/Screen/Product/Controller/productController.dart';
import 'package:saral/View/Screen/Product/view/ProductScreen.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Screen/ProductDetail/view/sub_category_detail_view.dart';
import 'package:saral/View/Screen/ProductDetail/view/productDetailView.dart';
import 'package:saral/View/Screen/Profile/controller/ProfileController.dart';
import 'package:saral/View/Screen/Profile/view/ProfileScreen.dart';
import 'package:saral/View/Screen/Sales Employee/Controller/employee_home_controller.dart';
import 'package:saral/View/Screen/Sales Employee/View/employee_home_view.dart';
import 'package:saral/View/Screen/Splash/Controller/Splash_Controller.dart';
import 'package:saral/View/Screen/Splash/view/Spalsh_Screen.dart';
import 'package:saral/View/Screen/customerViewScreen.dart';
import 'package:saral/View/Screen/ledger_statement/controllers/ledger_statement_controller.dart';
import 'package:saral/View/Screen/ledger_statement/views/ledger_statement_view.dart';
import 'package:saral/View/Utils/App_Routes.dart';

import '../Screen/Admin/Controller/AdminHomeController.dart';
import '../Screen/Pdf View/Controller/pdf_controller.dart';
import '../Screen/Pending Sale Order/Controller/pedning_sale_order_controller.dart';
import '../Screen/Sale Order/controllers/sales_order_controller.dart';
import '../Screen/Sale Order/views/sales_order_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => SplashScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
        Get.lazyPut<CompanyController>(() => CompanyController());
      }),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<CompanyController>(() => CompanyController());
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),     GetPage(
      name: AppRoutes.homeScreen,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<HomeController>(() => HomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.homeCatalogLegacyScreen,
      page: () => HomeCatalogLegacyView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut<HomeController>(() => HomeController());
        }
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
      name: AppRoutes.adminProductScreen,
      page: () => AdminProductView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut<HomeController>(() => HomeController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminProductListScreen,
      page: () => const AdminProductListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminProductListController>(
          () => AdminProductListController(),
        );
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
      name: AppRoutes.subCategoryDetailScreen,
      page: () => const SubCategoryDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProductDetailController>(() => ProductDetailController());
      }),
    ),
    GetPage(
      name: AppRoutes.addToCartScreen,
      page: () => const AddToCart(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AddToCartController>(() => AddToCartController());
      }),
    ),
    GetPage(
      name: AppRoutes.shippingAddressScreen,
      page: () => const ShippingAddressView(),
    ),
    GetPage(
      name: AppRoutes.orderSuccessScreen,
      page: () => const OrderSuccessView(),
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => ProfileScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
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
    GetPage(
      name: AppRoutes.pendingSaleOrderScreen,
      page: () => PendingSaleOrderView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PendingSaleOrderController>( () => PendingSaleOrderController());
      }),
    ),
    GetPage(
      name: AppRoutes.pdfViewScreen,
      page: () => PdfView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PdfViewController>( () => PdfViewController());
      }),
    ),
    GetPage(
      name: AppRoutes.ledgerStatementScreen,
      page: () => const LedgerStatementView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LedgerStatementController>(
            () => LedgerStatementController());
      }),
    ),
    GetPage(
      name: AppRoutes.offerImageScreen,
      page: () => OfferImageView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OfferImageController>( () => OfferImageController());
      }),
    ),
    GetPage(
      name: AppRoutes.promoMessageScreen,
      page: () => const PromoMessageView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PromoMessageController>(() => PromoMessageController());
      }),
    ),
    GetPage(
      name: AppRoutes.showReportScreen,
      page: () => const ShowReportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ShowReportController>(
          () => ShowReportController(),
          fenix: true,
        );
      }),
    ),
    GetPage(
      name: AppRoutes.itemListScreen,
      page: () => const ItemListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<ItemListController>(() => ItemListController());
      }),
    ),
    GetPage(
      name: AppRoutes.teamMemberListScreen,
      page: () => const TeamMemberListView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<TeamMemberController>(() => TeamMemberController());
      }),
    ),
    GetPage(
      name: AppRoutes.customerTeamMembersScreen,
      page: () => const CustomerTeamMembersView(),
    ),
    GetPage(
      name: AppRoutes.teamMemberFormScreen,
      page: () => const TeamMemberFormView(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<TeamMemberController>()) {
          Get.lazyPut<TeamMemberController>(() => TeamMemberController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.adminHomeScreen,
      page: () =>  AdminHomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AdminHomeController>(() => AdminHomeController());
      }),
    ),
    GetPage(
      name: AppRoutes.employeeHomeScreen,
      page: () => EmployeeHomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<EmployeeHomeController>(() => EmployeeHomeController());
      }),
    ),
  ];
}