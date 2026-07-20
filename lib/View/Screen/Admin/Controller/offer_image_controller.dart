import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saral/Data/Constant/api_constant.dart';

import '../../../../Common/Get_Storage.dart';
import '../../../../Common/Tost.dart';
import '../../../../Data/Constant/Api_Service.dart';
import '../../login/model/is_admin_model.dart';

class OfferImageController extends GetxController {
  var selectedImage = Rx<File?>(null);
  var descriptionController = TextEditingController();
  final RxBool isPickingCamera = false.obs;
  final RxBool isPickingGallery = false.obs;
  final ApiService _apiService = ApiService();
  String get companyToken =>
      GetStorageData.readString(GetStorageData.token) ?? "";

  final ImagePicker _picker = ImagePicker();

  Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;

    status = await Permission.camera.request();
    if (status.isGranted) {
      // Let OS settle after first grant before opening camera.
      await Future.delayed(const Duration(milliseconds: 250));
      return true;
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> _ensureGalleryPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isGranted || status.isLimited) return true;

      status = await Permission.photos.request();
      if (status.isGranted || status.isLimited) {
        await Future.delayed(const Duration(milliseconds: 250));
        return true;
      }
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    // Android 13+: photos. Older: storage fallback.
    var photos = await Permission.photos.status;
    if (photos.isGranted) return true;

    if (!photos.isGranted && !photos.isPermanentlyDenied) {
      photos = await Permission.photos.request();
      if (photos.isGranted) {
        await Future.delayed(const Duration(milliseconds: 250));
        return true;
      }
    }

    var storage = await Permission.storage.status;
    if (storage.isGranted) return true;

    if (!storage.isGranted && !storage.isPermanentlyDenied) {
      storage = await Permission.storage.request();
      if (storage.isGranted) {
        await Future.delayed(const Duration(milliseconds: 250));
        return true;
      }
    }

    if (photos.isPermanentlyDenied || storage.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  void _showError(String message) {
    if (Get.context == null) return;
    Utils().showToast(
      context: Get.context!,
      title: "Error",
      message: message,
      isSuccess: false,
    );
  }

  Future<void> pickImageFromCamera() async {
    if (isPickingCamera.value || isPickingGallery.value) return;
    isPickingCamera.value = true;
    try {
      final ok = await _ensureCameraPermission();
      if (!ok) {
        _showError("Camera permission required");
        return;
      }
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        update();
      }
    } catch (e) {
      debugPrint("Camera error: $e");
      _showError("Unable to open camera");
    } finally {
      isPickingCamera.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    if (isPickingCamera.value || isPickingGallery.value) return;
    isPickingGallery.value = true;
    try {
      final ok = await _ensureGalleryPermission();
      if (!ok) {
        _showError("Gallery permission required");
        return;
      }
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
        update();
      }
    } catch (e) {
      debugPrint("Gallery error: $e");
      _showError("Unable to open gallery");
    } finally {
      isPickingGallery.value = false;
    }
  }

  Future<String?> convertImageToBase64(File? imageFile) async {
    if (imageFile == null) return null;
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> saveData() async {
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    if (selectedImage.value != null) {
      String? base64String = await convertImageToBase64(selectedImage.value);

      if (base64String != null && base64String.isNotEmpty) {
        print("Base64 String::: $base64String");
        await apiCallOrderFromImage(Get.context!, base64String);
      } else {
        print("Error: Could not convert image to Base64.");
      }
    } else {
      print("Error: No image selected.");
    }
  }

  Future<void> apiCallOrderFromImage(
      BuildContext context, String base64string) async {
    var dataRaw = json.encode({
      "imageBase64string": base64string.toString(),
    });

    final response = await _apiService.postRequest(
      ApiConstant.saveOfferImage,
      data: dataRaw,
      headers: {"Authorization": "Bearer $companyToken"},
    );

    print('statusCode:::: ---- --- ${response.statusCode}');
    if (response.statusCode == 200) {
      IsAdminModel model = IsAdminModel.fromJson(response.data);
      Utils().showToast(
        message: "Image Save Successfully!",
        context: context,
        title: 'Success',
      );
      Get.back();
      update();
    }
  }
}
