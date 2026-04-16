import 'package:flutter/material.dart';

// TODO (Member 3): Wire up AiService.generateInterviewQuestions() here
// TODO (Member 3): Wire up AiService.getAnswerFeedback() after each answer

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  final _jobTitleController = TextEditingController();
  final _jobDescController = TextEditingController();
  bool _sessionStarted = false;
  bool _isLoading = false;
  int _currentQuestionIndex = 0;
  int _viewingIndex = 0;
  final _answerController = TextEditingController();
  final List<Map<String, dynamic>?> _allFeedback = [null, null, null, null, null];
  final List<String?> _allAnswers = [null, null, null, null, null];

  final List<String> _mockQuestions = [
    'Tell me about yourself and why you\'re interested in this role.',
    'Describe a challenging project you worked on and how you handled it.',
    'How do you prioritize tasks when working on multiple projects?',
    'Where do you see yourself in 5 years?',
    'Do you have any questions for us?',
  ];

  Future<void> _startSession() async {
    if (_jobTitleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job title.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO (Member 3): Replace with real call:
    // final questions = await AiService().generateInterviewQuestions(
    //   _jobTitleController.text, _jobDescController.text);

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _sessionStarted = true;
      _currentQuestionIndex = 0;
      _viewingIndex = 0;
    });
  }

  Future<void> _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type your answer first.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO (Member 3): Replace with real feedback call

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _allAnswers[_currentQuestionIndex] = _answerController.text;
      _allFeedback[_currentQuestionIndex] = {
        'overall_score': 3,
        'response': 'Your answer demonstrated good understanding of the topic. You communicated your experience clearly and showed relevant skills.',
        'items': [
          {'label': 'Clarity', 'score': 4},
          {'label': 'Relevance', 'score': 3},
          {'label': 'Specificity', 'score': 3},
        ],
        'feedback': 'Try adding specific numbers or outcomes to make your answer more impactful. Mentioning metrics will strengthen your response.',
      };
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _mockQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _viewingIndex = _currentQuestionIndex;
        _answerController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Session Complete! 🎉'),
          content: const Text('You\'ve answered all questions. Great practice!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Interview'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            color: const Color(0xFF80B8F6),
            height: 5,
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: _sessionStarted ? _buildSession() : _buildSetup(),
    );
  }

  Widget _buildSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full-width banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Color(0xFFCBEAFF),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE8F5FF), width: 5),
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.mic_rounded, color: Color(0xFF3382EC), size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Mock Interview',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1B4B))),
                    Text('5 questions tailored to your target role',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                const Text('Job Title *',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _jobTitleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Software Engineer Intern',
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                ),
                const SizedBox(height: 18),

                const Text('Job Description (optional)',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 6),
                TextField(
                  controller: _jobDescController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Paste job description for more tailored questions...',
                  ),
                ),
                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(color: Color(0xFF7BBFEE), offset: Offset(0, 4), blurRadius: 0),
                      BoxShadow(color: Color(0xFFEEF8FF), offset: Offset(0, -4), blurRadius: 0),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _startSession,
                    style: ElevatedButton.styleFrom(elevation: 0),
                    icon: _isLoading
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      _isLoading ? 'Generating questions...' : 'Start Interview',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSession() {
    final isViewingPast = _viewingIndex < _currentQuestionIndex;
    final viewedFeedback = _allFeedback[_viewingIndex];

    return Column(
      children: [
        // Step indicator panel — circles, question, overall score
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFCBEAFF),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE8F5FF), width: 5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Step circles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_mockQuestions.length, (i) {
                  final isActive = i == _currentQuestionIndex;
                  final isPast = i < _currentQuestionIndex;
                  return GestureDetector(
                    onTap: isPast
                        ? () => setState(() => _viewingIndex = i)
                        : isActive
                            ? () => setState(() => _viewingIndex = _currentQuestionIndex)
                            : null,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? const Color(0xFF3382EC)
                            : isPast
                                ? const Color(0xFFCBEAFF)
                                : Colors.white,
                        border: isPast ? null : Border.all(color: const Color(0xFF3382EC), width: 1.5),
                        boxShadow: isPast
                            ? const [
                                BoxShadow(color: Color(0xFF7BBFEE), offset: Offset(0, 3), blurRadius: 0),
                                BoxShadow(color: Color(0xFFEEF8FF), offset: Offset(0, -3), blurRadius: 0),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : const Color(0xFF3382EC),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 12),
              // Question text
              Text(
                _mockQuestions[_viewingIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E1B4B),
                    height: 1.5),
              ),
              // Overall score — shown after feedback is returned
              if (viewedFeedback != null) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Overall Score  ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1B4B))),
                    ...List.generate(5, (i) => Icon(
                      i < (viewedFeedback['overall_score'] as int)
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFF3382EC),
                      size: 24,
                    )),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                if (isViewingPast) ...[
                  // Viewing a past question — show stored feedback + back button
                  if (_allAnswers[_viewingIndex] != null) ...[
                    const Text('Your Answer',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5FF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
                      ),
                      child: Text(
                        _allAnswers[_viewingIndex]!,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (viewedFeedback != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5FF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
                      ),
                      child: Text(
                        viewedFeedback['response'] as String,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(
                      (viewedFeedback['items'] as List).length,
                      (i) {
                        final item = (viewedFeedback['items'] as List)[i] as Map;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBEAFF),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text('${i + 1}  ${item['label']}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBEAFF),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: List.generate(5, (s) => Icon(
                                    s < (item['score'] as int)
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: const Color(0xFF3382EC),
                                    size: 18,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5FF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
                      ),
                      child: Text(
                        viewedFeedback['feedback'] as String,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(color: Color(0xFF7BBFEE), offset: Offset(0, 4), blurRadius: 0),
                        BoxShadow(color: Color(0xFFEEF8FF), offset: Offset(0, -4), blurRadius: 0),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _viewingIndex = _currentQuestionIndex),
                      style: ElevatedButton.styleFrom(elevation: 0),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text(
                        'Back to Current Question',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ] else ...[
                  // Current question — answer input + submit / feedback
                  const Text('Your Answer',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _answerController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Type your answer here...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (viewedFeedback == null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF7BBFEE), offset: Offset(0, 4), blurRadius: 0),
                          BoxShadow(color: Color(0xFFEEF8FF), offset: Offset(0, -4), blurRadius: 0),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitAnswer,
                        style: ElevatedButton.styleFrom(elevation: 0),
                        icon: _isLoading
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                        label: Text(
                          _isLoading ? 'Getting feedback...' : 'Submit Answer',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  if (viewedFeedback != null) ...[
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5FF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
                      ),
                      child: Text(
                        viewedFeedback['response'] as String,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(
                      (viewedFeedback['items'] as List).length,
                      (i) {
                        final item = (viewedFeedback['items'] as List)[i] as Map;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBEAFF),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Text('${i + 1}  ${item['label']}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFCBEAFF),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Row(
                                  children: List.generate(5, (s) => Icon(
                                    s < (item['score'] as int)
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    color: const Color(0xFF3382EC),
                                    size: 18,
                                  )),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5FF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
                      ),
                      child: Text(
                        viewedFeedback['feedback'] as String,
                        style: const TextStyle(fontSize: 13, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(color: Color(0xFF7BBFEE), offset: Offset(0, 4), blurRadius: 0),
                          BoxShadow(color: Color(0xFFEEF8FF), offset: Offset(0, -4), blurRadius: 0),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        style: ElevatedButton.styleFrom(elevation: 0),
                        child: Text(
                          _currentQuestionIndex < _mockQuestions.length - 1
                              ? 'Next Question →'
                              : 'Finish Session 🎉',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}