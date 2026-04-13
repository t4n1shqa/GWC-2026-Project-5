import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resume_provider.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resumeProvider);

    // Show loading spinner
    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show error
    if (state.error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${state.error}')),
      );
    }

    final score = state.score;
    final suggestions = state.suggestions;
    final keywordsFound = state.keywordsFound;
    final keywordsMissing = state.keywordsMissing;

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results'),
       bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: Container(
        color: const Color(0xFF80B8F6),
        height: 5,
      ),),),
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Score card — full width, no padding
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
             color: Color(0xFFCBEAFF),
             border: Border(
              bottom: BorderSide(color: Color(0xFFE8F5FF), width: 5),
             ),
            ),
            child: Column(
              children: [
                const Text('Resume Score',
                    style: TextStyle(color: Color(0xFF3382EC), fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  '$score / 100',
                  style: const TextStyle(
                      color: Color(0xFF1E1B4B),
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.white,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF3382EC)),
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),

            // Suggestions
            _SectionTitle(
                icon: Icons.lightbulb_rounded,
                title: 'Suggestions',
                color: Colors.amber[700]!),
            const SizedBox(height: 10),
            ...suggestions.map((s) => _SuggestionCard(text: s)),
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
                  .map((k) => _KeywordChip(label: k, found: true))
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
                  .map((k) => _KeywordChip(label: k, found: false))
                  .toList(),
            ),
            const SizedBox(height: 30),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF7BBFEE),
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Color(0xFFEEF8FF),
                    offset: Offset(0, -4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(elevation: 0),
                icon: const Icon(Icons.upload_file_rounded),
                label: const Text('Analyze Another Resume',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
        color: Color (0xFFE8F5FF),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color(0xFF3382EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('•  ',
              style: TextStyle(
                  color: Color(0xFF4F46E5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, height: 1.5, fontWeight: FontWeight.w600))),
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
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
            color: found ? Color (0xFF3382EC) : Color (0xFF3382EC)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: found ? Colors.black : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 13),
      ),
    );
  }
}
