class Book {
  final String bookId;
  final String bookName;

  final String filePath;
  final String fileType;

  final int pageCount;
  final int wordCount;

  final int pageNumber;
  final int wordIndex;

  final bool isFavorite;
  final bool isCompleted;

  final DateTime addedAt;
  final DateTime lastOpenedAt;
  final DateTime? completedAt;

  const Book({
    required this.bookId,
    required this.bookName,
    required this.filePath,
    required this.fileType,
    required this.pageCount,
    required this.wordCount,
    required this.pageNumber,
    required this.wordIndex,
    required this.isFavorite,
    required this.isCompleted,
    required this.addedAt,
    required this.lastOpenedAt,
    this.completedAt,
  });

  Book copyWith({
    String? bookName,
    String? filePath,
    String? fileType,
    int? pageCount,
    int? wordCount,
    int? pageNumber,
    int? wordIndex,
    bool? isFavorite,
    bool? isCompleted,
    DateTime? addedAt,
    DateTime? lastOpenedAt,
    DateTime? completedAt,
  }) {
    return Book(
      bookId: bookId,
      bookName: bookName ?? this.bookName,
      filePath: filePath ?? this.filePath,
      fileType: fileType ?? this.fileType,
      pageCount: pageCount ?? this.pageCount,
      wordCount: wordCount ?? this.wordCount,
      pageNumber: pageNumber ?? this.pageNumber,
      wordIndex: wordIndex ?? this.wordIndex,
      isFavorite: isFavorite ?? this.isFavorite,
      isCompleted: isCompleted ?? this.isCompleted,
      addedAt: addedAt ?? this.addedAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}