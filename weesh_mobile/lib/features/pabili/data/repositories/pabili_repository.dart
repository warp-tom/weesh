import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:weesh_mobile/core/database/isar_service.dart';
import 'package:weesh_mobile/features/pabili/data/isar/isar_pabili_draft.dart';

final pabiliRepositoryProvider = Provider<PabiliRepository>((ref) {
  final isarAsync = ref.watch(isarProvider);
  return PabiliRepository(isarAsync);
});

class PabiliRepository {
  final AsyncValue<Isar> _isarAsync;

  PabiliRepository(this._isarAsync);

  Future<void> saveDraft(String documentJson) async {
    final isar = _isarAsync.value;
    if (isar == null) return;

    await isar.writeTxn(() async {
      // We only ever need one draft in this simplified logic
      // Clear old drafts first to keep it clean
      await isar.isarPabiliDrafts.clear();
      
      final draft = IsarPabiliDraft()
        ..documentJson = documentJson
        ..updatedAt = DateTime.now();
      
      await isar.isarPabiliDrafts.put(draft);
    });
  }

  Future<String?> getDraft() async {
    final isar = _isarAsync.value;
    if (isar == null) return null;

    final draft = await isar.isarPabiliDrafts.where().sortByUpdatedAtDesc().findFirst();
    return draft?.documentJson;
  }
}
