enum RatePeriod { daily, monthly }

enum LessonStatus {
  scheduled,
  cancelled,
  completed;

  String label({bool isNow = false}) {
    return switch (this) {
      .scheduled => isNow ? 'In Progress' : 'Scheduled',
      .cancelled => 'Cancelled',
      .completed => 'Completed',
    };
  }
}
