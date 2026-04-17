
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'upload_screen.dart';
import 'interview_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO (Member 2): Replace with real user data from Firebase
  // final user = FirebaseAuth.instance.currentUser;

  void _handleLogout(BuildContext context) {
    // TODO (Member 2): Add FirebaseAuth.instance.signOut(); before navigating
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Resume Coach',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            tooltip: 'Log out',
            onPressed: () => _handleLogout(context),
          ),
        ],
         bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: Container(
        color: const Color(0xFFCBEAFF),
        height: 5,
      ),
    ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            _FeatureCard(
              icon: SvgPicture.asset('assets/icons/resume.svg', width: 44, height: 44),
              title: 'Analyze My Resume',
              subtitle: 'Upload your resume and get AI-powered suggestions',
              color: const Color(0xFF4F46E5),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadScreen()),
              ),
            ),
            _FeatureCard(
              icon: SvgPicture.asset('assets/icons/interview.svg', width: 44, height: 44),
              title: 'Mock Interview',
              subtitle: 'Practice with AI-generated interview questions',
              color: const Color(0xFF059669),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InterviewScreen()),
              ),
            ),
            _FeatureCard(
              icon: SvgPicture.asset('assets/icons/history.svg', width: 44, height: 44),
              title: 'My History',
              subtitle: 'View past resume analyses and interview sessions',
              color: const Color(0xFFB45309),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
         decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: const Color(0xFFCBEAFF),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5FF),
                borderRadius: BorderRadius.circular(50),
              ),
              child: icon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
            SvgPicture.asset('assets/icons/arrow.svg', width: 16, height: 16),
          ],
        ),
      ),
    );
  }
}
