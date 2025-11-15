import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/common/constants.dart';

class SectionCard extends ConsumerWidget {
  final String title;
  final Widget child;
  final bool centerTitle;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceType = getDeviceType(context);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(deviceType == DeviceType.tablet ? 12 : 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            centerTitle
                ? Center(
                    child: Text(
                      title,
                      style: deviceType == DeviceType.tablet
                          ? Theme.of(context).textTheme.titleMedium
                          : Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                : Text(
                    title,
                    style: deviceType == DeviceType.tablet
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w400),
                  ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
