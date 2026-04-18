import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String contactInfo;

  const ResetPasswordScreen({super.key, required this.contactInfo});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _showPasswordRequirements = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        if (!_showPasswordRequirements) {
          setState(() {
            _showPasswordRequirements = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _passwordController.text == _confirmPasswordController.text;
  }

  Future<void> _resetPassword() async {
    setState(() => _isLoading = true);
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.redAccent),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Image.asset(
                          'assets/images/Background.png',
                          height: 90,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        "Reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Enter your new password below",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: !_isPasswordVisible,
                        onChanged: (_) => setState(() {}),
                        onTap: () {
                          setState(() {
                            _showPasswordRequirements = true;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "New Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: "Confirm New Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: (_isFormValid() && !_isLoading) ? _resetPassword : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                            disabledBackgroundColor: const Color(0xFF003366).withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text(
                                  "Reset Password",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      if (_showPasswordRequirements) ...[
                        const SizedBox(height: 30),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.lightBlue.shade100, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Password requirements:",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _showPasswordRequirements = false;
                                      });
                                    },
                                    child: const Icon(Icons.close, color: Colors.grey, size: 24),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "• length must be 8 or 12 characters long",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "• Casing: must contain atleast one uppercase letter(A-Z) and atleast one lowercase letter (a-z)",
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "• Numbers: must contain atleast one number(0-9)",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Spacer(),
                      const SizedBox(height: 40),
                      const Text(
                        "Need help? Visit our Help Center\nor contact us on 254711881798 / 211929336110",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
