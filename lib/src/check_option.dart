part of internet_connection_checker;

class CheckInternetOptions {
  CheckInternetOptions({
    required this.uri,
    this.timeout = const Duration(seconds: 3),
  });

  final Uri uri;

  final Duration timeout;

  @override
  String toString() {
    return 'InternetCheckOption(\n'
        '  uri: $uri,\n'
        '  timeout: $timeout\n'
        ')';
  }
}
