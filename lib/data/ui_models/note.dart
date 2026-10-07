import 'package:equatable/equatable.dart';

/// A note in lightweight Markdown (see `markdown_lite.dart`), optionally
/// about a student or a lesson.
class Note extends Equatable {
  final int? id;
  final String title;
  final String body;
  final int? studentId;
  final int? lessonId;
  final bool isPinned;
  final DateTime? updatedAt;

  /// What the note is linked to, for display; filled in when loaded.
  final String? studentName;
  final String? lessonName;
  final DateTime? lessonStart;

  const Note({
    this.id,
    this.title = '',
    this.body = '',
    this.studentId,
    this.lessonId,
    this.isPinned = false,
    this.updatedAt,
    this.studentName,
    this.lessonName,
    this.lessonStart,
  });

  bool get isBlank => title.trim().isEmpty && body.trim().isEmpty;

  bool get isLinked => studentId != null || lessonId != null;

  /// [studentId] and [lessonId] take builders so they can be cleared.
  Note copyWith({
    int? id,
    String? title,
    String? body,
    int? Function()? studentId,
    int? Function()? lessonId,
    bool? isPinned,
    DateTime? updatedAt,
    String? Function()? studentName,
    String? Function()? lessonName,
    DateTime? Function()? lessonStart,
  }) {
    final studentChanged = studentId != null;
    final lessonChanged = lessonId != null;
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      studentId: studentChanged ? studentId() : this.studentId,
      lessonId: lessonChanged ? lessonId() : this.lessonId,
      isPinned: isPinned ?? this.isPinned,
      updatedAt: updatedAt ?? this.updatedAt,
      // A changed link makes the old display names stale.
      studentName: studentName != null
          ? studentName()
          : studentChanged
          ? null
          : this.studentName,
      lessonName: lessonName != null
          ? lessonName()
          : lessonChanged
          ? null
          : this.lessonName,
      lessonStart: lessonStart != null
          ? lessonStart()
          : lessonChanged
          ? null
          : this.lessonStart,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    studentId,
    lessonId,
    isPinned,
    updatedAt,
    studentName,
    lessonName,
    lessonStart,
  ];
}
