class ReaderState {
  final int wordIndex;
  final int pageIndex;

  ReaderState({
    required this.wordIndex,
    required this.pageIndex,
  });

  ReaderState copyWith({
    int? wordIndex,
    int? pageIndex,
  }) {
    return ReaderState(
      wordIndex: wordIndex ?? this.wordIndex,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}