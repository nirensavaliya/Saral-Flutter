import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/ProductDetail/view/FlyToCartAnimation.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';

class ProductDetailView extends StatefulWidget {
  ItemListData? itemListModelData;
  ProductDetailView({super.key, this.itemListModelData});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  ProductDetailController productDetailController = Get.put(
    ProductDetailController(),
  );
  HomeController homeController = Get.put(HomeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.itemListModelData = Get.arguments;

    print(widget.itemListModelData?.discount);
    print(widget.itemListModelData?.purchaseVATamt);
    print(widget.itemListModelData?.finalCost);
    print(widget.itemListModelData?.purchasePrice);
    print(widget.itemListModelData?.stockQty);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: CommonAppBar(
          title: "Product Detail",
          showBackButton: true,
          actions: [
            Obx(
              () => ScaleTransition(
                scale: productDetailController.bounceAnimation,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        key: productDetailController.cartKey,
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          Get.toNamed(AppRoutes.addToCartScreen);
                        },
                      ),

                      if (productDetailController.cartCount.value > 0)
                        Positioned(
                          right: 0,
                          top: 2,
                          child: Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              productDetailController.cartCount.value
                                  .toString(),
                              style: const TextStyle(
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
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.network(
                            widget.itemListModelData?.itemImage ?? "",
                            key: productDetailController.imageKey,
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print(error);
                              return Icon(Icons.image, size: 100);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 18,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                  text:
                                      widget.itemListModelData?.itemName ??
                                      "--",
                                  fontFamily: FontFamily.poppinsBold,
                                  fontSize: 20,
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      text: "Item Code:",
                                      fontFamily: FontFamily.poppinsRegular,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    CommonText(
                                      text:
                                          widget.itemListModelData?.itemCode ??
                                          "--",
                                      fontFamily: FontFamily.poppinsRegular,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CommonText(
                                      text: "Unit Code:",
                                      fontFamily: FontFamily.poppinsRegular,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    CommonText(
                                      text: widget.itemListModelData?.unitCode ?? "--",
                                      fontFamily: FontFamily.poppinsRegular,
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Basic Price: ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text: widget.itemListModelData?.finalCost?.toString() ?? "",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Purchase Price: ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text: widget.itemListModelData?.purchasePrice?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Purchase VAT AMT: ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text: widget.itemListModelData?.purchaseVATamt?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Discount: ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.discount?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Item Value: ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.price?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Stock Qty ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.stockQty?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Brand Name ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.brandName?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Category ",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.name?.toString() ?? "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          // Container(
                          //   decoration: BoxDecoration(),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: productDetailController.decrement,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: Colors.grey.shade200,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(Icons.remove, size: 18),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           horizontal: 12,
                          //         ),
                          //         child: Obx(
                          //           () => CommonText(
                          //             text: productDetailController
                          //                 .quantity
                          //                 .value
                          //                 .toString(),
                          //             fontFamily: FontFamily.poppinsBold,
                          //             fontSize: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       GestureDetector(
                          //         onTap: productDetailController.increment,
                          //         child: Container(
                          //           height: 27,
                          //           width: 27,
                          //           decoration: BoxDecoration(
                          //             color: AppColors.btnColors,
                          //             shape: BoxShape.circle,
                          //           ),
                          //           child: const Icon(
                          //             Icons.add,
                          //             color: Colors.white,
                          //             size: 18,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "SubCategory Name",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.subCategory?.toString() ??
                                "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                            text: "Barcode No.",
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          CommonText(
                            text:
                                widget.itemListModelData?.defaultBarcodeNo?.toString() ??
                                "-",
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: AppColors.btnColors,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  // await FlyToCartAnimator.fly(
                                  //   context: context,
                                  //   startKey: productDetailController.imageKey,
                                  //   cartKey: productDetailController.cartKey,
                                  //   imageUrl: AppImages.Img2,
                                  //   onComplete: () {
                                  //     productDetailController.animateCart();
                                  //   },
                                  // );
                                  Get.back();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icon(
                                    //   Icons.shopping_bag,
                                    //   color: Colors.white,
                                    // ),
                                    // SizedBox(width: 10),
                                    CommonText(
                                      text: "Close",
                                      fontFamily: FontFamily.poppinsSemiBold,
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget brandItem(String image) {
    return Container(
      height: 80,
      width: 78,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 6),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }

  Widget featureItem(IconData icon, String title) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 28, color: AppColors.btnColors),

          const SizedBox(height: 10),

          CommonText(
            text: title,
            textAlign: TextAlign.center,
            fontFamily: FontFamily.poppinsMedium,
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  Widget featureDivider() {
    return Container(width: 1, height: 50, color: Colors.grey.shade300);
  }
}
