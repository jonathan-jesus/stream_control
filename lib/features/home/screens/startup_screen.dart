import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/common/constants.dart';
import 'package:stream_control/features/panel/screens/vmix_panel_screen.dart';
import 'package:stream_control/features/settings/widgets/settings_screen.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';
import 'package:stream_control/features/home/widgets/connection_button.dart';
import 'package:stream_control/features/home/screens/new_connection_screen.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends ConsumerState<StartupScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(vmixProvider.notifier).tryLastConnection();
  }

  _navigateNewConnection() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const NewConnectionScreen(),
    ));
  }

  _navigateSettings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SettingsScreen(),
    ));
  }

  _getOrientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    var vmix = ref.watch(vmixProvider);
    final isLandscape = _getOrientation(context) == Orientation.landscape;

    final lastConnectionButton = ConnectionButton(
      icon: vmix.isLoading
          ? const CircularProgressIndicator()
          : const Icon(
              Icons.replay_outlined,
              size: 48,
            ),
      title: 'Last: ${vmix.host}',
      subTitle: vmix.isLoading
          ? 'Checking connection'
          : vmix.isConnected
              ? 'Tap to reconnect'
              : 'Not reachable',
      onTap: () {
        if (!vmix.isConnected) {
          ref.read(vmixProvider.notifier).tryLastConnection();
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const VmixPanelScreen(),
          ));
        }
      },
      available: vmix.isLoading ? null : vmix.isConnected,
    );
    final newConnectionButton = ConnectionButton(
      icon: const Icon(
        Icons.link,
        size: 48,
      ),
      title: "New Connection",
      subTitle: "Tap to configure a new connection",
      onTap: () => _navigateNewConnection(),
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Theme.of(context).primaryColorDark,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: IconButton.outlined(
              iconSize: 20,
              padding: const EdgeInsets.all(0),
              onPressed: () => _navigateSettings(),
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 48),
          child: Center(
            child: isLandscape
                // Lay widgets according to orientation
                // Landscape:
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: deviceType == DeviceType.tablet
                            ? const EdgeInsets.symmetric(
                                horizontal: 300, vertical: 96)
                            : const EdgeInsets.symmetric(horizontal: 280),
                        child: const FittedBox(
                          child: Text(
                            'Stream Control',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      vmix.uri == null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: newConnectionButton,
                            )
                          : Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: lastConnectionButton,
                                ),
                                Expanded(
                                  child: newConnectionButton,
                                ),
                              ],
                            )
                    ],
                  )
                // Portrait:
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            deviceType == DeviceType.tablet ? 128 : 64),
                        child: const FittedBox(
                          child: Text(
                            'Stream Control',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      if (vmix.uri != null) lastConnectionButton,
                      newConnectionButton,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
