import 'dart:convert';

import 'package:get_storage/get_storage.dart';



class GetStorageData{
  // static String loginToken = "loginToken";
  static String token = "token";
  static String isAdmin = "IsAdmin";
  static String isCustomer = "IsCustomer";
  static String role = "role";
  static String isEmployee = "IsEmployee";
  static String companyCode = "CompanyCode";
  static String companyToken = "companyToken";
  static String isOtpVerified = "isOtpVerified";
  static String userName = "userName";
  static String customerMobile = "customerMobile";

  /// <<< To save object data --------- >>>
  static saveString(String key, value) async {
    final box = GetStorage();
    return box.write(key, value);
  }

  /// <<< To read object data --------- >>>
  static readString(String key) {
    final box = GetStorage();
    if (box.hasData(key)) {
      return box.read(key);
    } else {
      return null;
    }
  }

  /// <<< To save boolean data --------- >>>
  static Future<void> saveBoolean(String key, bool value) async {
    final box = GetStorage();
    return box.write(key, value);
  }

  /// <<< To read boolean data --------- >>>
  static bool readBoolean(String key) {
    final box = GetStorage();
    return box.read<bool>(key) ?? false;
  }

  /// <<< To remove data --------- >>>
  static removeData(String key) async {
    final box = GetStorage();
    return box.remove(key);
  }

  static void setRole(String roleValue) {
    final box = GetStorage();
    box.write(role, roleValue);
  }

  static String readRole() {
    final box = GetStorage();
    return box.read(role) ?? "Unknown";
  }

  /// <<< To Store Key data --------- >>>
  static bool containKey(String key) {
    final box = GetStorage();
    return box.hasData(key);
  }

  static Future<void> saveObject(String key, value) async {
    final box = GetStorage();
    String allData = jsonEncode(value);
    await box.write(key, allData);
  }

  static readObject(String key) {
    final box = GetStorage();
    var result = box.read(key);
    return jsonDecode(result);
  }

}
