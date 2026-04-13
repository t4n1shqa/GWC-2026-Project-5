
import 'package:flutter/material.dart';
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
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _handleLogout(context),
          ),
        ],
         bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: Container(
        color: const Color(0xFFCBEAFF), // change this per page
        height: 5,
      ),
    ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi there 👋',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    // TODO (Member 2): Replace with real user name
                    // 'Welcome back, ${user?.displayName}',
                    'Ready to land your next job?',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B),
              ),
            ),
            const SizedBox(height: 16),

            // Feature cards
            _FeatureCard(
              icon: Icons.upload_file_rounded,
              title: 'Analyze My Resume',
              subtitle: 'Upload your resume and get AI-powered suggestions',
              color: const Color(0xFF4F46E5),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadScreen()),
              ),
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.mic_rounded,
              title: 'Mock Interview',
              subtitle: 'Practice with AI-generated interview questions',
              color: const Color(0xFF059669),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const InterviewScreen()),
              ),
            ),
            const SizedBox(height: 14),
            _FeatureCard(
              icon: Icons.history_rounded,
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
  final IconData icon;
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
                 boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: const Offset(0, 4),
        blurStyle: BlurStyle.inner,
      ),
    ],
              ),
              child: Icon(icon, color: color, size: 28),
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
                          color: Color(0xFF1E1B4B))),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
