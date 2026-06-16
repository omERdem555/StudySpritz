class Bookmark {
  String markId;
  String bookId;

  int pageNumber;
  int wordIndex;

  String markNote;
  DateTime createdAt;

  Bookmark({
    required this.markId,
    required this.bookId,
    required this.pageNumber,
    required this.wordIndex,
    required this.markNote,
    required this.createdAt,
  });
}