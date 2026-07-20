import 'package:flutter/material.dart';
import 'package:saral/View/Constant/App_Colors.dart';
import 'package:saral/View/Constant/App_font.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
  });

  static const Color _activeColor = AppColors.brandRed;
  static const Color _inactiveColor = AppColors.inActiveGreyColor;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            bottom: bottomPad > 0 ? 6 : 10,
          ),
          child: Row(
            children: [
              _BottomNavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: "Home",
                onTap: () => onTap(0),
              ),
              if (isAdmin)
                _BottomNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: "Product",
                  onTap: () => onTap(1),
                )
              else
                _BottomNavItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag_rounded,
                  label: "Orders",
                  onTap: () => onTap(1),
                ),
              _BottomNavItem(
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.support_agent_outlined,
                activeIcon: Icons.support_agent,
                label: "Contact",
                onTap: () => onTap(2),
              ),
              if (isAdmin)
                _BottomNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.assessment_outlined,
                  activeIcon: Icons.assessment_rounded,
                  label: "Report",
                  onTap: () => onTap(3),
                )
              else
                _BottomNavItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: "Profile",
                  onTap: () => onTap(3),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback onTap;

  bool get isActive => index == currentIndex;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? CustomBottomBar._activeColor
        : CustomBottomBar._inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 24,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: FontFamily.jetBrainMedium,
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
