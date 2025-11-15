import 'package:flutter/material.dart';
import 'package:stream_control/features/vmix/models/vmix_state.dart';

PreferredSizeWidget projectAppBar(BuildContext context, VmixState vmix) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Theme.of(context).primaryColorDark,
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
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child:
                    Text("Failed to send last command: '${vmix.lastCommand}'"),
              ),
            ),
          ),
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      if (vmix.consecutiveErrors > 1)
        const Icon(
          Icons.signal_wifi_statusbar_connected_no_internet_4,
          color: Colors.amber,
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text('Vmix ver.: ${vmix.project?.version ?? ''}'),
      ),
    ],
  );
}
