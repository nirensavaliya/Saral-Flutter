import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Login/Model/CompanyListModel.dart';
import 'package:saral/View/Screen/Login/Model/Select_Comapny_Model.dart';
import 'package:saral/View/Screen/Login/Model/otp_model.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'Company_Controller.dart';

class LoginController extends GetxController with GetSingleTickerProviderStateMixin, CodeAutoFill {
  TextEditingController userNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController pwdController = TextEditingController();

  TextEditingController signContactController = TextEditingController();
  TextEditingController signPwdController = TextEditingController();
  TextEditingController signCPwdController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  final loginKey = GlobalKey<FormState>();
  final signupKey = GlobalKey<FormState>();
  final List<TextEditingController> codeController = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  RxBool isLoading = false.obs;
  final ApiService _apiService = ApiService();
  final Rxn<Data> data = Rxn<Data>();
  List<CompanyData> companyData = [];
  final RxBool isCustomer = false.obs;
  late TabController tabController;
  RxBool isListeningForOtp=false.obs;
  String otp = "";
  String sentOtp = "";
  String otpMsg = "";
  bool isEmployee = true;
  RxBool showOtpScreen = false.obs;
  RxBool isVerifyOtpLoading = false.obs;
  CompanyController companyCodeController = Get.find<CompanyController>();

  @override
  void onInit() {
    super.onInit();
    companyCodeController.autoLogin(Get.context!);
    tabController = TabController(length: 2, vsync: this);

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      isEmployee = args['isEmployee'] ?? false;
    } else {
      isEmployee = false;
    }

    print('isEmployee:: ---- $isEmployee');

