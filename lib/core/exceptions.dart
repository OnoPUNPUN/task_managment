class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  factory ApiException.fromDio(dynamic e) {
    try {
      if (e is Exception) return ApiException(e.toString());
      return ApiException('Network error');
    } catch (_) {
      return ApiException('Unknown error');
    }
  }

  @override
  String toString() => message;
}
