import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saral/Common/App_Loader.dart';
import 'package:saral/Common/Get_Storage.dart';
import 'package:saral/Common/Tost.dart';
import 'package:saral/Data/Constant/Api_Service.dart';
import 'package:saral/Data/Constant/api_constant.dart';
import 'package:saral/View/Screen/Admin/Model/team_member_model.dart';

class TeamMemberController extends GetxController {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  final RxList<TeamMemberData> members = <TeamMemberData>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxBool isPickingCamera = false.obs;
  final RxBool isPickingGallery = false.obs;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final selectedImage = Rx<File?>(null);
  final existingImage = ''.obs;
  TeamMemberData? editingMember;

  String get _token => GetStorageData.readString(GetStorageData.token) ?? '';

  @override
  void onReady() {
    super.onReady();
    fetchMembers();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void prepareForm({TeamMemberData? member}) {
    editingMember = member;
    nameController.text = member?.name ?? '';
    descriptionController.text = member?.description ?? '';
    selectedImage.value = null;
    existingImage.value = member?.displayImage ?? '';
  }

  bool get isEdit => editingMember?.id != null;

  Future<void> fetchMembers() async {
    isLoading.value = true;
    try {
      final response = await _apiService.getRequest(
        ApiConstant.getTeamMembers,
        headers: {
          "Authorization": "Bearer $_token",
          "accept": "*/*",
        },
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final model = TeamMemberListModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        members.value = model.data ?? [];
      } else {
        members.clear();
      }
    } catch (e) {
      log('fetchMembers error: $e');
      members.clear();
      _toast("Unable to load team members", success: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _ensureCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) return true;
    status = await Permission.camera.request();
    if (status.isGranted) {
      await Future.delayed(const Duration(milliseconds: 250));
      return true;
    }
    if (status.isPermanentlyDenied) await openAppSettings();
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
      if (status.isPermanentlyDenied) await openAppSettings();
      return false;
    }

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

  Future<void> pickImageFromCamera() async {
    if (isPickingCamera.value || isPickingGallery.value) return;
    isPickingCamera.value = true;
    try {
      if (!await _ensureCameraPermission()) {
        _toast("Camera permission required", success: false);
        return;
      }
      final picked = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      log('pickImageFromCamera: $e');
      _toast("Unable to open camera", success: false);
    } finally {
      isPickingCamera.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    if (isPickingCamera.value || isPickingGallery.value) return;
    isPickingGallery.value = true;
    try {
      if (!await _ensureGalleryPermission()) {
        _toast("Gallery permission required", success: false);
        return;
      }
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1200,
      );
      if (picked != null) selectedImage.value = File(picked.path);
    } catch (e) {
      log('pickImageFromGallery: $e');
      _toast("Unable to open gallery", success: false);
    } finally {
      isPickingGallery.value = false;
    }
  }

  Future<void> saveMember() async {
    final name = nameController.text.trim();
    final description = descriptionController.text.trim();
    if (name.isEmpty) {
      _toast("Please enter name", success: false);
      return;
    }
    if (!isEdit && selectedImage.value == null) {
      _toast("Please select an image", success: false);
      return;
    }

    String imageBase64 = '';
    if (selectedImage.value != null) {
      imageBase64 = base64Encode(await selectedImage.value!.readAsBytes());
    }

    isSaving.value = true;
    final ctx = Get.context;
    if (ctx != null) CommonLoader.show(ctx);
    try {
      final body = <String, dynamic>{
        "name": name,
        "description": description,
        "imageBase64string": imageBase64,
      };
      if (editingMember?.id != null) {
        body["id"] = editingMember!.id;
      }

      final response = await _apiService.postRequest(
        ApiConstant.saveTeamMember,
        data: json.encode(body),
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "application/json",
          "accept": "*/*",
        },
      );

      if (response.statusCode == 200) {
        _toast(
          isEdit ? "Team member updated" : "Team member added",
        );
        await fetchMembers();
        Get.back();
      } else {
        final msg = _responseMessage(response.data) ?? "Unable to save member";
        _toast(msg, success: false);
      }
    } catch (e) {
      log('saveMember error: $e');
      _toast("Unable to save member", success: false);
    } finally {
      CommonLoader.hide();
      isSaving.value = false;
    }
  }

  Future<void> deleteMember(TeamMemberData member) async {
    final id = member.id;
    if (id == null) {
      _toast("Member id not found", success: false);
      return;
    }
    final ctx = Get.context;
    if (ctx != null) CommonLoader.show(ctx);
    try {
      final response = await _apiService.putRequest(
        ApiConstant.deleteTeamMember(id),
        headers: {
          "Authorization": "Bearer $_token",
          "accept": "*/*",
        },
      );
      if (response.statusCode == 200) {
        members.removeWhere((e) => e.id == id);
        _toast("Team member deleted");
      } else {
        final msg = _responseMessage(response.data) ?? "Unable to delete member";
        _toast(msg, success: false);
      }
    } catch (e) {
      log('deleteMember error: $e');
      _toast("Unable to delete member", success: false);
    } finally {
      CommonLoader.hide();
    }
  }

  String? _responseMessage(dynamic data) {
    if (data is Map) {
      return data['responseMsg']?.toString() ?? data['message']?.toString();
    }
    return null;
  }

  void _toast(String message, {bool success = true}) {
    final ctx = Get.context;
    if (ctx == null) return;
    Utils().showToast(
      context: ctx,
      title: success ? "Success" : "Error",
      message: message,
      isSuccess: success,
    );
  }
}
