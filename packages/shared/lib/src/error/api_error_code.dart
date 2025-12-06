enum ApiErrorCode {
  badRequest('BAD_REQUEST', 'Bad request.'),
  unauthorized('UNAUTHORIZED', 'Authentication required.'),
  forbidden('FORBIDDEN', 'Access forbidden.'),
  notFound('NOT_FOUND', 'Resource not found.'),
  conflict('CONFLICT', 'Request conflicts with current state.'),
  validation('VALIDATION_ERROR', 'Validation failed.'),
  parsing('PARSING_ERROR', 'Parsing failed.'),
  timeout('TIMEOUT', 'Request timed out.'),
  network('NETWORK_ERROR', 'Network error occurred.'),
  server('SERVER_ERROR', 'Server error occurred.'),
  cache('CACHE_ERROR', 'Cache read/write failed.'),
  cancelled('CANCELLED', 'Request cancelled.'),
  unknown('UNKNOWN', 'Unknown error occurred.');

  const ApiErrorCode(this.code, this.description);

  final String code;
  final String description;
}
