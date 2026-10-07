// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Besties Notes';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDiscard => 'Discard';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonMore => 'More';

  @override
  String get commonBack => 'Back';

  @override
  String get commonDone => 'Done';

  @override
  String commonDoneCount(int count) {
    return 'Done ($count)';
  }

  @override
  String get commonSearch => 'Search';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonNoMatches => 'No matches';

  @override
  String get commonToday => 'Today';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonTapToSelect => 'Tap to select';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonPayments => 'Payments';

  @override
  String get commonBalance => 'Balance';

  @override
  String get commonThisMonth => 'This month';

  @override
  String get commonNoLessons => 'No lessons';

  @override
  String get commonNothingOwed => 'Nothing owed';

  @override
  String get commonMembers => 'Members';

  @override
  String get commonGroup => 'Group';

  @override
  String get commonStudents => 'Students';

  @override
  String get commonGroups => 'Groups';

  @override
  String deleteNameTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navStudents => 'Students';

  @override
  String get stateErrorTitle => 'Something went wrong';

  @override
  String get stateEmptyTitle => 'Nothing here yet';

  @override
  String get stateNotFoundTitle => 'Not found';

  @override
  String get fieldRequired => 'Field cannot be empty';

  @override
  String get noStudentsAddFirst => 'No students yet. Add some first.';

  @override
  String get unsavedTitle => 'Unsaved changes';

  @override
  String get unsavedMessage => 'Save them before leaving?';

  @override
  String get unsavedSave => 'Save changes';

  @override
  String get unsavedKeepEditing => 'Keep editing';

  @override
  String get lessonStatusScheduled => 'Scheduled';

  @override
  String get lessonStatusInProgress => 'In progress';

  @override
  String get lessonStatusCompleted => 'Completed';

  @override
  String get lessonStatusCancelled => 'Cancelled';

  @override
  String get lessonUpNext => 'Up next';

  @override
  String get lessonNoOneAssigned => 'No one assigned';

  @override
  String lessonAudienceMore(String name, int count) {
    return '$name +$count';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String lessonPresentCount(int present, int total) {
    return '$present/$total present';
  }

  @override
  String lessonUnpaidCount(int count) {
    return '$count unpaid';
  }

  @override
  String lessonCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lessons',
      one: '1 lesson',
      zero: 'no lessons',
    );
    return '$_temp0';
  }

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get scheduleWeek => 'Week';

  @override
  String get scheduleMonth => 'Month';

  @override
  String get schedulePreviousWeek => 'Previous week';

  @override
  String get scheduleNextWeek => 'Next week';

  @override
  String get schedulePreviousMonth => 'Previous month';

  @override
  String get scheduleNextMonth => 'Next month';

  @override
  String get scheduleGoToDate => 'Go to date';

  @override
  String get scheduleNewLesson => 'Lesson';

  @override
  String get scheduleFreeWeekTitle => 'A free week';

  @override
  String get scheduleFreeWeekMessage => 'Tap + next to a day to plan a lesson.';

  @override
  String get scheduleNothingPlanned => 'Nothing planned for this day.';

  @override
  String scheduleAddLessonOn(String date) {
    return 'Add lesson on $date';
  }

  @override
  String get lessonNew => 'New lesson';

  @override
  String get lessonEdit => 'Edit lesson';

  @override
  String get lessonCreate => 'Create lesson';

  @override
  String get lessonNotFound => 'This lesson may have been deleted.';

  @override
  String get lessonCancel => 'Cancel lesson';

  @override
  String get lessonRestore => 'Restore lesson';

  @override
  String get lessonDelete => 'Delete lesson';

  @override
  String get lessonCancelConfirmTitle => 'Cancel this lesson?';

  @override
  String get lessonCancelConfirmMessage =>
      'It stays in the schedule, marked as cancelled.';

  @override
  String get lessonCancelKeep => 'Keep it';

  @override
  String get lessonDeleteConfirmTitle => 'Delete this lesson?';

  @override
  String get lessonDeleteConfirmMessage =>
      'Attendance and payment records for it are deleted too.';

  @override
  String get lessonPickSomeone => 'Pick at least one student or group';

  @override
  String get lessonSaveFailed => 'Could not save the lesson';

  @override
  String get lessonParticipants => 'Participants';

  @override
  String lessonParticipantsSummary(int present, int paid, int total) {
    return '$present/$total present · $paid/$total paid';
  }

  @override
  String get lessonAllPresent => 'All present';

  @override
  String get lessonAllPaid => 'All paid';

  @override
  String get lessonRestoreToTrack =>
      'Restore the lesson to track attendance and payments.';

  @override
  String get lessonAddParticipantsHint =>
      'Edit the lesson to add students or groups.';

  @override
  String get lessonStatusPresent => 'Present';

  @override
  String get lessonStatusPaid => 'Paid';

  @override
  String get lessonStatusHomework => 'Homework done';

  @override
  String get lessonWhoIsComing => 'Who is coming?';

  @override
  String get lessonTopic => 'Topic';

  @override
  String get lessonTopicHint => 'E.g. Present Simple';

  @override
  String get lessonSubjects => 'Students & groups';

  @override
  String get lessonDate => 'Date';

  @override
  String get lessonTime => 'Time';

  @override
  String get lessonDuration => 'Duration (minutes)';

  @override
  String get lessonDurationError => 'Enter the length in minutes';

  @override
  String get lessonHistory => 'Lesson history';

  @override
  String get recentLessons => 'Recent lessons';

  @override
  String get noLessonsYet => 'No lessons yet';

  @override
  String get studentsTitle => 'Students';

  @override
  String get studentsSearch => 'Search students';

  @override
  String get groupsSearch => 'Search groups';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get fabStudent => 'Student';

  @override
  String get fabGroup => 'Group';

  @override
  String get filterAll => 'All';

  @override
  String get noMatchesMessage => 'Try a different name or filter.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get noGroupsTitle => 'No groups yet';

  @override
  String get noGroupsMessage =>
      'Groups let you schedule several students at once.';

  @override
  String get noGroupsAction => 'Create a group';

  @override
  String get noStudentsTitle => 'No students yet';

  @override
  String get noStudentsMessage =>
      'Add the people you teach to start planning lessons.';

  @override
  String get noStudentsAction => 'Add a student';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String owesAmount(String amount) {
    return 'Owes $amount';
  }

  @override
  String get studentNew => 'New student';

  @override
  String get studentEdit => 'Edit student';

  @override
  String get studentCreate => 'Create student';

  @override
  String get studentNotFound => 'This student may have been deleted.';

  @override
  String get studentDelete => 'Delete student';

  @override
  String get studentDeleteMessage =>
      'Their lesson history and payments will be removed too.';

  @override
  String get studentSaveFailed => 'Could not save the student';

  @override
  String studentOwesFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Owes for $count lessons',
      one: 'Owes for 1 lesson',
    );
    return '$_temp0';
  }

  @override
  String paidOfTotal(int paid, int total) {
    return '$paid/$total paid';
  }

  @override
  String get studentName => 'Name';

  @override
  String get studentNameHint => 'E.g. Anna Kovalenko';

  @override
  String get studentContact => 'Contact (optional)';

  @override
  String get studentContactHint => 'Phone number or messenger handle';

  @override
  String get studentNoGroup => 'No group';

  @override
  String get rate => 'Rate';

  @override
  String get rateRequired => 'Please enter a rate';

  @override
  String get rateInvalid => 'Please enter a valid rate';

  @override
  String get ratePeriod => 'Period';

  @override
  String get ratePeriodPerLesson => 'Per lesson';

  @override
  String get ratePeriodMonthly => 'Monthly';

  @override
  String ratePerLesson(String amount) {
    return '$amount / lesson';
  }

  @override
  String ratePerMonth(String amount) {
    return '$amount / month';
  }

  @override
  String get groupNew => 'New group';

  @override
  String get groupEdit => 'Edit group';

  @override
  String get groupCreate => 'Create group';

  @override
  String get groupNotFound => 'This group may have been deleted.';

  @override
  String get groupDelete => 'Delete group';

  @override
  String get groupDeleteMessage => 'Members stay; they just leave the group.';

  @override
  String get groupSaveFailed => 'Could not save the group';

  @override
  String get groupNeedsMember => 'Add at least one member';

  @override
  String groupOwedFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Owed for $count lessons',
      one: 'Owed for 1 lesson',
    );
    return '$_temp0';
  }

  @override
  String get groupNoMembersYet => 'No members yet';

  @override
  String get groupName => 'Group name';

  @override
  String get groupNameHint => 'E.g. Saturday conversation';

  @override
  String get groupPayments => 'Group payments';

  @override
  String get paymentsAllPaidUp => 'All paid up';

  @override
  String get paymentsOwedInTotal => 'Owed in total';

  @override
  String get paymentsNoLessons => 'No lessons in this period';

  @override
  String get paymentsMarkPaid => 'Mark paid';

  @override
  String get paymentsMarkUnpaid => 'Mark unpaid';

  @override
  String get paymentsMonthlyRate => 'Monthly rate';

  @override
  String get navReports => 'Reports';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get rangeThisMonth => 'This month';

  @override
  String get rangeLastMonth => 'Last month';

  @override
  String get rangeThisYear => 'This year';

  @override
  String get rangeAllTime => 'All time';

  @override
  String get rangeCustom => 'Custom';

  @override
  String get earningsEarned => 'Earned';

  @override
  String get earningsPaid => 'Paid';

  @override
  String get earningsUnpaid => 'Unpaid';

  @override
  String earningsUnpaidAmount(String amount) {
    return '$amount unpaid';
  }

  @override
  String reportsWeekOf(String date) {
    return 'Week of $date';
  }

  @override
  String get reportsChartHint => 'Tap a bar for its totals';

  @override
  String get reportsNothingYet => 'No lessons in this period';

  @override
  String get reportsNothingYetMessage =>
      'Earnings appear here once lessons have taken place.';

  @override
  String get reportsOwedToYou => 'Owed to you';

  @override
  String get reportsByStudent => 'By student';

  @override
  String get reportsHowCounted =>
      'Counts lessons that have started and weren\'t cancelled, whether or not the student came. A monthly rate counts once for each month with lessons.';

  @override
  String unpaidLessonCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unpaid lessons',
      one: '1 unpaid lesson',
    );
    return '$_temp0';
  }

  @override
  String get navNotes => 'Notes';

  @override
  String get notesSearchHint => 'Search notes';

  @override
  String get notesFilterGeneral => 'General';

  @override
  String get notesFilterLessons => 'Lessons';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptyMessage =>
      'Lesson plans, homework checklists, ideas: keep them here.';

  @override
  String get notesNew => 'New note';

  @override
  String get notesNoneLinked => 'No notes yet';

  @override
  String get notesAdd => 'Add note';

  @override
  String get notePinned => 'Pinned';

  @override
  String get notePin => 'Pin';

  @override
  String get noteUnpin => 'Unpin';

  @override
  String get noteUntitled => 'Untitled';

  @override
  String get noteTitleHint => 'Title';

  @override
  String get noteBodyHint => 'Write something…';

  @override
  String get noteFormatHint =>
      'Start a line with - for a list or - [ ] for a checklist.';

  @override
  String get noteDelete => 'Delete note';

  @override
  String get noteDeleteTitle => 'Delete this note?';

  @override
  String get noteDeleteMessage => 'This can\'t be undone.';

  @override
  String get noteLinkStudent => 'Link to a student';

  @override
  String get noteUnlink => 'Remove link';

  @override
  String get noteSaveFailed =>
      'Couldn\'t save. Your text is still here; keep typing to try again.';

  @override
  String get noteBold => 'Bold';

  @override
  String get noteItalic => 'Italic';

  @override
  String get noteBulletList => 'List';

  @override
  String get noteChecklist => 'Checklist';

  @override
  String noteChecklistProgress(int done, int total) {
    return '$done/$total done';
  }

  @override
  String get photoAdd => 'Add photo';

  @override
  String get photoChange => 'Change photo';

  @override
  String get photoFromGallery => 'Choose from gallery';

  @override
  String get photoTake => 'Take a photo';

  @override
  String get photoRemove => 'Remove photo';

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      one: '1 student',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'Profile';

  @override
  String get settingsTeacherName => 'Your name';

  @override
  String get settingsTeacherContact => 'Your contact';

  @override
  String get settingsNotSet => 'Not set';

  @override
  String get settingsLessons => 'Lessons';

  @override
  String get settingsDefaultLength => 'Default lesson length';

  @override
  String get settingsWeekStart => 'Week starts on';

  @override
  String get settingsMonday => 'Monday';

  @override
  String get settingsSunday => 'Sunday';

  @override
  String get settingsColorLessons => 'Color lessons by';

  @override
  String get settingsColorByStatus => 'Status';

  @override
  String get settingsColorByStudent => 'Student or group';

  @override
  String get settingsRegional => 'Language & currency';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsCurrency => 'Currency';

  @override
  String get settingsCurrencyNone => 'No symbol';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExport => 'Export backup';

  @override
  String get settingsExportHint => 'Save or send a copy of all your data';

  @override
  String get settingsImport => 'Restore from backup';

  @override
  String get settingsImportHint => 'Replaces everything in the app';

  @override
  String get settingsClear => 'Clear all data';

  @override
  String get settingsClearHint => 'Students, groups, lessons and notes';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get backupShareSubject => 'Besties Notes backup';

  @override
  String get backupFailed => 'Could not create the backup';

  @override
  String get restoreConfirmTitle => 'Restore this backup?';

  @override
  String restoreConfirmMessage(String students, String lessons) {
    return 'It contains $students and $lessons. Everything currently in the app will be replaced.';
  }

  @override
  String get restoreAction => 'Restore';

  @override
  String get restoreNotABackup => 'This file isn\'t a Besties Notes backup.';

  @override
  String get restoreTooNew =>
      'This backup is from a newer version of the app. Update the app first.';

  @override
  String get restoreFailed => 'Could not restore the backup';

  @override
  String get clearConfirmTitle =>
      'Delete all students, groups, lessons and notes?';

  @override
  String get clearConfirmMessage =>
      'Settings are kept. Consider exporting a backup first.';

  @override
  String get clearSecondTitle => 'This can\'t be undone';

  @override
  String get clearSecondMessage =>
      'All lesson history and payment records will be lost.';

  @override
  String get clearAction => 'Delete everything';
}
