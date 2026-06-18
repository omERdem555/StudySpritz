import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/bookmark.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/bookmark_repository.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.bookmarksBox.listenable(),
      builder: (context, Box<Bookmark> box, _) {
        final bookmarks = box.values.toList();

        if (bookmarks.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("No bookmarks")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Bookmarks")),
          body: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final b = bookmarks[index];

              return Card(
                child: ListTile(
                  title: Text("Page ${b.pageNumber}"),
                  subtitle: Text(b.markNote),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () async {
                    context.push(
                      '/reader',
                      extra: {
                        "bookId": b.bookId,
                        "wordIndex": b.wordIndex,
                        "pageIndex": b.pageNumber,
                      },
                    );
                  },  
                  onLongPress: () async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Bookmark"),
                          content: const Text(
                            "Are you sure you want to delete this bookmark?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldDelete != true) return;

                    final repo = BookmarkRepository();
                    await repo.deleteBookmark(b.markId);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}