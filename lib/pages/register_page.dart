import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _service = SupabaseService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _register() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showSnackBar('Semua field harus diisi!', isError: true);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Password tidak sama!', isError: true);
      return;
    }
    if (_passwordController.text.length < 6) {
      _showSnackBar('Password minimal 6 karakter!', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _service.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        _showSnackBar('Registrasi berhasil! Silakan login.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) _showSnackBar('Registrasi gagal: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : const Color(0xFF16A34A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2E1E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
            color: const Color(0xFF4ADE80).withOpacity(0.2), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
          prefixIcon: Icon(icon,
              color: const Color(0xFF4ADE80).withOpacity(0.7)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white.withOpacity(0.4),
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1A12), Color(0xFF1A2E1E), Color(0xFF0F1A12)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Back button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ADE80).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFF4ADE80).withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Color(0xFF4ADE80), size: 20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ADE80).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF4ADE80).withOpacity(0.4),
                        width: 1.5),
                  ),
                  child: const Icon(Icons.person_add,
                      color: Color(0xFF4ADE80), size: 38),
                ),
                const SizedBox(height: 16),

                const Text(
                  'BUAT AKUN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daftar untuk mulai menggunakan GADAIIN',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 13),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Fields
                _buildField(_emailController, 'Enter your email . . .',
                    Icons.email_outlined,
                    type: TextInputType.emailAddress),
                const SizedBox(height: 14),
                _buildField(
                  _passwordController,
                  'Enter your password . . .',
                  Icons.lock_outline,
                  isPassword: true,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                const SizedBox(height: 14),
                _buildField(
                  _confirmPasswordController,
                  'Confirm your password . . .',
                  Icons.lock_outline,
                  isPassword: true,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: 36),

                // Daftar button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ADE80),
                      foregroundColor: const Color(0xFF0F1A12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF0F1A12)),
                          )
                        : const Text(
                            'DAFTAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'sudah punya akun? login',
                    style: TextStyle(
                      color: const Color(0xFF4ADE80).withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}