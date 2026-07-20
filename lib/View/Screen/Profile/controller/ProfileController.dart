import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Screen/Profile/Model/profile_model.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  final profileKey = GlobalKey<FormState>();

  var profile = Rxn<ProfileModel>();
  final RxBool isLoading = false.obs;
  bool _isFetching = false;

  bool get isAdmin => GetStorageData.readBoolean(GetStorageData.isAdmin);
  bool get isCustomer => GetStorageData.readBoolean(GetStorageData.isCustomer);
  bool get isEmployee => GetStorageData.readBoolean(GetStorageData.isEmployee);

  bool get hasProfileData {
    final data = profile.value?.data;
    if (data != null) return true;
    return nameController.text.trim().isNotEmpty ||
        emailController.text.trim().isNotEmpty ||
        contactController.text.trim().isNotEmpty;
  }

  @override
  void onReady() {
    super.onReady();
    // Don't fetch during Dashboard constructor — wait until frame is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProfile();
    });
  }

  @override
  void onClose() {
    CommonLoader.hide();
    super.onClose();
  }

  Future<void> loadProfile({bool force = false}) async {
    if (_isFetching) return;
    if (!force && hasProfileData) return;

    if (isCustomer) {
      await apiCallGetCustomerProfile();
    } else if (isAdmin || isEmployee) {
      _loadStaffProfile();
    } else {
      // Role flags missing — still try customer API if loginToken exists
      final token = GetStorageData.readString(GetStorageData.token);
      if (token != null && token.toString().isNotEmpty) {
        await apiCallGetCustomerProfile();
      }
    }
  }

  void _loadStaffProfile() {
    final storedName =
        GetStorageData.readString(GetStorageData.userName)?.toString() ?? '';
    final role = GetStorageData.readRole();

    nameController.text = storedName.isNotEmpty ? storedName : role;
    emailController.text = role;
    contactController.text = '-';

    profile.value = ProfileModel(
      statusCode: 200,
      responseMsg: 'OK',
      data: ProfileData(
        customerName: nameController.text,
        email: emailController.text,
        contact1: contactController.text,
      ),
    );
    update();
  }

  Future<void> apiCallGetCustomerProfile() async {
    if (_isFetching) return;
    _isFetching = true;

    try {
      isLoading.value = true;

      final ctx = Get.overlayContext ?? Get.context;
      if (ctx != null && ctx.mounted) {
        CommonLoader.show(ctx);
        await Future.delayed(const Duration(milliseconds: 50));
      }

      final token =
          GetStorageData.readString(GetStorageData.token)?.toString() ??
              '';

      if (token.isEmpty) {
        debugPrint('Profile: empty loginToken');
        return;
      }

      final response = await _apiService.getRequest(
        '${ApiConstant.baseurl}/Customer/GetCustomerProfile',
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Customer Profile Response: ${response.data}');

      final model = ProfileModel.fromJson(
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{},
      );

      final ok = response.statusCode == 200 &&
          (model.statusCode == null || model.statusCode == 200);

      if (ok && model.data != null) {
        profile.value = model;
        nameController.text = model.data?.customerName ?? '';
        emailController.text = model.data?.email ?? '';
        contactController.text = model.data?.contact1 ?? '';
        addressController.text = model.data?.address1 ?? '';
        areaController.text = model.data?.area ?? '';
        stateController.text = model.data?.state ?? '';
        zipcodeController.text = model.data?.zipcode ?? '';

        // Fallback contact from login mobile
        if (contactController.text.trim().isEmpty) {
          contactController.text =
              GetStorageData.readString(GetStorageData.customerMobile)
                      ?.toString() ??
                  '';
        }
        update();
      } else {
        // Keep mobile fallback so screen isn't blank
        final mobile =
            GetStorageData.readString(GetStorageData.customerMobile)
                    ?.toString() ??
                '';
        if (mobile.isNotEmpty) {
          contactController.text = mobile;
          profile.value = ProfileModel(
            statusCode: 200,
            data: ProfileData(contact1: mobile),
          );
          update();
        }
        debugPrint(
            'Profile API empty/failed: status=${response.statusCode} bodyStatus=${model.statusCode}');
      }
    } catch (e) {
      debugPrint('Profile Exception: $e');
      final mobile =
          GetStorageData.readString(GetStorageData.customerMobile)
                  ?.toString() ??
              '';
      if (mobile.isNotEmpty) {
        contactController.text = mobile;
        profile.value = ProfileModel(
          statusCode: 200,
          data: ProfileData(contact1: mobile),
        );
        update();
      } else if (Get.context != null) {
        Utils().showToast(
          message: 'Error fetching profile',
          context: Get.context!,
          title: 'Error',
          isSuccess: false,
        );
      }
    } finally {
      _isFetching = false;
      isLoading.value = false;
      CommonLoader.hide();
    }
  }

  Future<void> apiCallDeleteCustomer({
    required BuildContext context,
  }) async {
    try {
      CommonLoader.show(context);

      String token = '';
      if (GetStorageData.containKey(GetStorageData.token)) {
        token =
            GetStorageData.readString(GetStorageData.token)?.toString() ??
                '';
      }

      if (token.isEmpty) {
        CommonLoader.hide();
        Utils().showToast(
          context: context,
          title: 'Error',
          message: 'User not logged in',
          isSuccess: false,
        );
        return;
      }

      final response = await _apiService.getRequest(
        ApiConstant.deleteCustomer,
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
        },
      );

      CommonLoader.hide();
      debugPrint('DELETE RESPONSE: ${response.data}');

      final data = response.data;
      final bool ok = response.statusCode == 200 &&
          (data['statusCode'] == 200 ||
              data['IsSuccess'] == true ||
              data['responseMsg']
                      ?.toString()
                      .toLowerCase()
                      .contains('success') ==
                  true);

      if (ok) {
        Utils().showToast(
          context: context,
          title: 'Success',
          message: data['responseMsg']?.toString() ??
              data['message']?.toString() ??
              'Account deleted successfully',
          isSuccess: true,
        );

        await GetStorageData.removeData(GetStorageData.token);
        // await GetStorageData.removeData(GetStorageData.token);
        await GetStorageData.removeData(GetStorageData.role);
        await GetStorageData.removeData(GetStorageData.userName);
        await GetStorageData.removeData(GetStorageData.customerMobile);
        await GetStorageData.removeData(GetStorageData.isOtpVerified);
        await GetStorageData.saveBoolean(GetStorageData.isAdmin, false);
        await GetStorageData.saveBoolean(GetStorageData.isCustomer, false);
        await GetStorageData.saveBoolean(GetStorageData.isEmployee, false);

        Get.offAllNamed(AppRoutes.loginScreen);
      } else {
        Utils().showToast(
          context: context,
          title: 'Error',
          message: data['responseMsg']?.toString() ??
              data['message']?.toString() ??
              'Unable to delete account',
          isSuccess: false,
        );
      }
    } catch (e) {
      CommonLoader.hide();
      debugPrint('Delete Account Error: $e');
      Utils().showToast(
        context: context,
        title: 'Error',
        message: 'Unable to delete account',
        isSuccess: false,
      );
    }
  }
}
