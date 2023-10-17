part of internet_connection_checker;

class InternetConnection {
  factory InternetConnection() => _instance;

  InternetConnection.createInstance({
    this.checkInterval = const Duration(seconds: 5),
    List<CheckInternetOptions>? customCheckOptions,
    bool useDefaultOptions = true,
  }) : assert(
          useDefaultOptions ||
              (customCheckOptions != null && customCheckOptions.isNotEmpty),
          'You must provide a list of options if you are not using the '
          'default ones',
        ) {
    _internetCheckOptions = [
      if (useDefaultOptions) ..._defaultCheckOptions,
      if (customCheckOptions != null) ...customCheckOptions,
    ];

    _statusController.onListen = _maybeEmitStatusUpdate;
    _statusController.onCancel = _handleStatusChangeCancel;
  }

  /// The default list of [Uri]s used for checking internet reachability.
  final List<CheckInternetOptions> _defaultCheckOptions = [
    CheckInternetOptions(uri: Uri.parse('https://icanhazip.com/')),
    CheckInternetOptions(
      uri: Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
    ),
    CheckInternetOptions(uri: Uri.parse('https://pokeapi.co/api/v2/pokemon/1')),
    CheckInternetOptions(uri: Uri.parse('https://reqres.in/api/users/1')),
  ];

  /// The list of [Uri]s used for checking internet reachability.
  late List<CheckInternetOptions> _internetCheckOptions;

  /// The controller for the internet connection status stream.
  final _statusController = StreamController<InternetStatus>.broadcast();

  /// The singleton instance of [InternetConnection].
  static final _instance = InternetConnection.createInstance();

  /// The duration between consecutive status checks.
  ///
  /// Defaults to 5 seconds.
  final Duration checkInterval;

  /// The last known internet connection status result.
  InternetStatus? _lastStatus;

  /// The handle for the timer used for periodic status checks.
  Timer? _timerHandle;

  /// Checks if the [Uri] specified in [option] is reachable.
  ///
  /// Returns a [Future] that completes with an [InternetCheckResult] indicating
  /// whether the host is reachable or not.
  Future<CheckResult> _checkReachabilityFor(
    CheckInternetOptions option,
  ) async {
    try {
      final response = await http.head(option.uri).timeout(option.timeout);

      return CheckResult(
        option: option,
        isSuccess: response.statusCode == 200,
      );
    } catch (_) {
      return CheckResult(
        option: option,
        isSuccess: false,
      );
    }
  }

  /// Checks if there is internet access by verifying connectivity to the
  /// specified [Uri]s.
  ///
  /// Returns a [Future] that completes with a boolean value indicating
  /// whether internet access is available or not.
  Future<bool> get hasInternetAccess async {
    final completer = Completer<bool>();
    int length = _internetCheckOptions.length;

    for (final option in _internetCheckOptions) {
      unawaited(
        _checkReachabilityFor(option).then((result) {
          length -= 1;

          if (completer.isCompleted) return;

          if (result.isSuccess) {
            completer.complete(true);
          } else if (length == 0) {
            completer.complete(false);
          }
        }),
      );
    }

    return completer.future;
  }

  /// Returns the current internet connection status.
  ///
  /// Returns a [Future] that completes with the [InternetStatus] indicating
  /// the current internet connection status.
  Future<InternetStatus> get internetStatus async => await hasInternetAccess
      ? InternetStatus.connected
      : InternetStatus.disconnected;

  /// Internal method for emitting status updates.
  ///
  /// Updates the status and emits it if there are listeners.
  Future<void> _maybeEmitStatusUpdate() async {
    _startListeningToConnectivityChanges();
    _timerHandle?.cancel();

    final currentStatus = await internetStatus;

    if (!_statusController.hasListener) return;

    if (_lastStatus != currentStatus && _statusController.hasListener) {
      _statusController.add(currentStatus);
    }

    _timerHandle = Timer(checkInterval, _maybeEmitStatusUpdate);

    _lastStatus = currentStatus;
  }

  /// Handles cancellation of status change events.
  ///
  /// Cancels the timer and resets the last status.
  void _handleStatusChangeCancel() {
    if (_statusController.hasListener) return;

    _connectivitySubscription?.cancel().then((_) {
      _connectivitySubscription = null;
    });
    _timerHandle?.cancel();
    _timerHandle = null;
    _lastStatus = null;
  }

  /// The result of the last attempt to check the internet status.
  InternetStatus? get lastTryResults => _lastStatus;

  /// Stream that emits internet connection status changes.
  Stream<InternetStatus> get onStatusChange => _statusController.stream;

  /// Connectivity subscription.
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  /// Starts listening to connectivity changes from [connectivity_plus] package
  /// using the [Connectivity.onConnectivityChanged] stream.
  ///
  /// [connectivity_plus]: https://pub.dev/packages/connectivity_plus
  void _startListeningToConnectivityChanges() {
    if (_connectivitySubscription != null) return;
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (connectivityResult) {
        if (_statusController.hasListener) {
          _maybeEmitStatusUpdate();
        }
      },
    );
  }
}
