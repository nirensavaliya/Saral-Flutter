
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController{
  int selectedCategory = 0;

  void changeCategory(int index) {
    selectedCategory = index;
    update();
  }

  TextEditingController searchController=TextEditingController();
}