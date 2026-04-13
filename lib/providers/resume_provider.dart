import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';

class ResumeState {
  final Map<String, dynamic>? result;
  final bool isLoading; 
  final String? error;

  ResumeState({this.result, this.isLoading = false, this.error}); 

  int get score => result?['score'] ?? 0;
  List<String> get suggestions => List<String>.from(result?['suggestions'] ?? []);
  List<String> get keywordsFound => List<String>.from(result?['keywords_found'] ?? []);
  List<String> get keywordsMissing => List<String>.from(result?['keywords_missing'] ?? []);
}

class ResumeNotifier extends StateNotifier<ResumeState> {
  ResumeNotifier() : super(ResumeState());

  Future<void> analyzeResume(List<int> pdfBytes) async {
    state = ResumeState(isLoading: true);
    try {
      final result = await AIService.reviewResume(pdfBytes);
      state = ResumeState(result: result as Map<String, dynamic>?);
    } catch (e) {
      state = ResumeState(error: e.toString());
    }
  }
}

final resumeProvider = StateNotifierProvider<ResumeNotifier, ResumeState>((ref) => ResumeNotifier(),);