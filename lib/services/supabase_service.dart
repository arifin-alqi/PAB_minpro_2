import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaksi.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // CRUD

  Future<List<Transaksi>> getTransaksi() async {
    final response = await _client
        .from('pegadaian')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((e) => Transaksi.fromJson(e)).toList();
  }

  Future<Transaksi> addTransaksi(Transaksi transaksi) async {
    final response = await _client
        .from('pegadaian')
        .insert(transaksi.toJson())
        .select()
        .single();

    return Transaksi.fromJson(response);
  }

  Future<Transaksi> updateTransaksi(Transaksi transaksi) async {
    final response = await _client
        .from('pegadaian')
        .update(transaksi.toJson())
        .eq('id', transaksi.id!)
        .select()
        .single();

    return Transaksi.fromJson(response);
  }

  Future<void> deleteTransaksi(int id) async {
    await _client.from('pegadaian').delete().eq('id', id);
  }
}