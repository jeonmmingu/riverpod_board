import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_board/domain/models/post/post.dart';

class HiveInit {
  static Future<void> initialize() async {
    if (!kIsWeb) {
      final appDocumentDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDir.path);
    } else {
      await Hive.initFlutter();
    }

    Hive.registerAdapter(PostAdapter());
    await Hive.openBox<Post>('posts');
  }
}