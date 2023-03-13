class PaginatedResult<T> {
  final String? nextToken;
  final List<T> items;

  PaginatedResult({
    required this.nextToken,
    required this.items,
  });
}
