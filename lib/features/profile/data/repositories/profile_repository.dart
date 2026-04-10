import 'package:hive_ce/hive.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  static const String _boxName = 'profiles';
  static const String _activeKeyBox = 'settings';
  static const String _activeKeyField = 'active_profile';

  Future<Box<UserProfile>> _getProfilesBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<UserProfile>(_boxName);
    }
    return Hive.openBox<UserProfile>(_boxName);
  }

  Future<Box<String>> _getSettingsBox() async {
    if (Hive.isBoxOpen(_activeKeyBox)) {
      return Hive.box<String>(_activeKeyBox);
    }
    return Hive.openBox<String>(_activeKeyBox);
  }

  Future<List<UserProfile>> getAllProfiles() async {
    final box = await _getProfilesBox();
    return box.values.toList();
  }

  Future<UserProfile?> getProfile(String key) async {
    final box = await _getProfilesBox();
    return box.get(key);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = await _getProfilesBox();
    await box.put(profile.dni, profile);
  }

  Future<void> deleteProfile(String key) async {
    final box = await _getProfilesBox();
    await box.delete(key);
    // If deleted profile was active, clear active
    final activeKey = await getActiveProfileKey();
    if (activeKey == key) {
      await clearActiveProfile();
    }
  }

  Future<void> setActiveProfile(String key) async {
    final box = await _getSettingsBox();
    await box.put(_activeKeyField, key);
  }

  Future<String?> getActiveProfileKey() async {
    final box = await _getSettingsBox();
    return box.get(_activeKeyField);
  }

  Future<void> clearActiveProfile() async {
    final box = await _getSettingsBox();
    await box.delete(_activeKeyField);
  }

  Future<UserProfile?> getActiveProfile() async {
    final key = await getActiveProfileKey();
    if (key == null) return null;
    return getProfile(key);
  }
}
