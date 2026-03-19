import 'package:isar/isar.dart';

part 'isar_pabili_draft.g.dart';

@collection
class IsarPabiliDraft {
  Id id = Isar.autoIncrement;

  late String documentJson;
  late DateTime updatedAt;
}
