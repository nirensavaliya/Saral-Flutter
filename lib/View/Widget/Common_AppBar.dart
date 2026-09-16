import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';

import '../Screen/AddToCart/Controller/AddToCartController.dart';
import '../Utils/App_Routes.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final bool showBackButton;
  final bool showCartButton;
  final bool showDrawer;
  final bool showCart;
  final bool clearAll;
  final VoidCallback? onBack;
  final VoidCallback? onCartTap;
  final VoidCallback? onClearAll;
  final List<Widget>? actions;
  final int cartCount;

  CommonAppBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.showBackButton = true,
    this.showCartButton = false,
    this.showDrawer = false,
    this.showCart = false,
    this.clearAll = false,
    this.onBack,
    this.onCartTap,
    this.onClearAll,
    this.actions,
    this.cartCount = 0,
  });


  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Stack(
        children: [
          ClipPath(
            clipper: AppBarCurveClipper(),
            child: Container(height: 120, color: AppColors.brandRed),
          ),

          SafeArea(
            child: SizedBox(
              height: kToolbarHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      if (showDrawer)
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                        )
                      else if (showBackButton)
                         Material(
                         color: Colors.white.withValues(alpha: 0.18),
                         shape: const CircleBorder(),
                         child: InkWell(
                         customBorder: const CircleBorder(),
                         onTap: () {
                            if (onBack != null) {
                            onBack!();
                            } else {
                            Get.back();
                            }
                            },
                         child: Padding(
                         padding: const EdgeInsets.all(15),
                         child: Center(child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22)),
                         ),
                         ),
                         )
                      else if (showCartButton)
                          GetBuilder<AddToCartController>(
                            init: Get.isRegistered<AddToCartController>()
                            ? null : AddToCartController(),
                              builder: (AddToCartController controller) {
                                final count = cartCount > 0 ? cartCount : controller.cartCount;
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Material(
                                      color: Colors.white.withOpacity(0.18),
                                      shape: const CircleBorder(),
                                      child: InkWell(
                                        customBorder: const CircleBorder(),
                                        onTap: () => Get.toNamed(AppRoutes.addToCartScreen),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),

                                    if (count > 0)
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Container(
                                          height: 18,
                                          width: 18,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            count > 99 ? "99+" : count.toString(),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                      if (titleWidget != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: titleWidget!,
                          ),
                        )
                      else
                        const Spacer(),
                      if (actions != null) ...actions!,
                    ],
                  ),

                  if (titleWidget == null)
                    IgnorePointer(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: FontFamily.poppinsBold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class AppBarCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 30);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 30,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
