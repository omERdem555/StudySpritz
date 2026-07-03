class Bookmark {
  final String markId;
  final String bookId;
  final int pageNumber;
  final int wordIndex;
  final String markNote;
  final DateTime createdAt;

  const Bookmark({
    required this.markId,
    required this.bookId,
    required this.pageNumber,
    required this.wordIndex,
    required this.markNote,
    required this.createdAt,
  });

  Bookmark copyWith({
    String? bookId,
    int? pageNumber,
    int? wordIndex,
    String? markNote,
    DateTime? createdAt,
  }) {
    return Bookmark(
      markId: markId,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      wordIndex: wordIndex ?? this.wordIndex,
      markNote: markNote ?? this.markNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}