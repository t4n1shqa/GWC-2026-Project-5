import 'package:flutter/material.dart';

// TODO (Member 3): Replace mockMode with real data from AiService.analyzeResume()
// Pass the result map into this screen as a constructor parameter

class ResultsScreen extends StatelessWidget {
  final bool mockMode;

  const ResultsScreen({super.key, this.mockMode = false});

  // Mock data — replace with real AI response when Member 3 is done
  Map<String, dynamic> get _mockData => {
        'score': 72,
        'suggestions': [
          'Add measurable achievements (e.g. "increased sales by 30%")',
          'Include more keywords from the job description',
          'Strengthen your summary section with specific skills',
        ],
        'keywords_found': ['Flutter', 'Dart', 'Firebase', 'Git'],
        'keywords_missing': ['CI/CD', 'REST APIs', 'Agile', 'Unit Testing'],
      };

  @override
  Widget build(BuildContext context) {
    final data = _mockData;
    final score = data['score'] as int;
    final suggestions = data['suggestions'] as List;
    final keywordsFound = data['keywords_found'] as List;
    final keywordsMissing = data['keywords_missing'] as List;

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results')),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mockMode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: const Text(
                  '🔧 Showing mock data. Real AI results coming from Member 3.',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ),

            // Score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Resume Score',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    '$score / 100',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: score / 100,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Suggestions
            _SectionTitle(
                icon: Icons.lightbulb_rounded,
                title: 'Suggestions',
                color: Colors.amber[700]!),
            const SizedBox(height: 10),
            ...suggestions.map((s) => _SuggestionCard(text: s.toString())),
            const SizedBox(height: 24),

            // Keywords found
            _SectionTitle(
                icon: Icons.check_circle_rounded,
                title: 'Keywords Found',
                color: Colors.green),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keywordsFound
                  .map((k) => _KeywordChip(
                      label: k.toString(), found: true))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // Keywords missing
            _SectionTitle(
                icon: Icons.cancel_rounded,
                title: 'Keywords Missing',
                color: Colors.red),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keywordsMissing
                  .map((k) => _KeywordChip(
                      label: k.toString(), found: false))
                  .toList(),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Analyze Another Resume'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFF4F46E5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B))),
      ],
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String text;

  const _SuggestionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ',
              style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.5))),
        ],
      ),
    );
  }
}

class _KeywordChip extends StatelessWidget {
  final String label;
  final bool found;

  const _KeywordChip({required this.label, required this.found});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: found ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: found ? Colors.green[300]! : Colors.red[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: found ? Colors.green[700] : Colors.red[700],
            fontWeight: FontWeight.w600,
            fontSize: 13),
      ),
    );
  }
}
