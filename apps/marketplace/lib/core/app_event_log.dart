/// Lightweight in-memory event log for connectivity and runtime events.
///
/// Captures structured events (connection failures, timeouts, etc.) that can
/// be forwarded to a remote logging/monitoring service in the future.
///
/// Usage:
/// ```dart
/// AppEventLog.instance.record(AppEvent.connectionTimeout(
///   target: 'ws://dittodatto:8001/rpc',
///   context: 'EstablishmentDetailService.fetch',
/// ));
/// ```
library;

import 'dart:collection';

/// A single recorded application event.
class AppEvent {
  AppEvent({
    required this.type,
    required this.message,
    this.context,
    this.metadata,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Factory for connection timeout events.
  factory AppEvent.connectionTimeout({
    required String target,
    String? context,
  }) =>
      AppEvent(
        type: AppEventType.connectionTimeout,
        message: 'Connection timed out: $target',
        context: context,
        metadata: {'target': target},
      );

  /// Factory for connection error events.
  factory AppEvent.connectionError({
    required String target,
    required Object error,
    String? context,
  }) =>
      AppEvent(
        type: AppEventType.connectionError,
        message: 'Connection failed: $target — $error',
        context: context,
        metadata: {'target': target, 'error': '$error'},
      );

  final AppEventType type;
  final String message;
  final DateTime timestamp;

  /// Where in the app this event originated (e.g. class/method name).
  final String? context;

  /// Arbitrary key-value metadata for future log shipping.
  final Map<String, String>? metadata;

  @override
  String toString() =>
      '[${timestamp.toIso8601String()}] $type: $message'
      '${context != null ? ' ($context)' : ''}';
}

/// Categorized event types for filtering and monitoring.
enum AppEventType {
  connectionTimeout,
  connectionError,
}

/// Singleton in-memory event log.
///
/// Stores the most recent [maxEvents] events in a ring buffer.
/// Future: add a `flush()` method that ships events to a remote endpoint.
class AppEventLog {
  AppEventLog._();
  static final instance = AppEventLog._();

  static const maxEvents = 100;
  final _events = Queue<AppEvent>();

  /// Record an event. Oldest events are evicted when the buffer is full.
  void record(AppEvent event) {
    if (_events.length >= maxEvents) _events.removeFirst();
    _events.addLast(event);
  }

  /// All recorded events (oldest first).
  List<AppEvent> get events => List.unmodifiable(_events);

  /// Whether any connectivity failure has been recorded this session.
  bool get hasConnectivityFailure => _events.any(
        (e) =>
            e.type == AppEventType.connectionTimeout ||
            e.type == AppEventType.connectionError,
      );

  /// Clear all recorded events.
  void clear() => _events.clear();
}
