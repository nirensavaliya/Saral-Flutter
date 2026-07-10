import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/SaleData/Model/brand_list_model.dart';
import 'package:saral/View/Screen/SaleData/Model/customer_model.dart';
import 'package:saral/View/Screen/SaleData/Model/get_catefory_brand_list_model.dart';
import 'package:saral/View/Screen/SaleData/Model/get_gst_model.dart';

class ApiConstant {
  static const String baseurl = "https://gurukrupawebapis.azurewebsites.net/api";
  static const String selectCompany = "$baseurl/User/Selectcompany/YZ9645/48";
  static const String companyList = "$baseurl/User/Companylist/YZ9645";
  static const String userLogin = "$baseurl/User/UserLogin";
  static const String isUserIsAdmin = "$baseurl/User/IsUserIsAdmin";
  static const String customerLogin = "$baseurl/User/CustomerLogin";
  static const String sendOtp = "$baseurl/User/SendOTP?";
  static const String dashboardElements = "$baseurl/Dashboard/DashboardElements";
  static const String todayTotalSale = "$baseurl/Dashboard/TodaysTotalsale";
  static const String monthlyTotalSale = "$baseurl/Dashboard/MonthlyTotalsale";
  static const String getCategoryList = "$baseurl/Master/GetCategoryList";
  static const String getItemListByBrandAndCategoryPagingPageSize6 =
      "$baseurl/Master/GetItemListByBrandandCategory_paging";
  static const String getCategoryItem = "$baseurl/Master/GetItemListByBrandandCategory_paging?";
  static const String getItemList = "$baseurl/Reports/ItemList";
  static String getBrandList = '$baseurl/Master/GetBrandList';
  static String GetItemListByBrandandCategory = '$baseurl/Master/GetItemListByBrandandCategory';
  static String saleOrderList = '$baseurl/SaleOrder/SaleOrderList';
  static String GetCustomerDetails = '$baseurl/Customer/GetCustomerDetails';
  static String saveSaleOrder = '$baseurl/SaleOrder/SaveSaleOrder';
  static String SaveSaleOrderfromcustomer = '$baseurl/Customer/SaveSaleOrderfromcustomer';
  static String nextOrderNo = '$baseurl/SaleOrder/NextOrderNo';
  static String getCustomerList = '$baseurl/Master/GetCustomerList';




  static List<CustomerData> customerList = [];
  static List<CategoryBrandData> categoryBrandList = [];
  static List<BranddData> brandList = [];
  static List<ItemData> categoryWiseItemList = [];
  static List<GetGstData> gstList = [];


}

List<CustomerData> filteredCustomer = [];
List<ItemData> filteredItems = [];

