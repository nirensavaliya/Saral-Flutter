import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CommonLoader {
  static const String _defaultAsset = 'assets/lottie/app_loader.json';

  static OverlayEntry? _entry;

  static bool get isShowing => _entry != null;

  static  show(
      BuildContext context, {
        double size = 145,
      }) {
    if (_entry != null) return;

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: Colors.black54,
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: SizedBox(
                width: size,
                height: size,
                child: Lottie.asset(
                  _defaultAsset,
                  repeat: true,
                  fit: BoxFit.cover,
                  options: LottieOptions(
                    enableMergePaths: true,
                    enableApplyingOpacityToLayers: true,
                  ),
                  frameBuilder: (context, child, composition) {
                    if (composition == null) {
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Color(0xffC8102E),
                          ),
                        ),
                      );
                    }
                    return child;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}