sealed class ApiException implements Exception {
  const ApiException();
}

// No response at all: connection or timeout
class NoConnectionException extends ApiException {
  const NoConnectionException();
}

// Server error: 5xx
class ServerException extends ApiException {
  const ServerException(this.status);

  final int status;
}

// Request errors: 4xx
class NotFoundException extends ApiException {
  const NotFoundException();
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException();
}

// Invalid JSON response
class BadResponseException extends ApiException {
  const BadResponseException([this.detail]);

  final String? detail;
}
