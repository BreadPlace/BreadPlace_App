part of 'report_review_bloc.dart';

class ReportReviewState extends Equatable {
  final bool isLoading;
  final bool isReportSuccess;

  const ReportReviewState({
    this.isLoading = false,
    this.isReportSuccess = false,
  });

  @override
  List<Object?> get props => [isLoading, isReportSuccess];
}

extension ReportReviewCopy on ReportReviewState {
  ReportReviewState copyWith({
    final bool? isLoading,
    final bool? isReportSuccess,
  }) {
    return ReportReviewState(
      isLoading: isLoading ?? this.isLoading,
      isReportSuccess: isReportSuccess ?? this.isReportSuccess,
    );
  }
}