import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/core/constants/app_colors.dart';
import 'package:stream_control/core/validators/validators.dart';
import 'package:stream_control/features/panel/screens/vmix_panel_screen.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class NewConnectionScreen extends ConsumerStatefulWidget {
  const NewConnectionScreen({super.key});

  @override
  ConsumerState<NewConnectionScreen> createState() => _NewConnectionScreen();
}

class _NewConnectionScreen extends ConsumerState<NewConnectionScreen> {
  bool _useAuth = false;
  final TextEditingController _controllerHost = TextEditingController();
  final TextEditingController _controllerPort = TextEditingController();
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _connFailed = false;

  ConstrainedBox styledConstrainedBox({required Widget child}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 800),
      child: child,
    );
  }

  Future<void> handleConnect() async {
    setState(() => _connFailed = false);
    if (_formKey.currentState!.validate()) {
      String host = _controllerHost.text.trim();
      if (!host.startsWith('http://') && !host.startsWith('https://')) {
        host = 'http://$host';
      }
      final port = _controllerPort.text.trim();
      final uri = '$host:$port/api';
      bool connected = false;
      if (_useAuth) {
        connected = await ref.read(vmixProvider.notifier).connect(
              uri,
              user: _controllerUser.text,
              password: _controllerPassword.text,
            );
      } else {
        connected = await ref.read(vmixProvider.notifier).connect(uri);
      }
      if (connected && mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const VmixPanelScreen(),
        ));
      } else {
        setState(() => _connFailed = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vmix = ref.watch(vmixProvider);
    bool isLoading = vmix.isLoading;

    Widget authFields() {
      return Row(
        spacing: 20,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: TextFormField(
              controller: _controllerUser,
              decoration: const InputDecoration(
                labelText: 'User',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.loose,
            child: TextFormField(
              controller: _controllerPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New connection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  spacing: 20,
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.loose,
                      child: TextFormField(
                        controller: _controllerHost,
                        maxLines: 1,
                        validator: validateHost,
                        decoration: const InputDecoration(
                          labelText: 'Host',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: TextFormField(
                        controller: _controllerPort,
                        maxLines: 1,
                        validator: validatePort,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_useAuth) authFields(),
                SwitchListTile(
                  value: _useAuth,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() => _useAuth = value);
                    }
                  },
                  title: const Text("Use authentication"),
                ),
                if (_connFailed)
                  Column(
                    children: [
                      const Text(
                        'Could not connect.',
                        style: TextStyle(color: AppColors.error),
                      ),
                      Text(
                        vmix.error?.message ?? '',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                OutlinedButton(
                  onPressed: isLoading ? null : handleConnect,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Connect',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (isLoading)
                  const Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),
                      Text("Connecting"),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
