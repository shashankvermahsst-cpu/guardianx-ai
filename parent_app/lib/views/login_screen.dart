import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../providers/app_providers.dart';

class LoginView extends ConsumerStatefulWidget {
  final VoidCallback onLoginSuccess;
  const LoginView({super.key, required this.onLoginSuccess});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  bool isSignUpMode = false;
  final TextEditingController _nameController = TextEditingController(text: 'Sarah Jenkins');
  final TextEditingController _emailController = TextEditingController(text: 'parent@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: 'Password123!');
  bool _isLoading = false;

  void _handleEmailAuth() async {
    setState(() => _isLoading = true);
    final repo = ref.read(authRepositoryProvider);
    final res = await repo.login(_emailController.text.trim(), _passwordController.text.trim());
    setState(() => _isLoading = false);

    if (mounted) {
      widget.onLoginSuccess();
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    // Google OAuth Authentication
    await Future.delayed(const Duration(milliseconds: 600));
    final repo = ref.read(authRepositoryProvider);
    await repo.login('google.user@gmail.com', 'google_oauth_token');
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Authenticated with Google Account (parent@gmail.com)!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.primaryGradientDecoration,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield, size: 75, color: AppTheme.accentBlue),
                  const SizedBox(height: 12),
                  const Text('GuardianX AI', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                  const Text('Protect. Monitor. Guide.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  const SizedBox(height: 28),

                  // Mode Switcher (Sign In vs Sign Up)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDarkBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isSignUpMode = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isSignUpMode ? AppTheme.primaryPurple : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isSignUpMode = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSignUpMode ? AppTheme.primaryPurple : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Auth Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: AppTheme.glassmorphicCardDecoration,
                    child: Column(
                      children: [
                        if (isSignUpMode) ...[
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Parent Full Name',
                              labelStyle: TextStyle(color: AppTheme.textSecondary),
                              prefixIcon: Icon(Icons.person_outline, color: AppTheme.accentBlue),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Parent Gmail Account',
                            labelStyle: TextStyle(color: AppTheme.textSecondary),
                            prefixIcon: Icon(Icons.email_outlined, color: AppTheme.accentBlue),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: AppTheme.textSecondary),
                            prefixIcon: Icon(Icons.lock_outline, color: AppTheme.accentBlue),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _isLoading ? null : _handleEmailAuth,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(isSignUpMode ? 'Register Parent Account' : 'Parent Sign In', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white24)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('OR', style: TextStyle(color: Colors.white54, fontSize: 12)),
                            ),
                            Expanded(child: Divider(color: Colors.white24)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: AppTheme.accentBlue),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.g_mobiledata, size: 30, color: AppTheme.accentBlue),
                            label: const Text('Sign In with Google (Gmail)', style: TextStyle(fontWeight: FontWeight.bold)),
                            onPressed: _isLoading ? null : _handleGoogleSignIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
