import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';

class ResumeState {
  final String? feedback;
  final bool isLoading; 
  final String? error;

  ResumeState({this.feedback, this.isLoading = false, this.error});
}

class ResumeNotifier extends StateNotifier<ResumeState> {
  ResumeNotifier() : super(ResumeState());

  Future<void> analyzeResume(List<int> pdfBytes) async {
    state = ResumeState(isLoading: true);
    try {
      final feedback = await AIService.reviewResume(pdfBytes);
      state = ResumeState(feedback: feedback);
    } catch (e) {
      state = ResumeState(error: e.toString());
    }
  }
}

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeState>((ref) => ResumeNotifier(),);