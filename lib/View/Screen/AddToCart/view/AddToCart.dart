import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/AddToCart/Controller/AddToCartController.dart';
import 'package:saral/View/Screen/AddToCart/view/AddToCartBottomBar.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class AddToCart extends StatelessWidget {
  AddToCart({super.key});
  AddToCartController addToCartController = Get.put(AddToCartController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: CommonAppBar(
          title: "My Cart",
          showBackButton: true,
          // showDrawer: true,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 12),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                  onPressed: () {
                    addToCartController.clearCart();
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: AddToCartBottomBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListView.builder(
            itemCount: 9,
            shrinkWrap: true,
            itemBuilder: (context,index){
            return Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        AppImages.Img2,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CommonText(
                                text: "Premium T Shirt",
                                fontFamily: FontFamily.poppinsSemiBold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        CommonText(
                          text: "Cotton Fabric",
                          fontFamily: FontFamily.poppinsMedium,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  color: AppColors.btnColors,
                                  size: 17,
                                ),
                                CommonText(
                                  text: "3272",
                                  fontFamily: FontFamily.poppinsBold,
                                  fontSize: 15,
                                  color: AppColors.btnColors,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: addToCartController.decrement,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Obx(
                                        () => Text(
                                      addToCartController.quantity.value
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  InkWell(
                                    onTap: addToCartController.increment,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        color: AppColors.btnColors,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),

      ),
    );
  }
}
