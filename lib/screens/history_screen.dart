import 'package:flutter/material.dart';

// TODO (Member 2): Replace mock data with real Firestore queries
// Query: FirebaseFirestore.instance.collection('users').doc(uid).collection('sessions').get()

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Mock history data — replace with Firestore data (Member 2)
  List<Map<String, dynamic>> get _mockHistory => [
        {
          'type': 'resume',
          'title': 'Software Engineer Resume',
          'date': 'Mar 15, 2026',
          'score': 72,
        },
        {
          'type': 'interview',
          'title': 'Product Manager Interview',
          'date': 'Mar 12, 2026',
          'questions': 5,
        },
        {
          'type': 'resume',
          'title': 'UX Designer Resume',
          'date': 'Mar 8, 2026',
          'score': 85,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('My History'),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: Container(
        color: const Color(0xFFCBEAFF),
        height: 5,
      ),
    ),
  ),
 body: Column(
      children: [
          Expanded(
            child: _mockHistory.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_rounded,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No history yet',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 6),
                        Text('Analyze a resume or do a mock interview!',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _mockHistory.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = _mockHistory[index];
                      final isResume = item['type'] == 'resume';
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isResume
                                    ? const Color(0xFF4F46E5)
                                        .withOpacity(0.1)
                                    : const Color(0xFF059669)
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                isResume
                                    ? Icons.description_rounded
                                    : Icons.mic_rounded,
                                color: isResume
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFF059669),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['date'],
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isResume
                                    ? Colors.indigo[50]
                                    : Colors.green[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isResume
                                    ? '${item['score']}/100'
                                    : '${item['questions']} Qs',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isResume
                                      ? const Color(0xFF4F46E5)
                                      : const Color(0xFF059669),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
       );
  }
}