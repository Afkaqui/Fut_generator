import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository());

/// Currently active profile
final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile?>(ProfileNotifier.new);

class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final repo = ref.read(profileRepositoryProvider);
    return repo.getActiveProfile();
  }

  Future<void> setActive(String key) async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.setActiveProfile(key);
    state = AsyncData(await repo.getProfile(key));
  }

  Future<void> saveProfile(UserProfile profile, {String? oldDni}) async {
    final repo = ref.read(profileRepositoryProvider);
    // If DNI changed, delete old entry
    if (oldDni != null && oldDni != profile.dni) {
      await repo.deleteProfile(oldDni);
    }
    await repo.saveProfile(profile);
    await repo.setActiveProfile(profile.dni);
    state = AsyncData(profile);
    // Refresh the list
    ref.invalidate(profileListProvider);
  }

  Future<void> deleteProfile(String key) async {
    final repo = ref.read(profileRepositoryProvider);
    await repo.deleteProfile(key);
    // If we deleted the active one, clear it
    final active = await repo.getActiveProfile();
    state = AsyncData(active);
    ref.invalidate(profileListProvider);
  }
}

/// All saved profiles
final profileListProvider = FutureProvider<List<UserProfile>>((ref) async {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getAllProfiles();
});
