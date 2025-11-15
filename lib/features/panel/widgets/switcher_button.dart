import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/models/switcher_button_colors.dart';

class SwitcherButton extends ConsumerWidget {
  const SwitcherButton({
    super.key,
    this.isActive = false,
    this.isRectangleVariant = false,
    this.color = SwitcherButtonColors.white,
    this.colorActive = SwitcherButtonColors.green,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.label,
    this.width = 100,
    this.height = 100,
    this.fontSize = 20,
  });
  final double? width;
  final double? height;
  final double fontSize;
  final String label;
  final bool isActive;
  final bool isRectangleVariant;
  final SwitcherButtonColors color;
  final SwitcherButtonColors colorActive;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      elevation: 10,
      child: SizedBox(
        width: width,
        height: height,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
                color: isActive ? Color(colorActive.hex) : Color(color.hex),
                width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            splashColor: !isActive
                ? Color(colorActive.hex).withAlpha(150)
                : Color(color.hex).withAlpha(150),
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Color(colorActive.hex) : Color(color.hex),
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
