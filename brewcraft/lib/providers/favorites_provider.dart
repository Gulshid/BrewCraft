import 'package:flutter/foundation.dart';

/// Tracks which coffee IDs the user has favorited. Kept deliberately simple
/// (in-memory only, resets on app restart) — swap this for persisted
/// storage later without touching any of the screens that use it.
class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String coffeeId) => _favoriteIds.contains(coffeeId);

  void toggleFavorite(String coffeeId) {
    if (_favoriteIds.contains(coffeeId)) {
      _favoriteIds.remove(coffeeId);
    } else {
      _favoriteIds.add(coffeeId);
    }
    notifyListeners();
  }

  int get count => _favoriteIds.length;
}
