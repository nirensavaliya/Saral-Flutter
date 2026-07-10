import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Product/Controller/productController.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Screen/ProductDetail/view/FlyToCartAnimation.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:saral/View/Widget/common_button.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final List<String> categories = [
    "All",
    "Men",
    "Women",
    "Kids",
    "Shoes",
    "Sports",
    "Casual",
  ];
  ProductController productController = Get.put(ProductController());
  ProductDetailController productDetailController = Get.put(ProductDetailController());
  final List<String> images = [
    AppImages.Img1,
    AppImages.Img2,
    AppImages.Img3,
    AppImages.Img1,
    AppImages.Img1,
    AppImages.Img2,
  ];
  final cartKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Product",
        showDrawer: true,
        actions: [
          Obx(
            () => ScaleTransition(
              scale: productDetailController.bounceAnimation,
              child: Stack(
                children: [
                  IconButton(
                    key: cartKey,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.offNamed(AppRoutes.addToCartScreen);
                    },
                  ),

                  if (productDetailController.cartCount.value > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          productDetailController.cartCount.value.toString(),
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: productController.searchController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Search Products",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.tune),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xffED1C24),
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            SizedBox(
              height: 50,
              child: GetBuilder<ProductController>(
                builder: (controller) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      bool isSelected = controller.selectedCategory == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            controller.changeCategory(index);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.btnColors
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.btnColors
                                    : Colors.black,
                              ),
                            ),
                            child: Text(
                              categories[index],
                              style: TextStyle(
                                fontFamily: FontFamily.poppinsSemiBold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(10, 15, 0, 100),
                itemCount: images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemBuilder: (context, index) {
                  final imagKey = GlobalKey();
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.productDetailViewScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.asset(
                                    images[index],
                                    key: imagKey,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    height: 36,
                                    width: 36,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text: "Nordic Lounge Chair",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: FontFamily.poppinsBold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                                SizedBox(height: 4),
                                CommonText(
                                  text: "\$429",
                                  color: AppColors.btnColors,
                                  fontFamily: FontFamily.poppinsBold,
                                  fontSize: 18,
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                  // width: 90,
                                  height: 35,
                                  child: CommonButton(
                                    btnName: "Add to Cart",
                                    onTap: () async {
                                      await FlyToCartAnimator.fly(
                                        context: context,
                                        startKey: imagKey,
                                        cartKey: cartKey,
                                        imageUrl: AppImages.Img2,
                                        onComplete: () {
                                          productDetailController.animateCart();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