    // Initialize OTP listening
    initOtpAutofill();
  }

  Future<void> initOtpAutofill() async {
    try {
      var appSignature = await SmsAutoFill().getAppSignature;
      print("App Signature: $appSignature");
      await startOtpListening();
    } catch (e) {
      print("Error initializing OTP autofill: $e");
    }
  }

  Future<void> startOtpListening() async {
    try {
      if (!isListeningForOtp.value) {
        isListeningForOtp.value = true;

        // Method 1: Using CodeAutoFill mixin (Primary method)
        listenForCode(); // This will trigger codeUpdated() when OTP is received

        // Method 2: Using SmsAutoFill directly (Secondary method)
        SmsAutoFill().listenForCode();

        print("✅ Started listening for OTP messages");
        print("📱 Waiting for OTP SMS...");
      }
    } catch (e) {
      print("❌ Error starting OTP listener: $e");
      isListeningForOtp.value = false;
    }
  }
  @override
  void codeUpdated() {
    if (code != null && code!.isNotEmpty) {
      print("🎯 OTP DETECTED via codeUpdated(): $code");
      handleReceivedOtp(code!);
    }
  }

  void handleReceivedOtp(String receivedOtp) {
    print("=========================================");
    print("RAW OTP MESSAGE: $receivedOtp");

    final digitOnlyOtp = receivedOtp.replaceAll(RegExp(r'[^0-9]'), '');
    print("DIGITS EXTRACTED: $digitOnlyOtp");

    if (digitOnlyOtp.isNotEmpty) {
      final cleanOtp = digitOnlyOtp.length >= 6
          ? digitOnlyOtp.substring(0, 6)
          : digitOnlyOtp;

      print("CLEANED OTP: $cleanOtp");

      // Update the OTP in controller
      otp = cleanOtp;
      otpController.text = cleanOtp;

      print("📝 OTP CONTROLLER UPDATED: ${otpController.text}");

      // Force UI update
      update();

      // Auto-verify if we're on the OTP screen and OTP is complete
      if (isLoading.value && cleanOtp.length == 6) {
        print("🚀 AUTO-VERIFYING OTP...");
        autoVerifyOtp(cleanOtp);
      }
    } else {
      print("❌ No digits found in OTP message");
    }
    print("=========================================");
  }

  void autoVerifyOtp(String otpCode) {
    print("🔄 Auto-verification triggered in 2 seconds...");
    // Wait 2 seconds to allow user to see the auto-filled OTP
    Future.delayed(Duration(seconds: 2), () {
      verifyOtp(otpCode);
    });
  }

  Future<void> validation(BuildContext context) async {
    if (isEmployee) {
      // Employee Login Validation
      if (userNameController.text.trim().isEmpty) {
        Utils().showToast(
          context: context,
          title: "Validation",
          message: "Please enter username",
          isSuccess: false,
        );
        return;
      }

      if (pwdController.text.trim().isEmpty) {
        Utils().showToast(
          context: context,
          title: "Validation",
          message: "Please enter password",
          isSuccess: false,
        );
        return;
      }

      await userLogin(context);
    } else {
      // Customer Login Validation
      if (mobileController.text.trim().isEmpty) {
        Utils().showToast(
          context: context,
          title: "Validation",
          message: "Please enter mobile number",
          isSuccess: false,
        );
        return;
      }

      if (mobileController.text.trim().length != 10) {
        Utils().showToast(
          context: context,
          title: "Validation",
          message: "Please enter valid mobile number",
          isSuccess: false,
        );
        return;
      }

      await customerLogin(context);
    }
  }

  Widget buildOtpField(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      height: 55,
      child: Center(
        child: TextField(
          controller: codeController[index],
          focusNode: focusNodes[index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.top,
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          maxLength: 1,
          cursorHeight: 20,
          style: const TextStyle(fontSize: 24),
          decoration: const InputDecoration(
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < codeController.length - 1) {
                FocusScope.of(context).requestFocus(focusNodes[index + 1]);
              } else {
                focusNodes[index].unfocus();
              }
            } else {
              if (index > 0) {
                FocusScope.of(context).requestFocus(focusNodes[index - 1]);
              }
            }
            // if (value.isNotEmpty) {
            //   if (index < 5) {
            //     FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            //   }
            // } else if (index > 0) {
            //   FocusScope.of(context).requestFocus(focusNodes[index - 1]);
            // }
          },
        ),
      ),
    );
  }

  String getOtpCode() {
    String otp = '';
    for (var controller in codeController) {
      otp += controller.text;
    }
    return otp;
  }

  void verifyOtp(String enteredOtp, {BuildContext? context}) async {
    try {
      isVerifyOtpLoading.value = true;
      print("VERIFYING OTP: $enteredOtp");

      if (enteredOtp.trim() != sentOtp.trim()) {
        Utils().showToast(
          context: Get.context!,
          title: "Error",
          message: "Invalid OTP",
          isSuccess: false,
        );
        isVerifyOtpLoading.value = false;
        return;
      }

      await Future.delayed(const Duration(seconds: 1));

      GetStorageData.saveString(GetStorageData.isOtpVerified, "true");

      if (isEmployee == false) {
        setRole("Customer");
        Utils().showToast(
          context: Get.context!,
          title: "Success",
          message: "Login Successfully",
          isSuccess: true,
        );
        isVerifyOtpLoading.value = false;
        Get.offAllNamed(AppRoutes.dashboardScreen);
      } else {
        Utils().showToast(
          context: Get.context!,
          title: "Success",
          message: "Login Successfully",
          isSuccess: true,
        );
        await apiCallIsUserIsAdmin(Get.context!);
        isVerifyOtpLoading.value = false;
      }
    } catch (e) {
      print(e);
      isVerifyOtpLoading.value = false;
    }
  }

  void resetLoginData() {
    showOtpScreen.value = false;
    otpController.clear();
    otp = "";
    sentOtp = "";

    userNameController.clear();
    pwdController.clear();
    mobileController.clear();

    isVerifyOtpLoading.value = false;
  }

  void simulateOtpReception() {
    print("TEST: Simulating OTP reception...");
    handleReceivedOtp("Your OTP is 123456");
    // handleReceivedOtp("Verification code: 789012");
    // handleReceivedOtp("123456 is your login OTP");
  }

  void setCustomer() {
    isEmployee = false;
    update();
  }

  void setEmployee() {
    isEmployee = true;
    update();
  }

  Future<void> apiCallSendOtp(BuildContext context) async {
    print("isEmployee = $isEmployee");
    try {
      final String apiUrl;

      if (isEmployee == true) {
        apiUrl = "${ApiConstant.sendOtp}UserType=Employee";
      } else {
        apiUrl = "${ApiConstant.sendOtp}UserType=Customer";
      }

      final companyToken =
      GetStorageData.readString(GetStorageData.token);
      print("setOpt company token-----------$companyToken");
      final response = await _apiService.getRequest(
        apiUrl,
        headers: {
          "Authorization": "Bearer $companyToken",
        },
      );

      print("OTP Response : ${response.data}");

      if (response.data == null || response.data is! Map<String, dynamic>) {
        Utils().showToast(
          context: context,
          title: "Error",
          message: "Invalid response from server",
          isSuccess: false,
        );
        return;
      }

      OtpModel model = OtpModel.fromJson(response.data);

      if (model.statusCode == 200) {
        // Get.snackbar(
        //   "Success!",
        //   "OTP Sent to your mobile",
        //   snackPosition: SnackPosition.TOP,
        //   duration: const Duration(seconds: 5),
        // );
        Utils().showToast(
          context: context,
          title: "Success!",
          message: model.data?.otpResponse ?? "OTP Successfully send on Mobile Number",
          isSuccess: true,
        );
        showOtpScreen.value = true;
        sentOtp = model.data?.otp ?? "";
        otp = sentOtp;
        otpMsg = model.data?.otpResponse ?? "";
        await startOtpListening();
        update();
      } else {
        Utils().showToast(
          context: context,
          title: "Error",
          message: model.responseMsg ?? "Failed to send OTP",
          isSuccess: false,
        );
      }
    } catch (e) {
      print("OTP Error : $e");
      Utils().showToast(
        context: context,
        title: "Error",
        message: e.toString(),
        isSuccess: false,
      );
    }
  }

  Future<void> userLogin(BuildContext context) async {
    isEmployee = true;

    print("isEmployee = $isEmployee");
    final name = userNameController.text.trim();
    final password = pwdController.text.trim();
    isLoading.value = true;
    CommonLoader.show(context);
    await GetStorageData.removeData(GetStorageData.isOtpVerified);
    try {
      await apiSelectCompany();
      final companyToken =
      GetStorageData.readString(GetStorageData.token);
      print("Company Token--- :$companyToken");
      final response = await _apiService.postRequest(
        ApiConstant.userLogin,
        data: {
          "userName": name,
          "password": password,
        },
        headers: {
          "Authorization": "Bearer $companyToken",
        },
      );

      print("response code----${response.statusCode}");
      print(response.data);

      if (response.statusCode == 200 &&
          response.data["data"] != null) {

        final token = response.data["data"]["token"];
        if (token is String && token.isNotEmpty) {
          await GetStorageData.saveString(GetStorageData.token, token);
        }
        // GetStorageData.saveString(GetStorageData.token, token);

        await GetStorageData.saveString(GetStorageData.userName, name);
        setRole("Employee");
        CommonLoader.hide();
        // Utils().showToast(
        //   context: Get.context!,
        //   title: "Success",
        //   message: "OTP Send SuccessFully",
        //   isSuccess: true,
        // );
        // Get.offAllNamed(AppRoutes.dashboardScreen);
        // await apiCallIsUserIsAdmin(context);
        await apiCallSendOtp(context);
        update();
      } else {
        CommonLoader.hide();
        Utils().showToast(
          context: Get.context!,
          title: "Login Failed",
          message: response.data["responseMsg"].toString(),
          isSuccess: false,
        );
        return;
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      CommonLoader.hide();

    }
  }

  Future<void> customerLogin(BuildContext context) async {
    isEmployee = false;

    final number = mobileController.text.trim();
    isLoading.value = true;
    CommonLoader.show(context);
    await GetStorageData.removeData(GetStorageData.isOtpVerified);
    try {
      await apiSelectCompany();

      final companyToken =
      GetStorageData.readString(GetStorageData.token);

      print("Company Token : $companyToken");

      final response = await _apiService.postRequest(
        ApiConstant.customerLogin,
        data: {"mobileNo": number},
        headers: {
          "Authorization": "Bearer $companyToken",
        },
      );
      print("Customer LOGIN Response------- ${response.data}");
      if (response.data["statusCode"] == 200 &&
          response.data["data"] != null) {
        final token = response.data["data"]["token"];
        if (token is String && token.isNotEmpty) {
          await GetStorageData.saveString(GetStorageData.token, token);
        }
        // GetStorageData.saveString(GetStorageData.token, token);

        await GetStorageData.saveString(
          GetStorageData.customerMobile,
          number,
        );
        setRole("Customer");
        // Utils().showToast(
        //   context: context,
        //   title: "Success",
        //   message: "Login Successful",
        //   isSuccess: true,
        // );
        // Get.offAllNamed(AppRoutes.dashboardScreen);
        await apiCallSendOtp(context);
        update();
      } else {
        CommonLoader.hide();
        Utils().showToast(
          context: context,
          title: "Login Failed",
          message: response.data["responseMsg"].toString(),
          isSuccess: false,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
      CommonLoader.hide();
    }
  }
  Future<void> apiCallIsUserIsAdmin(BuildContext context) async {
    try {
      final loginToken =
      GetStorageData.readString(GetStorageData.token);

      final response = await _apiService.getRequest(
        ApiConstant.isUserIsAdmin,
        headers: {
          "Authorization": "Bearer $loginToken",
        },
      );

      print("Admin Response : ${response.data}");

      if (response.data["statusCode"] == 200 &&
          response.data["data"] != null) {

        bool isAdmin = response.data["data"] == true;
        if (isAdmin) {
          setRole("Admin");
          Get.offAllNamed(AppRoutes.dashboardScreen);
          print('isAdmin:: if---- ${response.data}');

        } else {
          setRole("Employee");
          Get.offAllNamed(AppRoutes.employeeHomeScreen);
          print('isAdmin:: else---- ${response.data}');

        }
        update();
      }
      else {
        Utils().showToast(
          context: Get.context!,
          title: "Error",
          message: response.data["responseMsg"] ?? "Something went wrong",
          isSuccess: false,
        );
      }
    } catch (e) {
      Utils().showToast(
        context: Get.context!,
        title: "Error",
        message: e.toString(),
        isSuccess: false,
      );
    }
  }

  Future<void> apiCallGetCompanyList() async {
    code = "YZ9645";
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
    final companyList = CompanyListModel.fromJson(response.data);
    if (companyList.statusCode == 200) {
      GetStorageData.saveString(GetStorageData.companyCode, code);
      companyData = companyList.data??[];
      update();
    }
  }

  Future<void> apiSelectCompany() async {
    try {
      final response = await _apiService.getRequest(ApiConstant.selectCompany);
      print("Select Company token-----${response.data}");
      final selectComapny = SelectCompanyModel.fromJson(response.data);
      if (response.statusCode == 200) {
        await GetStorageData.saveString(
            GetStorageData.token, selectComapny.data!.token);
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

  void setRole(String role) {
    GetStorageData.saveBoolean(GetStorageData.isAdmin, false);
    GetStorageData.saveBoolean(GetStorageData.isCustomer, false);
    GetStorageData.saveBoolean(GetStorageData.isEmployee, false);

    if (role == "Admin") {
      GetStorageData.saveBoolean(GetStorageData.isAdmin, true);
    } else if (role == "Customer") {
      GetStorageData.saveBoolean(GetStorageData.isCustomer, true);
    } else if (role == "Employee") {
      GetStorageData.saveBoolean(GetStorageData.isEmployee, true);
    }
    GetStorageData.saveString(GetStorageData.role, role);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }

}