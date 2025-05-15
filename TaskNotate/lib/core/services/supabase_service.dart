import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient supabase;

  Future<SupabaseService> init() async {
    await Supabase.initialize(
      url: 'https://kymozkcwbuflexuazgsu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5bW96a2N3YnVmbGV4dWF6Z3N1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMzNDc0ODksImV4cCI6MjA1ODkyMzQ4OX0.xwqhkpoKan-ZxnASfr3a2vdIKYupH5aPrtgORXZIGTM',
    );
    supabase = Supabase.instance.client;
    return this;
  }
}
