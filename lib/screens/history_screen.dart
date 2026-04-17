import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'results_screen.dart';
import 'interview_screen.dart';

// TODO (Member 2): Replace mock data with real Firestore queries
// Query: FirebaseFirestore.instance.collection('users').doc(uid).collection('sessions').get()

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

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  // Mock history data — replace with Firestore data (Member 2)
  List<Map<String, dynamic>> get _mockHistory => [
        {
          'type': 'resume',
          'title': 'Software Engineer Resume',
          'date': 'Mar 15, 2026',
          'score': 72,
          'suggestions': [
            'Add measurable impact to your bullet points (e.g. "reduced load time by 30%").',
            'Include a skills section with relevant technologies.',
            'Tailor your summary to the specific job description.',
          ],
          'keywords_found': ['Python', 'Git', 'REST API', 'Agile'],
          'keywords_missing': ['Docker', 'CI/CD', 'TypeScript', 'AWS'],
        },
        {
          'type': 'interview',
          'title': 'Product Manager Interview',
          'date': 'Mar 12, 2026',
          'questions': 5,
          'sessions': [
            {
              'question': 'Tell me about yourself and why you\'re interested in this role.',
              'answer': 'I\'ve spent the past three years working in product operations, collaborating closely with engineering and design teams. I\'m drawn to this PM role because I want to take a more strategic part in defining the product vision.',
              'overall_score': 4,
              'response': 'Your answer showed strong self-awareness and a clear connection to the role.',
              'items': [
                {'label': 'Clarity', 'score': 4},
                {'label': 'Relevance', 'score': 4},
                {'label': 'Specificity', 'score': 3},
              ],
              'feedback': 'Try adding a specific achievement or metric to make your background more concrete.',
            },
            {
              'question': 'Describe a product you admire and why.',
              'answer': 'I really admire Notion because it balances power and simplicity. It lets users build their own workflows without overwhelming them with options upfront.',
              'overall_score': 5,
              'response': 'Excellent answer — specific product, clear reasoning, and shows strong product thinking.',
              'items': [
                {'label': 'Clarity', 'score': 5},
                {'label': 'Relevance', 'score': 5},
                {'label': 'Specificity', 'score': 4},
              ],
              'feedback': 'You could strengthen this further by discussing how you would improve the product.',
            },
            {
              'question': 'How do you prioritize features when resources are limited?',
              'answer': 'I use a combination of user impact and effort estimation. I map features on a 2x2 matrix and focus on high impact, low effort items first while keeping stakeholders aligned.',
              'overall_score': 4,
              'response': 'Good structured approach. You demonstrated familiarity with prioritization frameworks.',
              'items': [
                {'label': 'Clarity', 'score': 4},
                {'label': 'Relevance', 'score': 5},
                {'label': 'Specificity', 'score': 3},
              ],
              'feedback': 'Consider mentioning a real example where you applied this framework.',
            },
            {
              'question': 'Tell me about a time a product decision you made failed.',
              'answer': 'We launched a feature based on internal assumptions without enough user research. Adoption was low. I learned to always validate with at least a small user test before committing resources.',
              'overall_score': 5,
              'response': 'Great answer — honest, self-aware, and shows clear learning from the experience.',
              'items': [
                {'label': 'Clarity', 'score': 5},
                {'label': 'Relevance', 'score': 5},
                {'label': 'Specificity', 'score': 5},
              ],
              'feedback': 'Strong response. You could briefly mention how you changed your process going forward.',
            },
            {
              'question': 'Where do you see yourself in five years?',
              'answer': 'I hope to be leading a product team, having shipped products that made a real difference to users. I want to keep growing technically while developing my leadership skills.',
              'overall_score': 3,
              'response': 'Decent answer but somewhat generic. It would benefit from more specificity.',
              'items': [
                {'label': 'Clarity', 'score': 4},
                {'label': 'Relevance', 'score': 3},
                {'label': 'Specificity', 'score': 2},
              ],
              'feedback': 'Tie your five-year vision more specifically to this company or industry to show genuine interest.',
            },
          ],
        },
        {
          'type': 'resume',
          'title': 'UX Designer Resume',
          'date': 'Mar 8, 2026',
          'score': 85,
          'suggestions': [
            'Highlight your design process more explicitly in project descriptions.',
            'Add links to your portfolio or case studies.',
          ],
          'keywords_found': ['Figma', 'User Research', 'Wireframing', 'Prototyping', 'Accessibility'],
          'keywords_missing': ['A/B Testing', 'Design Systems', 'Sketch'],
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Text('My History'),
    leading: _backButton(context),
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/history.svg', width: 60, height: 60),
                        const SizedBox(height: 12),
                        const Text('No history yet',
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        const Text('Analyze a resume or do a mock interview!',
                            style: TextStyle(
                                color: Colors.black, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _mockHistory.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final item = _mockHistory[index];
                      final isResume = item['type'] == 'resume';
                      return GestureDetector(
                        onTap: () {
                          if (isResume) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ResultsScreen(historyData: item),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InterviewScreen(historyData: item),
                              ),
                            );
                          }
                        },
                        child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBEAFF),
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
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5FF),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: isResume
                                  ? SvgPicture.asset('assets/icons/resume.svg', width: 44, height: 44)
                                  : SvgPicture.asset('assets/icons/interview.svg', width: 44, height: 44),
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
                                        color: Colors.black, fontSize: 12),
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
                                borderRadius: BorderRadius.circular(50),
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