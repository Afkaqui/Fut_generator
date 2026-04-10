import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'features/profile/data/models/user_profile.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(UserTypeAdapter());

  // Migrate old single-profile box to new multi-profile box
  await _migrateIfNeeded();

  runApp(const ProviderScope(child: FutGeneradorApp()));
}

/// Migrate from old 'profile' box (single entry) to new 'profiles' box (keyed by DNI)
Future<void> _migrateIfNeeded() async {
  final oldBoxName = 'profile';
  final newBoxName = 'profiles';
  final settingsBoxName = 'settings';

  // Open new boxes
  await Hive.openBox<UserProfile>(newBoxName);
  await Hive.openBox<String>(settingsBoxName);

  // Check if old box exists and has data
  if (await Hive.boxExists(oldBoxName)) {
    final oldBox = await Hive.openBox<UserProfile>(oldBoxName);
    final oldProfile = oldBox.get('user_profile');
    if (oldProfile != null) {
      final newBox = Hive.box<UserProfile>(newBoxName);
      final settingsBox = Hive.box<String>(settingsBoxName);
      // Only migrate if the new box doesn't have this profile yet
      if (!newBox.containsKey(oldProfile.dni)) {
        await newBox.put(oldProfile.dni, oldProfile);
      }
      // Set as active if no active profile yet
      if (!settingsBox.containsKey('active_profile')) {
        await settingsBox.put('active_profile', oldProfile.dni);
      }
      // Clear old box
      await oldBox.clear();
    }
    await oldBox.close();
  }
}
