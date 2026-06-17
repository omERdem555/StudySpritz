int calculatePage(int wordIndex, int wordsPerPage) {
  if (wordsPerPage <= 0) return 0;
  return wordIndex ~/ wordsPerPage;
}

double calculateProgress(int wordIndex, int totalWords) {
  if (totalWords <= 0) return 0.0;
  return wordIndex / totalWords;
}