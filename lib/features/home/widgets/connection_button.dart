import 'package:flutter/material.dart';
import 'package:stream_control/core/constants/app_colors.dart';

class ConnectionButton extends StatefulWidget {
  const ConnectionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.available,
  });

  final Widget icon;
  final String title;
  final String subTitle;
  final VoidCallback onTap;
  final bool? available;

  @override
  State<StatefulWidget> createState() => _ConnectionButtonState();
}

class _ConnectionButtonState extends State<ConnectionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1)
        .chain(CurveTween(curve: Curves.easeInOutQuad))
        .animate(_controller);
  }

  void _playCycles(int count) {
    final duration = _controller.duration!;

    // forward + reverse = 2 durations
    final singleCycle = duration * 2;
    // pause factor for dramatic effect
    const pauseFactor = 0.45;

    _controller.repeat(reverse: true);

    final total = (singleCycle * count) + (duration * pauseFactor);

    Future.delayed(total, () {
      if (mounted) _controller.stop();
    });
  }

  @override
  void didUpdateWidget(covariant ConnectionButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation once when availability finishes loading
    if (!_hasPlayed && widget.available != null) {
      _hasPlayed = true;

      // Delay animation start by 300ms
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        _playCycles(2);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: primaryColor
                  .withAlpha((140 * _progressAnimation.value).toInt() + 80),
              width: 1 + (_progressAnimation.value * .5),
            ),
          ),
          surfaceTintColor: colorScheme.tertiary,
          elevation: _progressAnimation.value * 5,
          shadowColor: colorScheme.secondary.withAlpha(150),
          child: child,
        );
      },
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.icon,
              const SizedBox(
                width: 40,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    widget.available != null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(widget.available == true
                                  ? 'Available'
                                  : 'Not available'),
                              const SizedBox(width: 4),
                              if (widget.available == true)
                                const Icon(
                                  Icons.check_circle,
                                  size: 16,
                                  color: AppColors.success,
                                ),
                              if (widget.available == false)
                                Icon(
                                  Icons.remove_circle_outlined,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                            ],
                          )
                        : Text(widget.subTitle)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
