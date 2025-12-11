import 'package:equatable/equatable.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
import 'package:stream_control/features/vmix/models/vmix_project.dart';

class VmixState extends Equatable {
  final String? uri;
  final String? user;
  final String? password;
  final bool isConnected;
  final VmixProject? project;
  final bool isLoading;
  final VmixErrorType? error;
  final int consecutiveErrors;
  final bool lastCommandError;
  final String? lastCommand;

  const VmixState({
    this.isConnected = false,
    this.isLoading = false,
    this.uri,
    this.user,
    this.password,
    this.error,
    this.lastCommandError = false,
    this.lastCommand,
    this.project,
    this.consecutiveErrors = 0,
  });

  String? get host {
    if (uri == null) return null;
    final parsed = Uri.tryParse(uri!);
    if (parsed != null && parsed.host.isNotEmpty) return parsed.host;

    var s = uri!.trim();
    s = s.replaceFirst(RegExp(r'^\s*https?://', caseSensitive: false), '');
    final slashIdx = s.indexOf('/');
    if (slashIdx != -1) s = s.substring(0, slashIdx);
    final colonIdx = s.indexOf(':');
    if (colonIdx != -1) s = s.substring(0, colonIdx);
    return s.isEmpty ? null : s;
  }

  VmixState copyWith({
    String? uri,
    String? user,
    String? password,
    bool? isConnected,
    VmixProject? project,
    bool? isLoading,
    VmixErrorType? error,
    int? consecutiveErrors,
    bool? lastCommandError,
    String? lastCommand,
  }) {
    return VmixState(
      uri: uri ?? this.uri,
      user: user ?? this.user,
      password: password ?? this.password,
      isConnected: isConnected ?? this.isConnected,
      project: project ?? this.project,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      consecutiveErrors: consecutiveErrors ?? this.consecutiveErrors,
      lastCommandError: lastCommandError ?? this.lastCommandError,
      lastCommand: lastCommand ?? this.lastCommand,
    );
  }

  @override
  List<Object?> get props => [uri, isConnected, project, isLoading, error];
}
