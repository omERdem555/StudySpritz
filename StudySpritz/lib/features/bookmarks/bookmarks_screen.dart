import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/bookmark.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/bookmark_repository.dart';

class BookmarksScreen extends StatelessWidget {
  /// Eğer belirli bir kitabın bookmark'larını görmek istersek filtre ekleyebilmek için opsiyonel yaptık
  final String? filterBookId;

  const BookmarksScreen({super.key, this.filterBookId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.bookmarksBox.listenable(),
      builder: (context, Box<Bookmark> box, _) {
        // Filtre varsa sadece o kitabın, yoksa hepsinin bookmark'larını listele
        final bookmarks = filterBookId != null
            ? box.values.where((b) => b.bookId == filterBookId).toList()
            : box.values.toList();

        // En son eklenen bookmark en üstte görünsün diye sıralıyoruz (UX Geliştirmesi)
        bookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        if (bookmarks.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Bookmarks")),
            body: const Center(child: Text("No bookmarks found.")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Bookmarks")),
          body: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final b = bookmarks[index];

              return FutureBuilder<Book?>(
                future: BookRepository().getBook(b.bookId),
                builder: (context, snapshot) {
                  final book = snapshot.data;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(
                        Icons.bookmark,
                        color: Colors.blue,
                      ),

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book?.bookName ?? "Unknown Book",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Divider(height: 1),
                          const SizedBox(height: 6),
                          Text(
                            "Page ${b.pageNumber}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (b.markNote.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              b.markNote,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],

                          const SizedBox(height: 8),

                          Text(
                            "${b.createdAt.day}/${b.createdAt.month}/${b.createdAt.year}",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _handleDelete(context, b.markId),
                      ),

                      onTap: () {
                        context.push(
                          '/reader',
                          extra: {
                            "bookId": b.bookId,
                            "wordIndex": b.wordIndex,
                            "pageIndex": b.pageNumber,
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleDelete(BuildContext context, String markId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Bookmark"),
        content: const Text("Are you sure you want to delete this bookmark?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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