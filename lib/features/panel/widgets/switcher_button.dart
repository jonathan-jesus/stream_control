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
    this.fontSize = 30,
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
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    const animDuration = Duration(milliseconds: 600);

    return Material(
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      color: cardTheme.color,
      elevation: 2,
      child: SizedBox(
        width: width,
        height: height,
        child: InkWell(
          splashColor: Color(colorActive.hex).withAlpha(150),
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
          child: AnimatedContainer(
            duration: animDuration,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? Color(colorActive.hex) : Color(color.hex),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  child: AnimatedDefaultTextStyle(
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color:
                          isActive ? Color(colorActive.hex) : Color(color.hex),
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize,
                    ),
                    child: Text(label),
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
