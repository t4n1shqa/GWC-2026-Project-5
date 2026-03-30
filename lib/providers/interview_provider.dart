import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';

class InterviewState {
  final String? questions;
  final bool isLoading;
  final String? error;

  InterviewState({this.questions, this.isLoading = false, this.error});
}

class InterviewNotifier extends StateNotifier<InterviewState> {
  InterviewNotifier() : super(InterviewState());

  Future<void> fetchQuestions({
    required String jobRole,
    required String experienceLevel, 
    required String major,
  }) async {
    state = InterviewState(isLoading: true);
    try {
      final questions = await AIService.getInterviewQuestions(
        jobRole: jobRole, 
        experienceLevel: experienceLevel, 
        major: major,
      );
      state = InterviewState(questions: questions);
    } catch (e) {
      state = InterviewState(error: e.toString());
    }
  }
}

final interviewProvider = StateNotifierProvider<InterviewNotifier, InterviewState>((ref) => InterviewNotifier(),);