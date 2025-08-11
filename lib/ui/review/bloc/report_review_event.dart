part of 'report_review_bloc.dart';

sealed class ReportReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// 신고 전송
class SendReport extends ReportReviewEvent {
  final String title;
  final String content;

  SendReport({
    required this.title,
    required this.content,
  });
}