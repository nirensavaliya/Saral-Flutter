import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Profile/controller/ProfileController.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';
import 'package:saral/View/Widget/common_textfild.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  ProfileController profileController=Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CommonAppBar(title: "Profile",showDrawer: true),
      body:SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 15,horizontal: 18),
          child: Form(
            key: profileController.profileKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Column(
                     children: [
                       Stack(
                         clipBehavior: Clip.none,
                         children: [
                           CircleAvatar(
                             radius: 50,
                             backgroundColor: Colors.grey[300],
                             child: Icon(
                               Icons.person,
                               size: 50,
                               color: Colors.white,
                             ),
                           ),
        
                           Positioned(
                             bottom: 0,
                             right: 0,
                             child: GestureDetector(
                               onTap: () {
        
                               },
                               child: Container(
                                 padding: const EdgeInsets.all(6),
                                 decoration: BoxDecoration(
                                   color: AppColors.btnColors,
                                   shape: BoxShape.circle,
                                   border: Border.all(
                                     color: Colors.white,
                                     width: 2,
                                   ),
                                 ),
                                 child: const Icon(
                                   Icons.edit,
                                   color: Colors.white,
                                   size: 18,
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 8,),
                       CommonText(text: "Alex Gilles", fontFamily: FontFamily.poppinsMedium,fontSize: 16,)
                     ],
                   )
                  ],
                ),
                SizedBox(height: 20,),
                CommonTextField(
                  isTitle: true,
                  title: "Name",
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.text,
                  prefix: Icon(Icons.person),
                  hintText: "John",
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Name is required.";
                    }
                    return null;
                  },
                  controller: profileController.nameController
                ),
                SizedBox(height: 15,),
                CommonTextField(
                    isTitle: true,
                    title: "Email",
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.text,
                  prefix: Icon(Icons.email),
                    hintText: "abz@gmail.com",
        
                    textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required.";
                    }
                    return null;
                  },
                  controller: profileController.emailController
                ),
                SizedBox(height: 15,),
                CommonTextField(
                    isTitle: true,
                    title: "Number",
                  textCapitalization: TextCapitalization.words,
                  textInputType: TextInputType.text,
                  prefix: Icon(Icons.call),
                  hintText: "+91 465845788",
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Contact is required.";
                    }
                    return null;
                  },
                  controller: profileController.contactController
                ),
                SizedBox(height: 30,),
                CommonButton(
                  btnName: "Submit",
                  onTap: (){
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
