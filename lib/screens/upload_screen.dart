import 'package:flutter/material.dart';
import 'results_screen.dart';

// TODO (Member 4): Wire up file_picker here
// TODO (Member 3): Call AiService.analyzeResume() after file is picked
// TODO (Member 2): Call StorageService.uploadResume() after file is picked

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _jobDescController = TextEditingController();
  bool _isLoading = false;
  String? _selectedFileName;

  void _pickFile() {
    // TODO (Member 4): Replace with real file picker:
    // final file = await FileService().pickResumePDF();
    // if (file != null) setState(() => _selectedFileName = file.path.split('/').last);

    // Mock file selection for now
    setState(() => _selectedFileName = 'my_resume.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('📎 File picker coming soon (Member 4\'s task)')),
    );
  }

  Future<void> _analyzeResume() async {
    if (_selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a resume first.')),
      );
      return;
    }

    if (_jobDescController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a job description.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO (Member 3): Replace with real Gemini call:
    // final result = await AiService().analyzeResume(resumeText, jobDesc);
    // Navigator.push(context, MaterialPageRoute(builder: (_) => ResultsScreen(data: result)));

    // Mock delay to simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to results with mock data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResultsScreen(
          mockMode: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _jobDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analyze Resume')),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step 1 - Upload
            _SectionLabel(number: '1', title: 'Upload Your Resume'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedFileName != null
                        ? const Color(0xFF4F46E5)
                        : Colors.grey[300]!,
                    width: _selectedFileName != null ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      _selectedFileName != null
                          ? Icons.check_circle_rounded
                          : Icons.upload_file_rounded,
                      size: 44,
                      color: _selectedFileName != null
                          ? const Color(0xFF4F46E5)
                          : Colors.grey[400],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _selectedFileName ?? 'Tap to upload PDF',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _selectedFileName != null
                            ? const Color(0xFF4F46E5)
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedFileName != null
                          ? 'Tap to change file'
                          : 'PDF files only',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Step 2 - Job description
            _SectionLabel(number: '2', title: 'Paste Job Description'),
            const SizedBox(height: 12),
            TextField(
              controller: _jobDescController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText:
                    'Paste the job description you\'re applying for here...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 28),

            // Analyze button
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
                onPressed: _isLoading ? null : _analyzeResume,
                style: ElevatedButton.styleFrom(elevation: 0),
                icon: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(
                  _isLoading ? 'Analyzing...' : 'Analyze with AI',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Dev note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '🔧 Dev note: File picker → Member 4. AI analysis → Member 3. Storage → Member 2.',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String number;
  final String title;

  const _SectionLabel({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF4F46E5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1B4B))),
      ],
    );
  }
}
