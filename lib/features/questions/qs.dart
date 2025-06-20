import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MagicalQuizScreen extends StatefulWidget {
  final String story;
  const MagicalQuizScreen({Key? key, required this.story}) : super(key: key);

  @override
  State<MagicalQuizScreen> createState() => _MagicalQuizScreenState();
}

class _MagicalQuizScreenState extends State<MagicalQuizScreen>
    with SingleTickerProviderStateMixin {
  int currentQuestion = 0;
  int? selectedAnswer;
  bool? isCorrect;
  late AnimationController _controller;

  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final response = await http.post(
        Uri.parse('https://fe48-34-138-27-209.ngrok-free.app/generate-mcqs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'story': widget.story}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> mcqs = data['mcqs'] ?? [];
        questions =
            mcqs
                .map<Map<String, dynamic>>(
                  (q) => {
                    'question': q['question'],
                    'answers': [
                      {'text': q['A'], 'option': 'A'},
                      {'text': q['B'], 'option': 'B'},
                      {'text': q['C'], 'option': 'C'},
                    ],
                    'correct_answer': q['correct_answer'],
                  },
                )
                .toList();
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void selectAnswer(int index) {
    if (selectedAnswer != null) return;
    setState(() {
      selectedAnswer = index;
      isCorrect =
          questions[currentQuestion]['answers'][index]['option'] ==
          questions[currentQuestion]['correct_answer'];
    });
    _controller.forward(from: 0);
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        selectedAnswer = null;
        isCorrect = null;
      } else {
        // Show celebration
        showDialog(
          context: context,
          builder:
              (_) => _CelebrationDialog(
                onClose: () {
                  Navigator.of(context).pop();
                  setState(() {
                    currentQuestion = 0;
                    selectedAnswer = null;
                    isCorrect = null;
                  });
                },
              ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildBackground() {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe0c3fc), Color(0xFF8ec5fc)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Floating stars and clouds
        ...List.generate(10, (i) {
          final random = Random(i);
          return Positioned(
            left: random.nextDouble() * 300,
            top: random.nextDouble() * 600,
            child: Icon(
              Icons.star,
              color: Colors.white.withOpacity(0.2 + random.nextDouble() * 0.3),
              size: 24.0 + random.nextDouble() * 16,
            ),
          );
        }),
        ...List.generate(3, (i) {
          final random = Random(i + 100);
          return Positioned(
            left: random.nextDouble() * 250,
            top: 100.0 + random.nextDouble() * 400,
            child: Icon(
              Icons.cloud,
              color: Colors.white.withOpacity(0.18),
              size: 60.0 + random.nextDouble() * 30,
            ),
          );
        }),
      ],
    );
  }

  Widget buildProgressBar() {
    double progress = (currentQuestion + 1) / questions.length;
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.02,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.02,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf7971e), Color(0xFFffd200)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Positioned(
                right: 0,
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.purple,
                  size: MediaQuery.of(context).size.height * 0.03,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        Text(
          '${currentQuestion + 1} / ${questions.length}',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasError || questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text('Failed to load quiz questions.'),
              SizedBox(height: 16),
              ElevatedButton(onPressed: fetchQuestions, child: Text('Retry')),
            ],
          ),
        ),
      );
    }
    final q = questions[currentQuestion];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          buildBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: screenSize.height * 0.02,
              ),
              child: Column(
                children: [
                  // Magical Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.amber,
                        size: screenSize.height * 0.04,
                      ),
                      SizedBox(width: screenSize.width * 0.02),

                      SizedBox(width: screenSize.width * 0.02),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: screenSize.height * 0.04,
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  buildProgressBar(),
                  SizedBox(height: screenSize.height * 0.03),
                  // Question Card
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AnimatedOpacity(
                            opacity: selectedAnswer == null ? 1.0 : 0.5,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: EdgeInsets.all(screenSize.width * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.07),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Text(
                                q['question'],
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontSize: screenSize.height * 0.025,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.03),
                          // Answer Buttons
                          ...List.generate(q['answers'].length, (i) {
                            final answer = q['answers'][i];
                            final isSelected = selectedAnswer == i;
                            final correct =
                                answer['option'] == q['correct_answer'];
                            Color color;
                            if (selectedAnswer == null) {
                              color =
                                  [
                                    Colors.pinkAccent,
                                    Colors.blueAccent,
                                    Colors.purpleAccent,
                                  ][i];
                            } else if (isSelected && isCorrect == true) {
                              color = Colors.green;
                            } else if (isSelected && isCorrect == false) {
                              color = Colors.redAccent;
                            } else {
                              color = Colors.grey.shade300;
                            }
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01,
                              ),
                              child: ElevatedButton(
                                onPressed:
                                    selectedAnswer == null
                                        ? () => selectAnswer(i)
                                        : null,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenSize.height * 0.015,
                                  ),
                                  child: Text(
                                    answer['text'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: screenSize.height * 0.022,
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size.fromHeight(
                                    screenSize.height * 0.07,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: isSelected ? 8 : 2,
                                ),
                              ),
                            );
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          // Feedback Animation
                          if (selectedAnswer != null)
                            AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                if (isCorrect == true) {
                                  return Opacity(
                                    opacity: 1 - _controller.value,
                                    child: Icon(
                                      Icons.auto_awesome,
                                      color: Colors.amber,
                                      size:
                                          screenSize.height * 0.08 +
                                          screenSize.height *
                                              0.05 *
                                              _controller.value,
                                    ),
                                  );
                                } else {
                                  return Transform.translate(
                                    offset: Offset(
                                      sin(_controller.value * pi * 6) * 10,
                                      0,
                                    ),
                                    child: Icon(
                                      Icons.sentiment_dissatisfied,
                                      color: Colors.redAccent,
                                      size: screenSize.height * 0.06,
                                    ),
                                  );
                                }
                              },
                            ),
                          SizedBox(height: screenSize.height * 0.02),
                          // Navigation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.purple,
                                  size: screenSize.height * 0.025,
                                ),
                                label: Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.height * 0.02,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.purple),
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05,
                                    vertical: screenSize.height * 0.015,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed:
                                    selectedAnswer != null
                                        ? nextQuestion
                                        : null,
                                icon: Icon(
                                  currentQuestion == questions.length - 1
                                      ? Icons.celebration
                                      : Icons.arrow_forward,
                                  color: Colors.white,
                                  size: screenSize.height * 0.025,
                                ),
                                label: Text(
                                  currentQuestion == questions.length - 1
                                      ? 'Finish'
                                      : 'Next',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenSize.height * 0.02,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05,
                                    vertical: screenSize.height * 0.015,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Celebration dialog with confetti/fireworks
class _CelebrationDialog extends StatefulWidget {
  final VoidCallback onClose;
  const _CelebrationDialog({required this.onClose});

  @override
  State<_CelebrationDialog> createState() => _CelebrationDialogState();
}

class _CelebrationDialogState extends State<_CelebrationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 320,
        height: 320,
        child: Stack(
          children: [
            // Fireworks/confetti
            ...List.generate(20, (i) {
              final angle = 2 * pi * i / 20;
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final radius = 80 + 40 * sin(_controller.value * pi * 2);
                  return Positioned(
                    left: 160 + radius * cos(angle) - 8,
                    top: 160 + radius * sin(angle) - 8,
                    child: Icon(
                      Icons.star,
                      color: Colors.primaries[i % Colors.primaries.length],
                      size: 16 + 8 * sin(_controller.value * pi * 2 + i),
                    ),
                  );
                },
              );
            }),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration, color: Colors.amber, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Congratulations!',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You finished the quiz!',
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.onClose,
                    child: const Text('Back to Story'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
