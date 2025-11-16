enum ApiErrorCode {
  badRequest('BAD_REQUEST', 'Bad request.'),
  unauthorized('UNAUTHORIZED', 'Authentication required.'),
  forbidden('FORBIDDEN', 'Access forbidden.'),
  notFound('NOT_FOUND', 'Resource not found.'),
  conflict('CONFLICT', 'Request conflicts with current state.'),
  server('SERVER_ERROR', 'Server error occurred.'),
  network('NETWORK_ERROR', 'Network error occurred.'),
  timeout('TIMEOUT', 'Request timed out.'),
  cache('CACHE_ERROR', 'Cache read/write failed.'),
  database('DATABASE_ERROR', 'Database operation failed.'),
  storage('STORAGE_ERROR', 'Storage operation failed.'),
  parsing('PARSING_ERROR', 'Parsing failed.'),
  validation('VALIDATION_ERROR', 'Validation failed.'),
  cancelled('CANCELLED', 'Request cancelled.'),
  unknown('UNKNOWN', 'Unknown error occurred.');

  const ApiErrorCode(this.code, this.description);

  final String code;
  final String description;
}
