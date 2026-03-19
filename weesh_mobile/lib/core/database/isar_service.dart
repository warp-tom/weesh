import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:weesh_mobile/features/pabili/data/isar/isar_grocery_order.dart';
import 'package:weesh_mobile/features/pabili/data/isar/isar_pabili_draft.dart';
import 'package:weesh_mobile/features/parcel/data/isar/isar_parcel.dart';
import 'package:weesh_mobile/features/ride/data/isar/isar_ride.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [
      IsarGroceryOrderSchema,
      IsarPabiliDraftSchema,
      IsarParcelSchema,
      IsarRideSchema,
    ],
    directory: dir.path,
    name: 'weesh_db',
  );
});
