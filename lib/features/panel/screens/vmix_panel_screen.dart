import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/core/constants/app_colors.dart';
import 'package:stream_control/core/utils/device_type.dart';
import 'package:stream_control/features/panel/widgets/project_app_bar.dart';
import 'package:stream_control/features/panel/widgets/sections/inputs_section.dart';
import 'package:stream_control/features/panel/widgets/sections/outputs_section.dart';
import 'package:stream_control/features/panel/widgets/sections/overlay_channel_section.dart';
import 'package:stream_control/features/panel/widgets/sections/transition_section.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class VmixPanelScreen extends ConsumerStatefulWidget {
  const VmixPanelScreen({super.key});

  @override
  ConsumerState<VmixPanelScreen> createState() => _VmixPanelScreen();
}

class _VmixPanelScreen extends ConsumerState<VmixPanelScreen> {
  bool _didPush = false;

  @override
  void initState() {
    ref.read(vmixProvider.notifier).startPolling();
    super.initState();
  }

  _navigateAway(String? uri) {
    if (_didPush) return;
    _didPush = true;
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Row(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: AppColors.error,
                  ),
                  Text('Oops...'),
                ],
              ),
              Text(uri != null
                  ? 'Connection lost'
                  : 'Connection with the vmix instance:\n$uri\nhas been lost.'),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final deviceType = getDeviceType(context);
    final vmix = ref.watch(vmixProvider);

    if (!vmix.isConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateAway(vmix.uri);
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        ref.read(vmixProvider.notifier).stopPolling();
        if (!didPop) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: deviceType == DeviceType.phone &&
                orientation == Orientation.landscape
            ? null
            : projectAppBar(context, vmix),
        body: SafeArea(
          child: orientation == Orientation.landscape
              ? _Landscape(deviceType)
              : _Portrait(deviceType),
        ),
      ),
    );
  }
}

class _Landscape extends StatelessWidget {
  const _Landscape(this.deviceType);

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Flexible(
          flex: deviceType == DeviceType.tablet ? 1 : 2,
          child: Row(
            spacing: 10,
            children: [
              Flexible(
                flex: deviceType == DeviceType.tablet ? 1 : 5,
                child: const OverlayChannelSection(
                  spacing: 20,
                  width: 100,
                ),
              ),
              Flexible(
                flex: deviceType == DeviceType.tablet ? 1 : 4,
                child: OutputsSection(
                  width: deviceType == DeviceType.tablet ? null : 90,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: deviceType == DeviceType.tablet ? 4 : 5,
          child: Row(
            spacing: 10,
            children: [
              Flexible(
                flex: deviceType == DeviceType.tablet ? 7 : 6,
                fit: FlexFit.tight,
                child: const InputsSection(),
              ),
              Flexible(
                child: TransitionSection(
                  axis: Axis.vertical,
                  spacing: deviceType == DeviceType.tablet ? 20 : 10,
                  buttonsWidth: 100,
                  buttonsHeight: deviceType == DeviceType.tablet ? 100 : 45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait(this.deviceType);

  final DeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final deviceType = getDeviceType(context);

    return Column(
      spacing: 10,
      children: [
        Flexible(
            flex: deviceType == DeviceType.tablet ? 1 : 5,
            child: OverlayChannelSection(
              spacing: deviceType == DeviceType.tablet ? 20 : 5,
              width: deviceType == DeviceType.tablet ? 100 : 50,
              centerTitle: true,
            )),
        Flexible(
            child: OutputsSection(
          width: deviceType == DeviceType.tablet ? null : 90,
          centerTitle: true,
        )),
        const Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: InputsSection(
              centerTitle: true,
            )),
        Flexible(
          child: TransitionSection(
            axis: Axis.horizontal,
            spacing: deviceType == DeviceType.tablet ? 20 : 10,
            buttonsWidth: deviceType == DeviceType.tablet ? 180 : 100,
            buttonsHeight: 100,
          ),
        ),
      ],
    );
  }
}
