import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:weesh_mobile/core/exceptions/weesh_exceptions.dart';
import 'package:weesh_mobile/core/models/weesh_driver.dart';
import 'package:weesh_mobile/core/providers/supabase_provider.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository(ref.read(supabaseProvider));
});

class DriverRepository {
  const DriverRepository(this._supabase);
  final SupabaseClient _supabase;

  Future<List<WeeshDriver>> getNearbyDrivers(double lat, double lng,
      {double radiusKm = 5.0}) async {
    try {
      final response = await _supabase.rpc('nearby_drivers', params: {
        'lat': lat,
        'lng': lng,
        'radius_km': radiusKm,
      });

      if (response == null) return [];

      return (response as List)
          .map((data) => WeeshDriver.fromJson(data))
          .toList();
    } on PostgrestException catch (e) {
      throw WeeshNetworkException(e.message);
    } catch (e) {
      throw WeeshNetworkException(e.toString());
    }
  }

  Future<WeeshDriver?> getDriverProfile(String driverId) async {
    try {
      final response = await _supabase
          .from('drivers')
          .select()
          .eq('id', driverId)
          .maybeSingle();

      if (response == null) return null;
      return WeeshDriver.fromJson(response);
    } on PostgrestException catch (e) {
      throw WeeshNetworkException(e.message);
    }
  }
}
