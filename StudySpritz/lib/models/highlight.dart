class Highlight {
  final String id;
  final String bookId;
  final int startIndex;
  final int endIndex;
  final String type; // color/type string

  const Highlight({
    required this.id,
    required this.bookId,
    required this.startIndex,
    required this.endIndex,
    required this.type,
  });
}