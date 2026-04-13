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
  final _answerController = TextEditingController();
  Map<String, dynamic>? _feedback;

  // Mock questions — replace with real AI-generated questions (Member 3)
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
    // setState(() { _questions = questions; _sessionStarted = true; });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _sessionStarted = true;
      _currentQuestionIndex = 0;
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

    // TODO (Member 3): Replace with real feedback call:
    // final feedback = await AiService().getAnswerFeedback(
    //   question: _mockQuestions[_currentQuestionIndex],
    //   answer: _answerController.text,
    // );

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _feedback = {
        'tone': 4,
        'keywords_used': ['experience', 'team', 'project'],
        'keywords_missing': ['metrics', 'outcome'],
        'tip': 'Great structure! Try adding specific numbers or outcomes to make your answer more impactful.',
      };
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _mockQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answerController.clear();
        _feedback = null;
      });
    } else {
      // All questions done
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Session Complete! 🎉'),
          content: const Text(
              'You\'ve answered all questions. Great practice!'),
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
        color: const Color(0xFFCBEAFF),
        height: 5,
      ),
      ),
      ),
      
      backgroundColor: Colors.grey[50],
      body: _sessionStarted ? _buildSession() : _buildSetup(),
    );
  }

  Widget _buildSetup() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                  color: const Color(0xFF059669).withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.mic_rounded, color: Color(0xFF059669), size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Mock Interview',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669))),
                      Text(
                          '5 questions tailored to your target role',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('Job Title *',
              style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
              style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: _jobDescController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Paste job description for more tailored questions...',
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _startSession,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669)),
              icon: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.play_arrow_rounded),
              label: Text(
                _isLoading ? 'Generating questions...' : 'Start Interview',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Text(
              '🔧 Dev note: Real question generation → Member 3\'s task.',
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSession() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Row(
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1} of ${_mockQuestions.length}',
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                '${((_currentQuestionIndex + 1) / _mockQuestions.length * 100).round()}%',
                style: const TextStyle(
                    color: Color(0xFF059669), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: LinearProgressIndicator(
              value:
                  (_currentQuestionIndex + 1) / _mockQuestions.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF059669)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 24),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border:
                  Border.all(color: const Color(0xFF059669).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Question',
                    style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  _mockQuestions[_currentQuestionIndex],
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E1B4B),
                      height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Answer input
          const Text('Your Answer',
              style:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _answerController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Type your answer here...',
            ),
          ),
          const SizedBox(height: 16),

          if (_feedback == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitAnswer,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669)),
                icon: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _isLoading ? 'Getting feedback...' : 'Submit Answer',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // Feedback section
          if (_feedback != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Feedback',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                          fontSize: 15)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Tone Score: ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < (_feedback!['tone'] as int)
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    children: (_feedback!['keywords_used'] as List)
                        .map((k) => Chip(
                              label: Text(k.toString(),
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: Colors.green[100],
                              side: BorderSide.none,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '💡 ${_feedback!['tip']}',
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669)),
                child: Text(
                  _currentQuestionIndex < _mockQuestions.length - 1
                      ? 'Next Question →'
                      : 'Finish Session 🎉',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
