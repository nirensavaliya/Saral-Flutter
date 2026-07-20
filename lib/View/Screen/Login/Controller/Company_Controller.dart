
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../Common/Get_Storage.dart';
import '../../../../Common/Tost.dart';
import '../../../../Data/Constant/Api_Service.dart';
import '../../../../Data/Constant/api_constant.dart';
import '../../../Utils/App_Routes.dart';
import '../Model/CompanyListModel.dart';
import '../Model/Select_Comapny_Model.dart';

class CompanyController extends GetxController {
  var code = "";
  List<CompanyData> companyData = [];
  final ApiService _apiService = ApiService();
  final List<TextEditingController> codeController =
  List.generate(6, (index) => TextEditingController());

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> autoLogin(BuildContext context) async {

    await apiCallGetCompanyList();

    await apiSelectCompany();
  }

  Future<void> apiSelectCompany() async {
    try {
      final response = await _apiService.getRequest(ApiConstant.selectCompany);
      print("Select Company token-----${response.data}");
      final selectComapny = SelectCompanyModel.fromJson(response.data);
      if (response.statusCode == 200) {
        final token = selectComapny.data?.token;
        if (token is String && token.isNotEmpty) {
          await GetStorageData.saveString(GetStorageData.token, token);
        }
        // await GetStorageData.saveString(
        //     GetStorageData.token, selectComapny.data!.token);
        // await GetStorageData.saveBoolean(GetStorageData.isCustomer, false);
        update();
      } else if (selectComapny.statusCode == 401) {
        print("Unauthorized access: Token expired or invalid");

        // Clear token and other related data
        await GetStorageData.removeData(GetStorageData.token);
        await GetStorageData.saveBoolean(GetStorageData.isCustomer, false);
        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        // Handle other errors
        Utils().showToast(message: selectComapny.responseMsg ?? "Unknown error", title: 'Error',context: Get.context!,isSuccess: false);
      }
    } catch (e) {
      Utils().showToast(
        message: "Error: ${e.toString()}",
        context: Get.context!,
        title: 'Error',
        isSuccess: false,
      );
      // Utils().showToast(context: Get.context!, title: title, message: message)
    }
  }


  Future<void> apiCallGetCompanyList() async {
    code = "DE0909";
    codeController.forEach((element) {
      if(code!.isEmpty)
      {
        code = element.text;
      }
      else
      {
        code = (code! + element.text);
      }
    },);

    final response = await _apiService.getRequest(ApiConstant.companyList, );
    print("Select Company list -----${response.data}");
    if (response.statusCode == 200) {
      final companyList = CompanyListModel.fromJson(response.data);

      GetStorageData.saveString(GetStorageData.companyCode, code);
      companyData = companyList.data??[];
      update();
    }
  }



}