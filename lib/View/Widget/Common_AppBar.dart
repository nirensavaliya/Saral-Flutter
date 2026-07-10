import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';
import 'package:saral/View/Screen/ProductDetail/Controller/ProductDetailController.dart';
import 'package:saral/View/Utils/App_Routes.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showDrawer;
  final bool showCart;
  final bool clearAll;
  final VoidCallback? onBack;
  final VoidCallback? onCartTap;
  final VoidCallback? onClearAll;
  final List<Widget>? actions;

  CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showDrawer = false,
    this.showCart = false,
    this.clearAll = false,
    this.onBack,
    this.onCartTap,
    this.onClearAll,
    this.actions,
  });


  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Stack(
        children: [
          ClipPath(
            clipper: AppBarCurveClipper(),
            child: Container(height: 120, color: AppColors.btnColors),
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
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              print("Click.......");
                              Get.back();
                            },
                          ),
                        ),
                      Spacer(),
                      if (actions != null) ...actions!,
                    ],
                  ),

                  IgnorePointer(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
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
