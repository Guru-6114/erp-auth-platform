import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const ERPAuthApp());

class ERPAuthApp extends StatelessWidget {
  const ERPAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF58CC02),
        fontFamily: 'Arial',
      ),
      home: const OnboardingFlow(),
    );
  }
}

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});
  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentFlowState = 0; // 0=GetStarted, 1=Chat, 2=Quiz
  int _currentQuestionIndex = 0;

  // Track answers for all 10 brand-new questions
  final List<String?> _quizAnswers = List.generate(10, (index) => null);

  // Totally separate Text Controllers to prevent any raw text mixing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final List<String> _languages = ['English', 'Tamil', 'Hindi', 'Spanish', 'French', 'German'];

  // --- BRAND NEW 10 QUESTIONS WITH EXPLICIT OPTION STRUCTURES ---
  final List<String> _q3Options = ["Developer", "Data Analyst", "Manager", "Intern", "Other"];
  final List<String> _q4Options = ["Remote", "On-Site", "Hybrid Office"];
  final List<String> _q7Options = ["Tech Industry", "Finance & Banking", "Healthcare", "Education", "Retail"];
  final List<String> _q8Options = ["Daily", "Weekly", "Monthly", "Rarely"];
  final List<String> _q10Options = ["Slack/Teams", "Email Updates", "In-App Alerts", "Phone Calls"];

  void _advanceFlow() {
    setState(() {
      _currentFlowState++;
    });
  }

  // --- STRICT MANDATORY SUBMISSION VALIDATOR ---
  void _nextQuestion() {
    String? currentAnswer = _quizAnswers[_currentQuestionIndex];

    // 1. Check if the field is empty (Mandatory Rule)
    if (currentAnswer == null || currentAnswer.trim().isEmpty) {
      _showValidationError("This field cannot be left blank! Please make a choice or enter input.");
      return;
    }

    // 2. City Location validation rule (Question 5 / Index 4)
    if (_currentQuestionIndex == 4) {
      String text = currentAnswer.trim();
      if (text.length < 4 || !RegExp(r'[a-zA-Z]').hasMatch(text)) {
        _showValidationError("Please enter a valid, real city name (minimum 4 characters).");
        return;
      }
    }

    // 3. Security PIN exact numeric length rule (Question 9 / Index 8)
    if (_currentQuestionIndex == 8 && currentAnswer.trim().length != 4) {
      _showValidationError("Your security PIN layout must be exactly 4 digits long!");
      return;
    }

    // Advance or navigate to Login Screen
    if (_currentQuestionIndex < 9) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) => const LoginScreen(),
          transitionsBuilder: (context, anim, secAnim, child) {
            var curve = CurvedAnimation(parent: anim, curve: Curves.easeInOutCubic);
            return FadeTransition(
              opacity: curve,
              child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1.0).animate(curve), child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  void _showValidationError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: Colors.orangeAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _companyController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _buildCurrentStateWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStateWidget() {
    switch (_currentFlowState) {
      case 0: return _buildGetStartedScreen();
      case 1: return _buildMascotChatScreen();
      case 2: return _buildQuizEngineScreen();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildGetStartedScreen() {
    return Column(
      key: const ValueKey('GetStartedScreen'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Image.asset(
          "assets/mascot.png",
          height: 180,
          errorBuilder: (c, o, s) => const Icon(Icons.notifications_active, size: 120, color: Colors.white),
        ),
        const SizedBox(height: 30),
        const Text("Welcome to ERP", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        const Text("Start your journey today!", style: TextStyle(fontSize: 18, color: Colors.white70)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: _advanceFlow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("GET STARTED", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildMascotChatScreen() {
    const String introText = "Hello! I am Duo. I will help you set up your ER profile right now!";

    return Padding(
      key: const ValueKey('MascotChatScreen'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/mascot.png",
                height: 110,
                errorBuilder: (c, o, s) => const Icon(Icons.notifications_active, size: 80, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomPaint(
                  painter: ChatBubblePainter(),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: const TypewriterAnimation(
                      text: introText,
                      style: TextStyle(color: Color(0xFF3C3C3C), fontSize: 18, fontWeight: FontWeight.bold, height: 1.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _advanceFlow,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text("CONTINUE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizEngineScreen() {
    double progress = (_currentQuestionIndex + 1) / 10;

    return Padding(
      key: ValueKey('QuizEngineScreen_BaseIndex_$_currentQuestionIndex'), 
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.close, color: Colors.white70), onPressed: () => setState(() => _currentFlowState = 0)),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58CC02)),
                    minHeight: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text("${_currentQuestionIndex + 1}/10", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: _buildStrictIsolatedQuestionView(),
          ),
          ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(_currentQuestionIndex == 9 ? "FINISH CONFIGURATION" : "CONTINUE", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // --- HARD SEPARATION OF PAGES TO KILL CACHING COMPLETELY ---
  Widget _buildStrictIsolatedQuestionView() {
    if (_currentQuestionIndex == 0) {
      return _buildLanguagePicker();
    } 
    
    else if (_currentQuestionIndex == 1) {
      return _buildTextFieldView("What is your current full name?", _nameController, false, "e.g., Guruprasath CM");
    } 
    
    else if (_currentQuestionIndex == 2) {
      return _buildSelectionListView("Select your primary workplace role:", _q3Options, false);
    } 
    
    else if (_currentQuestionIndex == 3) {
      return _buildSelectionListView("What is your preferred work setup?", _q4Options, false);
    } 
    
    else if (_currentQuestionIndex == 4) {
      return _buildTextFieldView("Which city do you currently reside in?", _cityController, false, "e.g., Coimbatore");
    } 
    
    else if (_currentQuestionIndex == 5) {
      return _buildTextFieldView("Enter your organization or company name:", _companyController, false, "e.g., InnoQuick Solutions");
    } 
    
    else if (_currentQuestionIndex == 6) {
      // BRAND NEW QUESTION 7 - COMPLETELY CONFIGURED AND SECURE
      return _buildSelectionListView("Which industry vertical do you operate in?", _q7Options, false);
    } 
    
    else if (_currentQuestionIndex == 7) {
      // BRAND NEW QUESTION 8 - COMPLETELY CONFIGURED AND SECURE
      return _buildSelectionListView("How often do you use database systems?", _q8Options, false);
    } 
    
    else if (_currentQuestionIndex == 8) {
      return _buildTextFieldView("Set up a new 4-digit numeric system security PIN:", _pinController, true, "e.g., 1234");
    } 
    
    else if (_currentQuestionIndex == 9) {
      return _buildSelectionListView("Choose your preferred update notification channels:", _q10Options, true);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLanguagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Choose your local language", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 2.2),
            itemCount: _languages.length,
            itemBuilder: (context, idx) {
              bool isSelected = _quizAnswers[0] == _languages[idx];
              return InkWell(
                onTap: () => setState(() => _quizAnswers[0] = _languages[idx]),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF58CC02).withOpacity(0.2) : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? const Color(0xFF58CC02) : Colors.white24, width: isSelected ? 2.5 : 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(_languages[idx], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldView(String title, TextEditingController controller, bool isNumericOnly, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          keyboardType: isNumericOnly ? TextInputType.number : TextInputType.text,
          inputFormatters: isNumericOnly 
              ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)] 
              : [LengthLimitingTextInputFormatter(50)],
          onChanged: (text) => setState(() => _quizAnswers[_currentQuestionIndex] = text.isEmpty ? null : text),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF58CC02))),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionListView(String title, List<String> options, bool isMultiSelect) {
    String? currentAnswer = _quizAnswers[_currentQuestionIndex];
    List<String> selectedList = currentAnswer?.split(",") ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.separated(
            key: UniqueKey(), // Destroys previous choice list memory completely
            itemCount: options.length,
            separatorBuilder: (ctx, idx) => const SizedBox(height: 12),
            itemBuilder: (ctx, idx) {
              String optionText = options[idx];
              bool isSelected = selectedList.contains(optionText);

              return ListTile(
                onTap: () {
                  setState(() {
                    if (!isMultiSelect) {
                      _quizAnswers[_currentQuestionIndex] = optionText;
                    } else {
                      if (isSelected) {
                        selectedList.remove(optionText);
                      } else {
                        selectedList.add(optionText);
                      }
                      _quizAnswers[_currentQuestionIndex] = selectedList.isEmpty ? null : selectedList.join(",");
                    }
                  });
                },
                tileColor: isSelected ? const Color(0xFF58CC02).withOpacity(0.1) : Colors.white.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), 
                  side: BorderSide(
                    color: isSelected ? const Color(0xFF58CC02) : Colors.white12,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                leading: Icon(
                  isMultiSelect 
                    ? (isSelected ? Icons.check_box : Icons.check_box_outline_blank) 
                    : (isSelected ? Icons.radio_button_checked : Icons.radio_button_off), 
                  color: isSelected ? const Color(0xFF58CC02) : Colors.white60,
                ),
                title: Text(optionText, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- UTILITY TYPEWRITER WIDGET ---
class TypewriterAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration charDuration;

  const TypewriterAnimation({
    super.key,
    required this.text,
    required this.style,
    this.charDuration = const Duration(milliseconds: 30),
  });

  @override
  State<TypewriterAnimation> createState() => _TypewriterAnimationState();
}

class _TypewriterAnimationState extends State<TypewriterAnimation> {
  String _currentText = "";
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    while (_charIndex < widget.text.length) {
      await Future.delayed(widget.charDuration);
      if (mounted) {
        setState(() {
          _currentText += widget.text[_charIndex];
          _charIndex++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentText, style: widget.style);
  }
}

class ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white;
    var path = Path();
    path.moveTo(-10, 25);
    path.lineTo(15, 15);
    path.lineTo(15, 35);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ORIGINAL BUBBLE GLASSMORPHISM LOGIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _handleLogin() {
    String username = _userController.text.trim();
    String password = _passController.text.trim();

    if (username == "Guruprasath" && password == "V@nity6114") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Invalid Username or Password"), backgroundColor: Colors.red));
    }
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: RadialGradient(colors: [Color(0xFF434343), Colors.black], radius: 1.2)),
        child: Center(
          child: SingleChildScrollView(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withOpacity(0.2))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Sign In", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _userController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(hintText: "Username", hintStyle: TextStyle(color: Colors.white54), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF58CC02), width: 2)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF58CC02)))),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(hintText: "Password", hintStyle: TextStyle(color: Colors.white54), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF58CC02), width: 2)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF58CC02)))),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 5),
                        child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}