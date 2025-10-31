import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthService _auth = AuthService();
  bool _isSignin = true;
  bool _loading = false;

  // Controllers & focus for dynamic labels
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const Color _brandColor = Color(0xFFFF6F61);

  Future<void> _continueWithGoogle() async {
    setState(() => _loading = true);
    try {
      await _auth.signInWithGoogle();
      if (mounted) Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submitEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final email = _email.text.trim();
      final pass = _password.text.trim();
      if (_isSignin) {
        await _auth.signInWithEmail(email: email, password: pass);
      } else {
        await _auth.signUpWithEmail(email: email, password: pass);
      }
      if (mounted) Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _decor({required String idleLabel, required String activeLabel, required FocusNode focusNode}) {
    final bool isActive = focusNode.hasFocus;
    final String label = isActive ? activeLabel : idleLabel;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.4),
      borderRadius: BorderRadius.circular(8),
    );
    return InputDecoration(
      labelText: label,
      hintText: null,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      border: border(Colors.grey.shade300),
      enabledBorder: border(Colors.grey.shade300),
      focusedBorder: border(_brandColor),
      prefixIconColor: _brandColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _skipButton() {
    return TextButton(
      onPressed: _loading ? null : () => Navigator.of(context).pushReplacementNamed('/home'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      child: const Text('Skip'),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!_isSignin)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.grey[800],
              onPressed: _loading
                  ? null
                  : () => setState(() {
                        _isSignin = true;
                      }),
            )
          else
            const SizedBox(width: 48),
          _skipButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
             children: [
               _topBar(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/signin_signup_logo.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              _isSignin ? 'Login to your Account' : 'Create your Account',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 20),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _email,
                                    focusNode: _emailFocus,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _decor(
                                      idleLabel: 'Email',
                                      activeLabel: 'Enter your Email',
                                      focusNode: _emailFocus,
                                    ),
                                    validator: (v) => (v == null || v.isEmpty) ? 'Email required' : null,
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _password,
                                    focusNode: _passFocus,
                                    obscureText: true,
                                    decoration: _decor(
                                      idleLabel: 'Password',
                                      activeLabel: 'Enter your Password',
                                      focusNode: _passFocus,
                                    ),
                                    validator: (v) => (v == null || v.length < 6) ? 'Min 6 characters' : null,
                                    onChanged: (_) => setState(() {}),
                                  ),
                                  if (!_isSignin) ...[
                                    const SizedBox(height: 15),
                                    TextFormField(
                                      controller: _confirm,
                                      focusNode: _confirmFocus,
                                      obscureText: true,
                                      decoration: _decor(
                                        idleLabel: 'Confirm Password',
                                        activeLabel: 'Enter your Password again',
                                        focusNode: _confirmFocus,
                                      ),
                                      validator: (v) => (v != _password.text) ? 'Passwords do not match' : null,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ],
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _brandColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: _loading ? null : _submitEmailPassword,
                                      child: Text(
                                        _isSignin ? 'Sign in' : 'Sign up',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Center(
                              child: Text(
                                '- Or sign ${_isSignin ? 'in' : 'up'} with -',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                             Align(
                               alignment: Alignment.center,
                               child: SizedBox(
                               width: 56,
                               height: 52,
                               child: ElevatedButton(
                                onPressed: _loading ? null : _continueWithGoogle,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                 child: Center(
                                  child: Image.asset(
                                    'assets/google-logo-icon.png',
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                               ),
                            ),
                            // const SizedBox(height: 20),
                             Center(
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Text(
                                     _isSignin
                                         ? "Don't have an account? "
                                         : 'Already have an account? ',
                                     style: const TextStyle(
                                       color: Colors.black,
                                       fontSize: 14,
                                     ),
                                   ),
                                   TextButton(
                                     onPressed: _loading
                                         ? null
                                         : () => setState(() => _isSignin = !_isSignin),
                                     style: TextButton.styleFrom(
                                       foregroundColor: const Color(0xFFFF6F61),
                                      //  padding: const EdgeInsets.symmetric(horizontal: 4),
                                       textStyle: const TextStyle(
                                         fontSize: 14,
                                         fontWeight: FontWeight.w600,
                                       ),
                                     ),
                                     child: Text(_isSignin ? 'Sign up' : 'Sign in'),
                                   ),
                                 ],
                               ),
                             ),
                            // const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}