import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../models/bookmark.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/bookmark_repository.dart';

class BookmarksScreen extends StatefulWidget {
  final String? filterBookId;

  const BookmarksScreen({
    super.key,
    this.filterBookId,
  });

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  String? selectedBookId;
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.bookmarksBox.listenable(),
      builder: (context, Box<Bookmark> box, _) {
        List<Bookmark> bookmarks = box.values.toList();

        if (widget.filterBookId != null) {
          bookmarks = bookmarks
              .where((b) => b.bookId == widget.filterBookId)
              .toList();
        }

        if (selectedBookId != null) {
          bookmarks = bookmarks
              .where((b) => b.bookId == selectedBookId)
              .toList();
        }

        bookmarks.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );

        if (searchText.trim().isNotEmpty) {
          final query = searchText.toLowerCase();

          bookmarks = bookmarks.where((bookmark) {
            final note =
                bookmark.markNote.toLowerCase();

            final book = HiveService.booksBox.get(
              bookmark.bookId,
            );

            final bookName =
                book?.bookName.toLowerCase() ?? "";

            return note.contains(query) ||
                bookName.contains(query);
          }).toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Bookmarks"),
          ),
          body: FutureBuilder<List<Book>>(
            future: BookRepository().getAllBooks(),
            builder: (context, snapshot) {
              final books = snapshot.data ?? [];

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      8,
                    ),
                    child: DropdownButtonFormField<String?>(
                      isExpanded: true,
                      value: selectedBookId,
                      decoration: const InputDecoration(
                        labelText: "Book",
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text("All Books"),
                        ),
                        ...books.map(
                          (book) => DropdownMenuItem<String?>(
                            value: book.bookId,
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                book.bookName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBookId = value;
                        });
                      },
                    ),  
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search bookmarks...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: bookmarks.isEmpty
                        ? const Center(
                            child: Text(
                              "No bookmarks found.",
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: bookmarks.length,
                            itemBuilder: (context, index) {
                              final b = bookmarks[index];

                              return FutureBuilder<Book?>(
                                future: BookRepository().getBook(
                                  b.bookId,
                                ),
                                builder: (context, snapshot) {
                                  final book = snapshot.data;

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    elevation: 2,
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.bookmark,
                                        color: Colors.blue,
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book?.bookName ??
                                                "Unknown Book",
                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Divider(height: 1),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Page ${b.pageNumber}",
                                            style: TextStyle(
                                              color:
                                                  Colors.grey[700],
                                              fontWeight:
                                                  FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (b.markNote
                                              .isNotEmpty) ...[
                                            const SizedBox(
                                                height: 10),
                                            Text(
                                              b.markNote,
                                              style:
                                                  const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Text(
                                            "${b.createdAt.day}/${b.createdAt.month}/${b.createdAt.year}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors
                                                  .grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color:
                                              Colors.redAccent,
                                        ),
                                        onPressed: () =>
                                            _handleDelete(
                                          context,
                                          b.markId,
                                        ),
                                      ),
                                      onTap: () {
                                        context.push(
                                          '/reader',
                                          extra: {
                                            "bookId":
                                                b.bookId,
                                            "wordIndex":
                                                b.wordIndex,
                                            "pageIndex":
                                                b.pageNumber,
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    String markId,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Bookmark"),
        content: const Text(
          "Are you sure you want to delete this bookmark?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              false,
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              true,
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      final repo = BookmarkRepository();
      await repo.deleteBookmark(markId);
    }
  }
}