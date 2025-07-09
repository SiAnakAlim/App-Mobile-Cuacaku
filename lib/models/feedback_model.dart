import 'package:hive/hive.dart';

part 'feedback_model.g.dart';

@HiveType(typeId: 2) // Gunakan typeId yang unik, yaitu 2 (karena 0 dan 1 sudah dipakai User dan WeatherData)
class FeedbackModel extends HiveObject {
  @HiveField(0)
  final double rating;

  @HiveField(1)
  final String feedbackText;

  @HiveField(2)
  final DateTime submissionDate;

  FeedbackModel({
    required this.rating,
    required this.feedbackText,
    required this.submissionDate,
  });
}