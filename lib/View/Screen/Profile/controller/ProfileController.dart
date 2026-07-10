import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController contactController=TextEditingController();
  final profileKey = GlobalKey<FormState>();

}