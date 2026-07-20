import 'package:saral/View/Screen/Home/Model/GetItemListModel.dart';
import 'package:saral/View/Screen/Sale Order/Model/brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/customer_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_catefory_brand_list_model.dart';
import 'package:saral/View/Screen/Sale Order/Model/get_gst_model.dart';

import '../../View/Screen/Sales Employee/Model/promo_message_model.dart';

class ApiConstant {
  static const String baseurl = "https://saralmarketingwebapis.azurewebsites.net/api";
  static const String selectCompany = "$baseurl/User/Selectcompany/DE0909/7";
  static const String companyList = "$baseurl/User/Companylist/DE0909";
  static const String userLogin = "$baseurl/User/UserLogin";
  static const String isUserIsAdmin = "$baseurl/User/IsUserIsAdmin";
  static const String customerLogin = "$baseurl/User/CustomerLogin";
  static const String sendOtp = "$baseurl/User/SendOTP?";
  static const String dashboardElements = "$baseurl/Dashboard/DashboardElements";
  static const String todayTotalSale = "$baseurl/Dashboard/TodaysTotalsale";
  static const String monthlyTotalSale = "$baseurl/Dashboard/MonthlyTotalsale";
  static const String todaysTotalpurchase = '$baseurl/Dashboard/TodaysTotalpurchase';
  static const String monthlyTotalpurchase = '$baseurl/Dashboard/MonthlyTotalpurchase';
  static const String getCategoryList = "$baseurl/Master/GetCategoryList";
  static const String getItemListByBrandAndCategoryPagingPageSize6 =
      "$baseurl/Master/GetItemListbyCategories_paging";
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
  static String PendingSalesOrder = '$baseurl/Reports/PendingSalesOrder';
  // static String PendingSalesOrder = '$baseurl/Customer/Report/PendingSalesOrder';
  static String pendingSalesOrderPDFurl = '$baseurl/Customer/Report/PendingSalesOrderPDFurl';
  static String GetOfferImage = '$baseurl/Dashboard/GetOfferImage';
  static String deleteCustomer = '$baseurl/Customer/DeleteCustomer';
  static String ledgerStatement = '$baseurl/Reports/LedgerStatement';
  static String getGlaccountList = '$baseurl/Master/GetGlaccountList';
  static String saveOfferImage = '$baseurl/Master/Admin/SaveOfferImage';
  static String getPromotionalMessage = '$baseurl/Dashboard/PromoMessage';
  static String SavePromoMessage = '$baseurl/Master/Admin/SavePromoMessage';
  static String getGstTaxList = '$baseurl/Master/GetGstTaxList';


  static List<CustomerData> customerList = [];
  static List<CategoryBrandData> categoryBrandList = [];
  static List<BranddData> brandList = [];
  static List<ItemData> categoryWiseItemList = [];
  static List<GetGstData> gstList = [];
  static String offerImage = "";
  static PromotionalMessageData promoMessageModel = PromotionalMessageData(message: "No promotional message available.");

  /// Resolve GST tax name (e.g. "GST 18%") from item gstCodeId.
  static String? gstTaxNameForCode(int? gstCodeId) {
    if (gstCodeId == null || gstCodeId == 0) return null;
    for (final gst in gstList) {
      if (gst.gstCodeId == gstCodeId) {
        return gst.gstTaxName;
      }
    }
    return null;
  }
}

List<CustomerData> filteredCustomer = [];
List<ItemData> filteredItems = [];

