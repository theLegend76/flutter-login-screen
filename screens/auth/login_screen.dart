import 'package:flutter/material.dart';
import 'signup_screen.dart';

class DreamAriseLoginScreen extends StatefulWidget {
  const DreamAriseLoginScreen({super.key});

  @override
  State<DreamAriseLoginScreen> createState() =>
      _DreamAriseLoginScreenState();
}

class _DreamAriseLoginScreenState
    extends State<DreamAriseLoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();
  final FocusNode _emailFocus = FocusNode();

  bool _isEmailFocused = false;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();

    _emailFocus.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocus.hasFocus;
      });
    });

    _emailController.addListener(() {
      final text = _emailController.text;
      setState(() {
        _showConfirmation = _isValidInput(text);
      });
    });
  }

  bool _isValidInput(String input) {
    final emailValid =
        RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input);
    final phoneValid =
        RegExp(r'^\d{10,}$').hasMatch(input);

    return emailValid || phoneValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // 🔙 BACK ARROW
              Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 26,
                ),
              ),

              const SizedBox(height: 10),

              // LOGO
              Image.asset(
                'assets/images/Background.png',
                height: 90,
              ),

              const SizedBox(height: 10),

              // WELCOME TEXT
              const Text(
                "Welcome to DreamArise",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15),

              // SIGN IN TEXT
              const Text(
                "Sign in or create account",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25),

              // Google
              buildField("continue with Google",
                  iconPath: "assets/images/google.png",
                  readOnly: true),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 60,
                      child: Divider(color: Colors.grey, thickness: 1)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text("OR"),
                  ),
                  SizedBox(
                      width: 60,
                      child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),

              const SizedBox(height: 16),

              // Facebook
              buildField("continue with Facebook",
                  iconPath: "assets/images/facebook.png",
                  readOnly: true),

              const SizedBox(height: 16),

              // Email / Phone
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_isEmailFocused || _emailController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        "Email or Phone Number",
                        style: TextStyle(
                            color: Colors.grey.shade800,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                  Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              _isEmailFocused ? 12 : 35),
                        ),
                        child: TextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  _isEmailFocused ? 12 : 35),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      if (!_isEmailFocused &&
                          _emailController.text.isEmpty)
                        const Positioned(
                          left: 50,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Text("continue with Email or Phone"),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  if (_showConfirmation)
                    GestureDetector(
                      onTap: () {
                        _emailFocus.unfocus();
                        setState(() => _showConfirmation = false);
                      },
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.black,
                        child: Text(
                          _emailController.text,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Next Button
              GestureDetector(
                onTap: _isValidInput(_emailController.text)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      }
                    : null,
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: _isValidInput(_emailController.text)
                        ? Colors.orangeAccent
                        : Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  alignment: Alignment.center,
                  child: const Text("Next", style: TextStyle(color: Colors.white)),
                ),
              ),

              const SizedBox(height: 14),

              // ✅ Terms Agreement
              const Text.rich(
                TextSpan(
                  text: "By continuing you agree to DreamArise's ",
                  children: [
                    TextSpan(
                      text: "Terms and Conditions",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),

              const SizedBox(height: 10),

              // ✅ Copyright
              const Text(
                "© 2026 Agoth Bol Wek. All rights reserved",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),

              const SizedBox(height: 10),

              // ✅ Bottom Logo
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
  }

  Widget buildField(String hint, {String? iconPath, bool readOnly = false}) {
    return SizedBox(
      height: 55,
      child: TextField(
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: iconPath != null
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(iconPath, width: 20),
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'signup_screen.dart';

// class DreamAriseLoginScreen extends StatefulWidget {
//   const DreamAriseLoginScreen({super.key});

//   @override
//   State<DreamAriseLoginScreen> createState() =>
//       _DreamAriseLoginScreenState();
// }

// class _DreamAriseLoginScreenState
//     extends State<DreamAriseLoginScreen> {
//   final TextEditingController _emailController =
//       TextEditingController();
//   final FocusNode _emailFocus = FocusNode();

//   bool _isEmailFocused = false;
//   bool _showConfirmation = false;

//   @override
//   void initState() {
//     super.initState();

//     _emailFocus.addListener(() {
//       setState(() {
//         _isEmailFocused = _emailFocus.hasFocus;
//       });
//     });

//     _emailController.addListener(() {
//       final text = _emailController.text;
//       setState(() {
//         _showConfirmation = _isValidInput(text);
//       });
//     });
//   }

//   bool _isValidInput(String input) {
//     final emailValid =
//         RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input);
//     final phoneValid =
//         RegExp(r'^\d{10,}$').hasMatch(input);

//     return emailValid || phoneValid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center, // center all
//             children: [

//               // 🔙 BACK ARROW
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.black,
//                   size: 26,
//                 ),
//               ),

//               const SizedBox(height: 10), // small top spacing

//               // LOGO
//               Image.asset(
//                 'assets/images/Background.png',
//                 height: 100,
//               ),

//               const SizedBox(height: 10), // reduced spacing

//               // WELCOME TEXT
//               const Text(
//                 "Welcome to DreamArise",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),

//               const SizedBox(height: 15), // space before "Sign in"

//               // SIGN IN TEXT
//               const Text(
//                 "Sign in or create account",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 16,
//                 ),
//               ),

//               const SizedBox(height: 25), // space before fields

//               // Google login field
//               buildField("continue with Google",
//                   iconPath: "assets/images/google.png",
//                   readOnly: true),

//               const SizedBox(height: 16),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                       width: 60,
//                       child: Divider(color: Colors.grey, thickness: 1)),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 8),
//                     child: Text("OR"),
//                   ),
//                   SizedBox(
//                       width: 60,
//                       child: Divider(color: Colors.grey, thickness: 1)),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Facebook login field
//               buildField("continue with Facebook",
//                   iconPath: "assets/images/facebook.png",
//                   readOnly: true),

//               const SizedBox(height: 16),

//               // Email / Phone
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   if (_isEmailFocused || _emailController.text.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 6, left: 4),
//                       child: Text(
//                         "Email or Phone Number",
//                         style: TextStyle(
//                             color: Colors.grey.shade800,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),

//                   Stack(
//                     children: [
//                       AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         height: 55,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(
//                               _isEmailFocused ? 12 : 35),
//                         ),
//                         child: TextField(
//                           controller: _emailController,
//                           focusNode: _emailFocus,
//                           keyboardType: TextInputType.emailAddress,
//                           textAlignVertical: TextAlignVertical.bottom,
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(
//                                   _isEmailFocused ? 12 : 35),
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                       ),

//                       if (!_isEmailFocused &&
//                           _emailController.text.isEmpty)
//                         const Positioned(
//                           left: 50,
//                           top: 0,
//                           bottom: 0,
//                           child: Center(
//                             child: Text("continue with Email or Phone"),
//                           ),
//                         ),
//                     ],
//                   ),

//                   const SizedBox(height: 4),

//                   if (_showConfirmation)
//                     GestureDetector(
//                       onTap: () {
//                         _emailFocus.unfocus();
//                         setState(() => _showConfirmation = false);
//                       },
//                       child: Container(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         color: Colors.black,
//                         child: Text(
//                           _emailController.text,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Next Button
//               GestureDetector(
//                 onTap: _isValidInput(_emailController.text)
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const SignUpScreen()),
//                         );
//                       }
//                     : null,
//                 child: Container(
//                   height: 55,
//                   decoration: BoxDecoration(
//                     color: _isValidInput(_emailController.text)
//                         ? Colors.orangeAccent
//                         : Colors.orange.shade200,
//                     borderRadius: BorderRadius.circular(35),
//                   ),
//                   alignment: Alignment.center,
//                   child: const Text("Next", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildField(String hint, {String? iconPath, bool readOnly = false}) {
//     return SizedBox(
//       height: 55,
//       child: TextField(
//         readOnly: readOnly,
//         decoration: InputDecoration(
//           hintText: hint,
//           prefixIcon: iconPath != null
//               ? Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Image.asset(iconPath, width: 20),
//                 )
//               : null,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(35),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }
// }