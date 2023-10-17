part of internet_connection_checker;

class CheckResult {
  CheckResult({
    required this.option,
    required this.isSuccess,
  });

  final CheckInternetOptions option;

  final bool isSuccess;

  @override
  String toString() {
    return 'InternetCheckResult(\n'
        '  option: ${option.toString().replaceAll('\n', '\n  ')},\n'
        '  isSuccess: $isSuccess\n'
        ')';
  }
}
