import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/vmix/data/vmix_api_repository.dart';
import 'package:stream_control/features/settings/state/settings_provider.dart';
import 'package:stream_control/features/vmix/data/vmix_xml_parser.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
// import 'package:stream_control/features/vmix/models/vmix_project.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vmix_state.dart';

class VmixNotifier extends StateNotifier<VmixState> {
  Timer? _pollTimer;
  final Ref _ref;

  VmixNotifier(this._ref) : super(const VmixState());

  static const _keyLastUri = 'lastVmixUri';
  static const _keyLastUser = 'lastVmixUser';
  static const _keyLastPassword = 'lastVmixPassword';
  static const _maxErrors = 10;

  Future<void> tryLastConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUri = prefs.getString(_keyLastUri);
    String? lastUser = prefs.getString(_keyLastUser);
    lastUser = lastUser != '' ? lastUser : null;
    String? lastPassword = prefs.getString(_keyLastPassword);
    lastPassword = lastPassword != '' ? lastPassword : null;
    if (lastUri != null) {
      state = state.copyWith(uri: lastUri);
      await connect(lastUri, user: lastUser, password: lastPassword);
    }
  }

  Future<bool> connect(String uri, {String? user, String? password}) async {
    state = state.copyWith(uri: uri, user: user, password: password);
    await fetchState();
    if (state.isConnected) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastUri, uri);
      await prefs.setString(_keyLastUser, user ?? '');
      await prefs.setString(_keyLastPassword, password ?? '');
      return true;
    }
    return false;
  }

  Future<String?> getLastConnection() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUri = prefs.getString(_keyLastUri);
    return lastUri;
  }

  Future<bool> sendCommand(String function,
      {String? input, String? value}) async {
    if (state.uri == null) return false;
    try {
      final result = await VmixApiRepository().sendCommand(state.uri!,
          user: state.user,
          password: state.password,
          function: function,
          input: input,
          value: value);
      if (result.statusCode == 200) {
        state = state.copyWith(lastCommandError: false, lastCommand: function);
        return true;
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
    state = state.copyWith(lastCommandError: true, lastCommand: function);
    return false;
  }

  Future<void> fetchState() async {
    if (state.uri == null) return;
    state = state.copyWith(isLoading: true);
    try {
      final xml = await VmixApiRepository()
          .fetchState(state.uri!, user: state.user, password: state.password);
      // final project = VmixProject.fromXmlString(xml);
      final project = VmixXmlParser.parse(xml);
      state = state.copyWith(
        project: project,
        isConnected: true,
        error: null,
        consecutiveErrors: 0,
      );
    } on VmixErrorType catch (e) {
      final newErrorCount = state.consecutiveErrors + 1;
      state = state.copyWith(
        isConnected: false,
        error: e,
        consecutiveErrors: newErrorCount,
      );
      if (kDebugMode) print('VmixErrorType');
      if (kDebugMode) print(e);
    } catch (e) {
      final newErrorCount = state.consecutiveErrors + 1;
      state = state.copyWith(
        isConnected: false,
        error: VmixErrorType.unknown,
        consecutiveErrors: newErrorCount,
      );
      if (kDebugMode) print('Unknown Error Type');
      if (kDebugMode) print(e);
    }
    if (state.consecutiveErrors >= _maxErrors) {
      stopPolling();
      state = state.copyWith(
        error: VmixErrorType.disconnected,
      );
    }
    state = state.copyWith(isLoading: false);
  }

  void startPolling({Duration interval = const Duration(seconds: 3)}) {
    stopPolling();
    if (state.uri == null) return;

    final pollInterval = _ref.read(appSettingsProvider).pollingSpeed;

    _pollTimer = Timer.periodic(pollInterval.duration, (_) async {
      await fetchState();
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

final vmixProvider = StateNotifierProvider<VmixNotifier, VmixState>((ref) {
  return VmixNotifier(ref);
});
