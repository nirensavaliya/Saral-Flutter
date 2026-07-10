import 'package:flutter/material.dart';
import 'package:saral/View/Screen/Home/View/HomeView.dart';
import 'package:saral/View/Screen/ProductDetail/view/productDetailView.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          bottomItem(
            index: 0,
            icon: Icons.home,
            title: "Home",
          ),
          bottomItem(
            index: 1,
            icon: Icons.production_quantity_limits,
            title: "Product",
          ),
          bottomItem(
            index: 2,
            icon: Icons.person,
            title: "Profile",
          ),

        ],
      ),
    );
  }

  Widget bottomItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xffED1C24).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xffC8102E)
                  : const Color(0xff9CA3AF),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xffC8102E)
                    : const Color(0xff9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}