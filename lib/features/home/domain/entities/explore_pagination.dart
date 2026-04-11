class DiscoveryPage<T> {
  final List<T> items;
  final int pageIndex;
  final int pageSize;
  final int? totalCount;
  final bool hasReachedEnd;

  const DiscoveryPage({
    required this.items,
    required this.pageIndex,
    required this.pageSize,
    this.totalCount,
    required this.hasReachedEnd,
  });
}
