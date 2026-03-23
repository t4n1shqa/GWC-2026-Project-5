
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO (Member 2): Replace with real Firebase auth stream
// import 'package:firebase_auth/firebase_auth.dart';
// final authStateProvider = StreamProvider<User?>((ref) {
//   return FirebaseAuth.instance.authStateChanges();
// });

// Placeholder auth provider — replace with Firebase stream (Member 2)
final authStateProvider = StateProvider<String?>((ref) => null);

// Resume state
class ResumeState {
  final String? fileName;
  final Map<String, dynamic>? analysisResult;
  final bool isLoading;

  const ResumeState({
    this.fileName,
    this.analysisResult,
    this.isLoading = false,
  });

  ResumeState copyWith({
    String? fileName,
    Map<String, dynamic>? analysisResult,
    bool? isLoading,
  }) {
    return ResumeState(
      fileName: fileName ?? this.fileName,
      analysisResult: analysisResult ?? this.analysisResult,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final resumeProvider = StateProvider<ResumeState>((ref) => const ResumeState());
