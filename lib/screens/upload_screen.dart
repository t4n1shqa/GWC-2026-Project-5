import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/resume_provider.dart';
import 'results_screen.dart';

class UploadScreen extends ConsumerStatefulWidget {  
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {  
  final _jobDescController = TextEditingController();
  String? _selectedFileName;
  List<int>? _pdfBytes;  // ← store the actual file bytes

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,  // ← gives us the bytes directly
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _pdfBytes = result.files.single.bytes!.toList();
      });
    }
  }

  Future<void> _analyzeResume() async {
    if (_pdfBytes == null) {
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

    // Call the provider which calls AiService
    await ref.read(resumeProvider.notifier).analyzeResume(_pdfBytes!);

    if (!mounted) return;

    // Check if it errored
    final state = ref.read(resumeProvider);
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
      return;
    }

    // Navigate to results
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  @override
  void dispose() {
    _jobDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resumeProvider);  // ← watch for loading state
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Analyze Resume'), leading: _backButton(context),  bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: Container(
        color: const Color(0xFFCBEAFF),
        height: 5,
      ),),),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionLabel(number: '1', title: 'Upload Your Resume'),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: _selectedFileName != null
                        ? const Color(0xFF3382EC)
                        : Colors.grey[300]!,
                    width: _selectedFileName != null ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    _selectedFileName != null
                        ? const Icon(Icons.check_circle_rounded,
                            size: 44, color: Color(0xFF3382EC))
                        : SvgPicture.asset('assets/icons/upload.svg',
                            width: 44, height: 44),
                    const SizedBox(height: 10),
                    Text(
                      _selectedFileName ?? 'Tap to upload PDF',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _selectedFileName != null
                            ? const Color(0xFF3382EC)
                            : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedFileName != null ? 'Tap to change file' : 'PDF files only',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            _SectionLabel(number: '2', title: 'Paste Job Description'),
            const SizedBox(height: 12),
            TextField(
              controller: _jobDescController,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste the job description you\'re applying for here...',
                alignLabelWithHint: true,
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
                onPressed: isLoading ? null : _analyzeResume,
                style: ElevatedButton.styleFrom(elevation: 0),
                icon: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                label: Text(
                  isLoading ? 'Analyzing...' : 'Analyze with AI',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// _SectionLabel widget stays exactly the same as before
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

class _SectionLabel extends StatelessWidget {
  final String number;
  final String title;

  const _SectionLabel({required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF3382EC),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF3382EC), width: 1.5),
          ),
          child: Center(
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}