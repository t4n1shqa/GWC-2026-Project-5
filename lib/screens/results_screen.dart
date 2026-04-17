import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resume_provider.dart';

class ResultsScreen extends ConsumerWidget {
  /// Pass [historyData] to show a saved result directly without using the provider.
  final Map<String, dynamic>? historyData;

  const ResultsScreen({super.key, this.historyData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int score;
    final List<String> suggestions;
    final List<String> keywordsFound;
    final List<String> keywordsMissing;

    if (historyData != null) {
      score = (historyData!['score'] as num?)?.toInt() ?? 0;
      suggestions = List<String>.from(historyData!['suggestions'] ?? []);
      keywordsFound = List<String>.from(historyData!['keywords_found'] ?? []);
      keywordsMissing = List<String>.from(historyData!['keywords_missing'] ?? []);
    } else {
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

      score = state.score;
      suggestions = state.suggestions;
      keywordsFound = state.keywordsFound;
      keywordsMissing = state.keywordsMissing;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results'), leading: _backButton(context),
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
                      color: Colors.black,
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
                icon: null,
                title: 'Suggestions',
                color: Colors.amber[700]!),
            const SizedBox(height: 10),
            ...suggestions.map((s) => _SuggestionCard(text: s)),
            const SizedBox(height: 24),

            // Keywords found
            _SectionTitle(
                icon: Icons.check_circle_rounded,
                title: 'Keywords Found',
                color: Color(0xFF3382EC)),
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
                color: Color(0xFF3382EC)),
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

Widget _backButton(BuildContext context) => IconButton(
  icon: Transform.flip(
    flipX: true,
    child: SvgPicture.asset(
      'assets/icons/arrow.svg',
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    ),
  ),
  onPressed: () => Navigator.maybePop(context),
);

class _SectionTitle extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Color color;

  const _SectionTitle(
      {required this.icon, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
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
        border: Border.all(color: Color(0xFF3382EC), width: 1.5),
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
        color: found ? Color (0xFFCBEAFF) : Color (0xFFCBEAFF),
        borderRadius: BorderRadius.circular(50),
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