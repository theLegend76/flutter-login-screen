import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'coming_soon_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String contactInfo;
  final String password;

  const SignUpScreen({super.key, required this.contactInfo, required this.password});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedCountry = '+254';
  bool _agreedToTerms = false;

  DateTime? _selectedDate;

  final List<Map<String, String>> countries = [
    {"code": "+93", "name": "Afghanistan"},
    {"code": "+355", "name": "Albania"},
    {"code": "+213", "name": "Algeria"},
    {"code": "+254", "name": "Kenya"},
    {"code": "+211", "name": "South Sudan"},
    {"code": "+1", "name": "USA"},
    {"code": "+44", "name": "UK"},
    {"code": "+91", "name": "India"},
    {"code": "+971", "name": "UAE"},
    {"code": "+27", "name": "South Africa"},
    {"code": "+255", "name": "Tanzania"},
    {"code": "+256", "name": "Uganda"},
  ];

  @override
  void initState() {
    super.initState();
    void updateState() => setState(() {});
    _firstNameController.addListener(updateState);
    _lastNameController.addListener(updateState);
    _birthDateController.addListener(updateState);
    _phoneController.addListener(updateState);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _allFieldsFilled() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _birthDateController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _agreedToTerms;
  }

  Future<void> _pickBirthDate() async {
    DateTime tempDate = _selectedDate ?? DateTime(2000);

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SizedBox(
                height: 420,
                width: 320,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${tempDate.year}",
                            style: TextStyle(
                              color: Colors.blue.shade200,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${_formatDay(tempDate)}, ${tempDate.day} ${_formatMonth(tempDate)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.orangeAccent,
                            onPrimary: Colors.white,
                            surface: Colors.black,
                            onSurface: Colors.white,
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: tempDate,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          onDateChanged: (date) {
                            setStateDialog(() {
                              tempDate = date;
                            });
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = null;
                                _birthDateController.clear();
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Clear",
                                style: TextStyle(color: Colors.orangeAccent)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = tempDate;
                                _birthDateController.text =
                                    "${tempDate.day}/${tempDate.month}/${tempDate.year}";
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Set",
                                style: TextStyle(color: Colors.orangeAccent)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatDay(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[date.weekday - 1];
  }

  String _formatMonth(DateTime date) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final bool isContinueEnabled = _allFieldsFilled();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                Center(
                  child: Image.asset(
                    'assets/images/Icon3.png',
                    height: 100,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Personal details",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Fill in the details to create your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 25),

                _buildField(_firstNameController, "First Name*"),
                const SizedBox(height: 16),

                _buildField(_lastNameController, "Last Name*"),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _birthDateController,
                  readOnly: true,
                  onTap: _pickBirthDate,
                  decoration: _inputDecoration("Birth Date*"),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 16),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedCountry,
                        isExpanded: true,
                        decoration: _inputDecoration(""),
                        items: countries.map((c) {
                          return DropdownMenuItem(
                            value: c["code"],
                            child: Text("${c["code"]} ${c["name"]}"),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCountry = val;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration("Phone Number*"),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isContinueEnabled ? () async {
                      if (_formKey.currentState!.validate()) {
                          final sm = ScaffoldMessenger.of(context);
                          final nav = Navigator.of(context);
                        try {
                          // Show loading indicator wrapper or just await

                          final isEmail = widget.contactInfo.contains('@');

                          // Supabase Sign Up
                          await Supabase.instance.client.auth.signUp(
                            email: isEmail ? widget.contactInfo : null,
                            phone: !isEmail ? widget.contactInfo : null,
                            password: widget.password,
                            data: {
                              'first_name': _firstNameController.text,
                              'last_name': _lastNameController.text,
                              'phone': _phoneController.text,
                              'country_code': _selectedCountry,
                              'dob': _birthDateController.text,
                            },
                          );

                          // On success, navigate to HomeScreen
                          nav.pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const HomeScreen()),
                            (route) => false,
                          );
                        } catch (e) {
                          sm.showSnackBar(
                            SnackBar(content: Text('Sign up failed: ${e.toString()}')),
                          );
                        }
                      }
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003366),
                      disabledBackgroundColor: const Color(0xFF003366).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (val) =>
                          setState(() => _agreedToTerms = val ?? false),
                    ),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: "I read the ",
                          children: [
                            TextSpan(
                              text: "Terms and Conditions",
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ComingSoonScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

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
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
