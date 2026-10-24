import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onBack, required this.onLogin, super.key});

  final VoidCallback onBack;
  final VoidCallback onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(onPressed: widget.onBack)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Login', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              const Text(
                'Sign in to your account',
                style: TextStyle(color: AppTheme.textMuted),
              ),
              const SizedBox(height: 28),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email or Phone',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) =>
                        setState(() => _rememberMe = value ?? false),
                  ),
                  const Text('Remember me', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  TextButton(
                    onPressed: () => showAppMessage(context, 'Password reset'),
                    child: const Text('Forgot password?'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onLogin,
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 22),
              const _OrDivider(),
              const SizedBox(height: 18),
              _OutlinedAction(
                icon: Icons.g_mobiledata_rounded,
                label: 'Continue with Google',
                onPressed: () =>
                    showAppMessage(context, 'Google sign-in is not configured'),
              ),
              const SizedBox(height: 10),
              _OutlinedAction(
                icon: Icons.apple,
                label: 'Continue with Apple',
                onPressed: () =>
                    showAppMessage(context, 'Apple sign-in is not configured'),
              ),
              const SizedBox(height: 22),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () =>
                          showAppMessage(context, 'Sign-up is not configured'),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) => const Row(
    children: [
      Expanded(child: Divider()),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Text('OR', style: TextStyle(color: AppTheme.textMuted)),
      ),
      Expanded(child: Divider()),
    ],
  );
}

class _OutlinedAction extends StatelessWidget {
  const _OutlinedAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.textPrimary,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppTheme.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
