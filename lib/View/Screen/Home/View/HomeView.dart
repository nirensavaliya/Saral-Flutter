import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_Images.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/Home/Controller/HomeController.dart';
import 'package:saral/View/Screen/Home/Model/GetReportItemListModel.dart';
import 'package:saral/View/Screen/Home/Model/categoryListModel.dart';
import 'package:saral/View/Screen/Sidemenu/Sidemenu.dart';
import 'package:saral/View/Utils/App_Routes.dart';
import 'package:saral/View/Widget/Common_AppBar.dart';
import 'package:saral/View/Widget/Common_Text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController dashBoardController = Get.find<HomeController>();
  final List<String> images = [
    AppImages.Img1,
    AppImages.Img2,
    AppImages.Img3,
    AppImages.Img1,
    AppImages.Img1,
    AppImages.Img2,
  ];

  final List<String> titles = [
    "Item 1",
    "Item 2",
    "Item 3",
    "Item 4",
    "Item 5",
    "Item 6",
  ];
  final List<Map<String, String>> brands = [
    {"name": "ALL", "image": ""},
    {
      "name": "Nike",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg",
    },
    {
      "name": "Adidas",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg",
    },
    {
      "name": "Puma",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/f/fd/Puma_logo.svg",
    },
    {
      "name": "Reebok",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/0/0c/Reebok_2019_logo.svg",
    },
  ];
  String? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "SARAL", showDrawer: true),
      drawer: SideMenu(),
      body: GetBuilder<HomeController>(
       builder: (dashBoardController){
         return Padding(
           padding: EdgeInsets.only(top: 25, left: 15, right: 15, bottom: 15),
           child: Column(
             children: [
               CarouselSlider.builder(
                 itemCount: dashBoardController.sliderImages.length,
                 carouselController: dashBoardController.carouselController,
                 itemBuilder: (context, index, realIndex) {
                   return Padding(
                     padding: EdgeInsets.symmetric(horizontal: 6),
                     child: ClipRRect(
                       borderRadius: BorderRadius.circular(12),
                       child: Image.asset(
                         dashBoardController.sliderImages[index],
                         width: double.infinity,
                         fit: BoxFit.cover,
                       ),
                     ),
                   );
                 },
                 options: CarouselOptions(
                   height: 180,
                   viewportFraction: 0.9,
                   enlargeCenterPage: false,
                   autoPlay: true,
                   autoPlayInterval: const Duration(seconds: 3),
                   onPageChanged: (index, reason) {
                     dashBoardController.onPageChanged(index);
                   },
                 ),
               ),
               SizedBox(height: 12),
               Obx(
                     () => AnimatedSmoothIndicator(
                   activeIndex: dashBoardController.activeIndex.value,
                   count: dashBoardController.sliderImages.length,
                   effect: ExpandingDotsEffect(
                     dotHeight: 8,
                     dotWidth: 8,
                     expansionFactor: 4,
                     activeDotColor: Color(0xffdd2b1c),
                     dotColor: Colors.grey.shade400,
                   ),
                 ),
               ),
               SizedBox(height: 12),
               Obx(
                     () => DropdownButtonFormField<CategoryListData>(
                   value: dashBoardController.selectedCategory.value,
                   isExpanded: true,
                   decoration: InputDecoration(
                     hintText: "Select Category",
                     contentPadding: EdgeInsets.symmetric(
                       horizontal: 12,
                       vertical: 14,
                     ),
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(10),
                     ),
                   ),

                   hint: Text("Select Category"),
                   icon: Icon(Icons.keyboard_arrow_down),
                   items: dashBoardController.categoryListData.map((item) {
                     return DropdownMenuItem<CategoryListData>(
                       value: item,
                       child: Row(
                         children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(15),
                             child: Image.network(
                               item.imageUrl ?? "",
                               width: 30,
                               height: 30,
                               fit: BoxFit.cover,
                               errorBuilder: (_, __, ___) => const Icon(
                                 Icons.image_not_supported,
                                 size: 30,
                               ),
                             ),
                           ),
                           const SizedBox(width: 10),
                           Expanded(
                             child: Text(
                               item.categoryName ?? "",
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),
                         ],
                       ),
                     );
                   }).toList(),
                   onChanged: (value) {
                     dashBoardController.onCategoryChanged(value);
                   },
                 ),
               ),
               SizedBox(height: 10),
               Expanded(
                 child: Obx(() {
                   if (dashBoardController.isLoadingMore.value && dashBoardController.isItemList.value) {
                     return Center(
                       child: LoadingAnimationWidget.threeArchedCircle(
                         color: AppColors.btnColors,
                         size: 50,
                       ),
                     );
                   }
                   var data = dashBoardController.itemList;
                   if (data.isEmpty) {
                     return Center(
                       child: CommonText(
                         text: "No Product Found",
                         fontFamily: FontFamily.poppinsBold,
                       ),
                     );
                   }

                   return GridView.builder(
                     shrinkWrap: true,
                     controller: dashBoardController.scrollController,
                     // physics: const NeverScrollableScrollPhysics(),
                     itemCount: data.length +
                         (dashBoardController.isLoadingMore.value ? 1 : 0),
                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 2,
                       crossAxisSpacing: 15,
                       mainAxisSpacing: 15,
                       childAspectRatio: 0.68,
                     ),
                     itemBuilder: (context, index) {
                       if (index == data.length) {
                         return Center(
                           child: LoadingAnimationWidget.threeArchedCircle(
                             color: AppColors.btnColors,
                             size: 50,
                           ),
                         );
                       }
                       final model = data[index];
                       return GestureDetector(
                         onTap: () {
                           print(model.toJson());
                           Get.toNamed(
                             AppRoutes.productDetailViewScreen,
                             arguments: model,
                           );
                         },
                         child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(10),
                             boxShadow: [
                               BoxShadow(
                                 blurRadius: 4,
                                 color: Colors.black12,
                               ),
                             ],
                           ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(8),
                                   child: Image.network(
                                     model.itemImage ?? "",
                                     width: double.infinity,
                                     fit: BoxFit.cover,
                                     errorBuilder: (_, __, ___) => const Center(
                                       child: Icon(Icons.image_not_supported),
                                     ),
                                   ),
                                 ),
                               ),
                               const SizedBox(height: 8),
                               CommonText(
                                 text: model.itemName ?? "",
                                 fontFamily: FontFamily.poppinsBold,
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                               const SizedBox(height: 5),
                               CommonText(
                                 text: "₹ ${model.price ?? 0}",
                                 fontFamily: FontFamily.poppinsRegular,
                               ),
                             ],
                           ),
                         ),
                       );
                     },
                   );
                 }),
               ),
             ],
           ),
         );
       }
      ),
    );
  }

  Widget buildProductCard(GetReportItemListModel item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.productDetailViewScreen, arguments: item);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.data?.first.itemImage ?? "",
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    height: 120,
                    child: Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            CommonText(
              text: item.data?.first.imageFileName ?? "",
              fontFamily: FontFamily.poppinsBold,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            CommonText(
              text: "₹ ${item.data?.first.price?.toString() ?? "0.00"}",
              fontFamily: FontFamily.poppinsRegular,
            ),
          ],
        ),
      ),
    );
  }
}
