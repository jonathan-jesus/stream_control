import 'package:flutter/material.dart';
import 'package:stream_control/core/constants/app_colors.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
import 'package:stream_control/features/vmix/models/vmix_state.dart';

PreferredSizeWidget projectAppBar(BuildContext context, VmixState vmix) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: const Text(
      'Stream Control',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
    ),
    actions: [
      if (vmix.lastCommandError)
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Failed to send last command: '${vmix.lastCommand}'"),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          icon: const Icon(
            Icons.error,
            color: AppColors.error,
          ),
        ),
      if (vmix.consecutiveErrors > 0)
        Icon(
          vmix.error?.icon ??
              Icons.signal_wifi_statusbar_connected_no_internet_4,
          color: AppColors.warning,
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Vmix ver.: ${vmix.project?.version ?? ''}'),
      ),
    ],
  );
}
