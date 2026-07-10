import 'package:flutter/material.dart';

class Global {
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// Appends [customerId] as a query parameter to API paths.

  static String withCustomerId(String path, int customerId) {
  final sep = path.contains('?') ? '&' : '?';
  return '$path${sep}customerId=$customerId';
  
  }
}