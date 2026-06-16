class Book {
  String bookId;
  String bookName;

  String filePath;
  String fileType;

  int pageCount;
  int wordCount;

  int pageNumber;
  int wordIndex;

  bool isFavorite;
  bool isCompleted;

  DateTime addedAt;
  DateTime lastOpenedAt;
  DateTime? completedAt;

  Book({
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
}