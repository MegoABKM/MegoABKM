import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient supabase;

  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: 'ENCODED',
      anonKey:
          'ENCODED',
    );
    supabase = Supabase.instance.client;
    return this;
  }
}
