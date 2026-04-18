import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'create_password_screen.dart';
import 'reset_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String contactInfo;
  final bool isForgotPassword;

  const VerificationScreen({super.key, required this.contactInfo, this.isForgotPassword = false});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  
  bool _isTimerRunning = false;
  int _start = 60;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  bool _isCodeComplete() {
    return _codeControllers.every((controller) => controller.text.isNotEmpty);
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
        setState(() {}); // Trigger rebuild to update button state
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
    setState(() {}); // Update button state
  }

  void _startTimer() {
    setState(() {
      _start = 60;
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isTimerRunning = false;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get _headerText {
    if (widget.isForgotPassword) {
      return "Reset your password";
    }
    if (widget.contactInfo.contains('@')) {
      return "Verify your email address";
    } else {
      return "Verify your phone number";
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset(
                        'assets/images/Background.png',
                        height: 90,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        _headerText,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Enter the code sent to\n${widget.contactInfo}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 45,
                            height: 55,
                            child: TextField(
                              controller: _codeControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                counterText: "",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                                ),
                              ),
                              onChanged: (value) => _onCodeChanged(value, index),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: (_isCodeComplete() && !_isLoading)
                              ? () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    final code = _codeControllers.map((c) => c.text).join();
                                    
                                    if (widget.isForgotPassword) {
                                      await Supabase.instance.client.auth.verifyOTP(
                                        type: OtpType.recovery,
                                        token: code,
                                        email: widget.contactInfo.contains('@') ? widget.contactInfo : null,
                                        phone: !widget.contactInfo.contains('@') ? widget.contactInfo : null,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => ResetPasswordScreen(contactInfo: widget.contactInfo)),
                                      );
                                    } else {
                                      await Supabase.instance.client.auth.verifyOTP(
                                        type: OtpType.magiclink,
                                        token: code,
                                        email: widget.contactInfo.contains('@') ? widget.contactInfo : null,
                                        phone: !widget.contactInfo.contains('@') ? widget.contactInfo : null,
                                      );
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => CreatePasswordScreen(contactInfo: widget.contactInfo)),
                                      );
                                    }
                                  } catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Invalid Code or Error: $e'), backgroundColor: Colors.red),
                                    );
                                  } finally {
                                    if (mounted) setState(() => _isLoading = false);
                                  }
                                }
                              : null,
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
                                "Submit",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _isTimerRunning
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black, // Darker color matching the "Help Center" context style
                                    fontFamily: 'Inter', // Default family or standard match
                                  ),
                                  children: [
                                    const TextSpan(text: "Didn't receive the code? it could take upto one minute, send a new request in "),
                                    TextSpan(
                                      text: "$_start seconds",
                                      style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: _startTimer,
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Request a new code",
                                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
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

