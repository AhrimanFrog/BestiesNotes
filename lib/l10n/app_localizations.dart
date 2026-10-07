import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Besties Notes'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get commonDiscard;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get commonMore;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// Confirm button of a picker, with the number of selected items.
  ///
  /// In en, this message translates to:
  /// **'Done ({count})'**
  String commonDoneCount(int count);

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get commonNoMatches;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get commonTapToSelect;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get commonPayments;

  /// No description provided for @commonBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get commonBalance;

  /// No description provided for @commonThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get commonThisMonth;

  /// No description provided for @commonNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons'**
  String get commonNoLessons;

  /// No description provided for @commonNothingOwed.
  ///
  /// In en, this message translates to:
  /// **'Nothing owed'**
  String get commonNothingOwed;

  /// No description provided for @commonMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get commonMembers;

  /// No description provided for @commonGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get commonGroup;

  /// No description provided for @commonStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get commonStudents;

  /// No description provided for @commonGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get commonGroups;

  /// Confirmation dialog title for deleting a student or group.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteNameTitle(String name);

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get navStudents;

  /// No description provided for @stateErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get stateErrorTitle;

  /// No description provided for @stateEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get stateEmptyTitle;

  /// No description provided for @stateNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get stateNotFoundTitle;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field cannot be empty'**
  String get fieldRequired;

  /// No description provided for @noStudentsAddFirst.
  ///
  /// In en, this message translates to:
  /// **'No students yet. Add some first.'**
  String get noStudentsAddFirst;

  /// No description provided for @unsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedTitle;

  /// No description provided for @unsavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Save them before leaving?'**
  String get unsavedMessage;

  /// No description provided for @unsavedSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get unsavedSave;

  /// No description provided for @unsavedKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get unsavedKeepEditing;

  /// No description provided for @lessonStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get lessonStatusScheduled;

  /// No description provided for @lessonStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get lessonStatusInProgress;

  /// No description provided for @lessonStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get lessonStatusCompleted;

  /// No description provided for @lessonStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get lessonStatusCancelled;

  /// No description provided for @lessonUpNext.
  ///
  /// In en, this message translates to:
  /// **'Up next'**
  String get lessonUpNext;

  /// No description provided for @lessonNoOneAssigned.
  ///
  /// In en, this message translates to:
  /// **'No one assigned'**
  String get lessonNoOneAssigned;

  /// Who a lesson is for: the first student or group, then how many more.
  ///
  /// In en, this message translates to:
  /// **'{name} +{count}'**
  String lessonAudienceMore(String name, int count);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// No description provided for @lessonPresentCount.
  ///
  /// In en, this message translates to:
  /// **'{present}/{total} present'**
  String lessonPresentCount(int present, int total);

  /// Badge: how many participants of a lesson haven't paid.
  ///
  /// In en, this message translates to:
  /// **'{count} unpaid'**
  String lessonUnpaidCount(int count);

  /// No description provided for @lessonCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{no lessons} =1{1 lesson} other{{count} lessons}}'**
  String lessonCount(int count);

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get scheduleWeek;

  /// No description provided for @scheduleMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get scheduleMonth;

  /// No description provided for @schedulePreviousWeek.
  ///
  /// In en, this message translates to:
  /// **'Previous week'**
  String get schedulePreviousWeek;

  /// No description provided for @scheduleNextWeek.
  ///
  /// In en, this message translates to:
  /// **'Next week'**
  String get scheduleNextWeek;

  /// No description provided for @schedulePreviousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get schedulePreviousMonth;

  /// No description provided for @scheduleNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get scheduleNextMonth;

  /// No description provided for @scheduleGoToDate.
  ///
  /// In en, this message translates to:
  /// **'Go to date'**
  String get scheduleGoToDate;

  /// Label of the schedule's floating "+ Lesson" button.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get scheduleNewLesson;

  /// No description provided for @scheduleFreeWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'A free week'**
  String get scheduleFreeWeekTitle;

  /// No description provided for @scheduleFreeWeekMessage.
  ///
  /// In en, this message translates to:
  /// **'Tap + next to a day to plan a lesson.'**
  String get scheduleFreeWeekMessage;

  /// No description provided for @scheduleNothingPlanned.
  ///
  /// In en, this message translates to:
  /// **'Nothing planned for this day.'**
  String get scheduleNothingPlanned;

  /// No description provided for @scheduleAddLessonOn.
  ///
  /// In en, this message translates to:
  /// **'Add lesson on {date}'**
  String scheduleAddLessonOn(String date);

  /// No description provided for @lessonNew.
  ///
  /// In en, this message translates to:
  /// **'New lesson'**
  String get lessonNew;

  /// No description provided for @lessonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit lesson'**
  String get lessonEdit;

  /// No description provided for @lessonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create lesson'**
  String get lessonCreate;

  /// No description provided for @lessonNotFound.
  ///
  /// In en, this message translates to:
  /// **'This lesson may have been deleted.'**
  String get lessonNotFound;

  /// No description provided for @lessonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel lesson'**
  String get lessonCancel;

  /// No description provided for @lessonRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore lesson'**
  String get lessonRestore;

  /// No description provided for @lessonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete lesson'**
  String get lessonDelete;

  /// No description provided for @lessonCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this lesson?'**
  String get lessonCancelConfirmTitle;

  /// No description provided for @lessonCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'It stays in the schedule, marked as cancelled.'**
  String get lessonCancelConfirmMessage;

  /// No description provided for @lessonCancelKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get lessonCancelKeep;

  /// No description provided for @lessonDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this lesson?'**
  String get lessonDeleteConfirmTitle;

  /// No description provided for @lessonDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Attendance and payment records for it are deleted too.'**
  String get lessonDeleteConfirmMessage;

  /// No description provided for @lessonPickSomeone.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one student or group'**
  String get lessonPickSomeone;

  /// No description provided for @lessonSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the lesson'**
  String get lessonSaveFailed;

  /// No description provided for @lessonParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get lessonParticipants;

  /// No description provided for @lessonParticipantsSummary.
  ///
  /// In en, this message translates to:
  /// **'{present}/{total} present · {paid}/{total} paid'**
  String lessonParticipantsSummary(int present, int paid, int total);

  /// No description provided for @lessonAllPresent.
  ///
  /// In en, this message translates to:
  /// **'All present'**
  String get lessonAllPresent;

  /// No description provided for @lessonAllPaid.
  ///
  /// In en, this message translates to:
  /// **'All paid'**
  String get lessonAllPaid;

  /// No description provided for @lessonRestoreToTrack.
  ///
  /// In en, this message translates to:
  /// **'Restore the lesson to track attendance and payments.'**
  String get lessonRestoreToTrack;

  /// No description provided for @lessonAddParticipantsHint.
  ///
  /// In en, this message translates to:
  /// **'Edit the lesson to add students or groups.'**
  String get lessonAddParticipantsHint;

  /// No description provided for @lessonStatusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get lessonStatusPresent;

  /// No description provided for @lessonStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get lessonStatusPaid;

  /// No description provided for @lessonStatusHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework done'**
  String get lessonStatusHomework;

  /// No description provided for @lessonWhoIsComing.
  ///
  /// In en, this message translates to:
  /// **'Who is coming?'**
  String get lessonWhoIsComing;

  /// No description provided for @lessonTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get lessonTopic;

  /// No description provided for @lessonTopicHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Present Simple'**
  String get lessonTopicHint;

  /// No description provided for @lessonSubjects.
  ///
  /// In en, this message translates to:
  /// **'Students & groups'**
  String get lessonSubjects;

  /// No description provided for @lessonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get lessonDate;

  /// No description provided for @lessonTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get lessonTime;

  /// No description provided for @lessonDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get lessonDuration;

  /// No description provided for @lessonDurationError.
  ///
  /// In en, this message translates to:
  /// **'Enter the length in minutes'**
  String get lessonDurationError;

  /// No description provided for @lessonHistory.
  ///
  /// In en, this message translates to:
  /// **'Lesson history'**
  String get lessonHistory;

  /// No description provided for @recentLessons.
  ///
  /// In en, this message translates to:
  /// **'Recent lessons'**
  String get recentLessons;

  /// No description provided for @noLessonsYet.
  ///
  /// In en, this message translates to:
  /// **'No lessons yet'**
  String get noLessonsYet;

  /// No description provided for @studentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsTitle;

  /// No description provided for @studentsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search students'**
  String get studentsSearch;

  /// No description provided for @groupsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search groups'**
  String get groupsSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @fabStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get fabStudent;

  /// No description provided for @fabGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get fabGroup;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @noMatchesMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or filter.'**
  String get noMatchesMessage;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @noGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get noGroupsTitle;

  /// No description provided for @noGroupsMessage.
  ///
  /// In en, this message translates to:
  /// **'Groups let you schedule several students at once.'**
  String get noGroupsMessage;

  /// No description provided for @noGroupsAction.
  ///
  /// In en, this message translates to:
  /// **'Create a group'**
  String get noGroupsAction;

  /// No description provided for @noStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No students yet'**
  String get noStudentsTitle;

  /// No description provided for @noStudentsMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the people you teach to start planning lessons.'**
  String get noStudentsMessage;

  /// No description provided for @noStudentsAction.
  ///
  /// In en, this message translates to:
  /// **'Add a student'**
  String get noStudentsAction;

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// Badge on a student card. amount is already formatted.
  ///
  /// In en, this message translates to:
  /// **'Owes {amount}'**
  String owesAmount(String amount);

  /// No description provided for @studentNew.
  ///
  /// In en, this message translates to:
  /// **'New student'**
  String get studentNew;

  /// No description provided for @studentEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit student'**
  String get studentEdit;

  /// No description provided for @studentCreate.
  ///
  /// In en, this message translates to:
  /// **'Create student'**
  String get studentCreate;

  /// No description provided for @studentNotFound.
  ///
  /// In en, this message translates to:
  /// **'This student may have been deleted.'**
  String get studentNotFound;

  /// No description provided for @studentDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete student'**
  String get studentDelete;

  /// No description provided for @studentDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Their lesson history and payments will be removed too.'**
  String get studentDeleteMessage;

  /// No description provided for @studentSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the student'**
  String get studentSaveFailed;

  /// No description provided for @studentOwesFor.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Owes for 1 lesson} other{Owes for {count} lessons}}'**
  String studentOwesFor(int count);

  /// No description provided for @paidOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{paid}/{total} paid'**
  String paidOfTotal(int paid, int total);

  /// No description provided for @studentName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get studentName;

  /// No description provided for @studentNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Anna Kovalenko'**
  String get studentNameHint;

  /// No description provided for @studentContact.
  ///
  /// In en, this message translates to:
  /// **'Contact (optional)'**
  String get studentContact;

  /// No description provided for @studentContactHint.
  ///
  /// In en, this message translates to:
  /// **'Phone number or messenger handle'**
  String get studentContactHint;

  /// No description provided for @studentNoGroup.
  ///
  /// In en, this message translates to:
  /// **'No group'**
  String get studentNoGroup;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @rateRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a rate'**
  String get rateRequired;

  /// No description provided for @rateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid rate'**
  String get rateInvalid;

  /// No description provided for @ratePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get ratePeriod;

  /// No description provided for @ratePeriodPerLesson.
  ///
  /// In en, this message translates to:
  /// **'Per lesson'**
  String get ratePeriodPerLesson;

  /// No description provided for @ratePeriodMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get ratePeriodMonthly;

  /// No description provided for @ratePerLesson.
  ///
  /// In en, this message translates to:
  /// **'{amount} / lesson'**
  String ratePerLesson(String amount);

  /// No description provided for @ratePerMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} / month'**
  String ratePerMonth(String amount);

  /// No description provided for @groupNew.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get groupNew;

  /// No description provided for @groupEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get groupEdit;

  /// No description provided for @groupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get groupCreate;

  /// No description provided for @groupNotFound.
  ///
  /// In en, this message translates to:
  /// **'This group may have been deleted.'**
  String get groupNotFound;

  /// No description provided for @groupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get groupDelete;

  /// No description provided for @groupDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Members stay; they just leave the group.'**
  String get groupDeleteMessage;

  /// No description provided for @groupSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the group'**
  String get groupSaveFailed;

  /// No description provided for @groupNeedsMember.
  ///
  /// In en, this message translates to:
  /// **'Add at least one member'**
  String get groupNeedsMember;

  /// No description provided for @groupOwedFor.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Owed for 1 lesson} other{Owed for {count} lessons}}'**
  String groupOwedFor(int count);

  /// No description provided for @groupNoMembersYet.
  ///
  /// In en, this message translates to:
  /// **'No members yet'**
  String get groupNoMembersYet;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Saturday conversation'**
  String get groupNameHint;

  /// No description provided for @groupPayments.
  ///
  /// In en, this message translates to:
  /// **'Group payments'**
  String get groupPayments;

  /// No description provided for @paymentsAllPaidUp.
  ///
  /// In en, this message translates to:
  /// **'All paid up'**
  String get paymentsAllPaidUp;

  /// No description provided for @paymentsOwedInTotal.
  ///
  /// In en, this message translates to:
  /// **'Owed in total'**
  String get paymentsOwedInTotal;

  /// No description provided for @paymentsNoLessons.
  ///
  /// In en, this message translates to:
  /// **'No lessons in this period'**
  String get paymentsNoLessons;

  /// No description provided for @paymentsMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark paid'**
  String get paymentsMarkPaid;

  /// No description provided for @paymentsMarkUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Mark unpaid'**
  String get paymentsMarkUnpaid;

  /// No description provided for @paymentsMonthlyRate.
  ///
  /// In en, this message translates to:
  /// **'Monthly rate'**
  String get paymentsMonthlyRate;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @rangeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get rangeThisMonth;

  /// No description provided for @rangeLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get rangeLastMonth;

  /// No description provided for @rangeThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get rangeThisYear;

  /// No description provided for @rangeAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get rangeAllTime;

  /// No description provided for @rangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get rangeCustom;

  /// No description provided for @earningsEarned.
  ///
  /// In en, this message translates to:
  /// **'Earned'**
  String get earningsEarned;

  /// No description provided for @earningsPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get earningsPaid;

  /// No description provided for @earningsUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get earningsUnpaid;

  /// No description provided for @earningsUnpaidAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} unpaid'**
  String earningsUnpaidAmount(String amount);

  /// No description provided for @reportsWeekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String reportsWeekOf(String date);

  /// No description provided for @reportsChartHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a bar for its totals'**
  String get reportsChartHint;

  /// No description provided for @reportsNothingYet.
  ///
  /// In en, this message translates to:
  /// **'No lessons in this period'**
  String get reportsNothingYet;

  /// No description provided for @reportsNothingYetMessage.
  ///
  /// In en, this message translates to:
  /// **'Earnings appear here once lessons have taken place.'**
  String get reportsNothingYetMessage;

  /// No description provided for @reportsOwedToYou.
  ///
  /// In en, this message translates to:
  /// **'Owed to you'**
  String get reportsOwedToYou;

  /// No description provided for @reportsByStudent.
  ///
  /// In en, this message translates to:
  /// **'By student'**
  String get reportsByStudent;

  /// No description provided for @reportsHowCounted.
  ///
  /// In en, this message translates to:
  /// **'Counts lessons that have started and weren\'t cancelled, whether or not the student came. A monthly rate counts once for each month with lessons.'**
  String get reportsHowCounted;

  /// No description provided for @unpaidLessonCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 unpaid lesson} other{{count} unpaid lessons}}'**
  String unpaidLessonCount(int count);

  /// No description provided for @reminderLessonSoon.
  ///
  /// In en, this message translates to:
  /// **'{topic} in {minutes} min'**
  String reminderLessonSoon(String topic, int minutes);

  /// No description provided for @reminderLessonTomorrow.
  ///
  /// In en, this message translates to:
  /// **'{topic} tomorrow'**
  String reminderLessonTomorrow(String topic);

  /// No description provided for @reminderDebtTitle.
  ///
  /// In en, this message translates to:
  /// **'{amount} unpaid'**
  String reminderDebtTitle(String amount);

  /// No description provided for @reminderBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 student has no lessons next week} other{{count} students have no lessons next week}}'**
  String reminderBookingTitle(int count);

  /// No description provided for @reminderNamesAndMore.
  ///
  /// In en, this message translates to:
  /// **'{names} and {count} more'**
  String reminderNamesAndMore(String names, int count);

  /// No description provided for @reminderChannelLessons.
  ///
  /// In en, this message translates to:
  /// **'Lesson reminders'**
  String get reminderChannelLessons;

  /// No description provided for @reminderChannelSummaries.
  ///
  /// In en, this message translates to:
  /// **'Weekly summaries'**
  String get reminderChannelSummaries;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsLessonReminder.
  ///
  /// In en, this message translates to:
  /// **'Lesson reminders'**
  String get settingsLessonReminder;

  /// No description provided for @settingsReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsReminderOff;

  /// No description provided for @settingsReminderMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String settingsReminderMinutes(int minutes);

  /// No description provided for @settingsReminderDay.
  ///
  /// In en, this message translates to:
  /// **'A day before'**
  String get settingsReminderDay;

  /// No description provided for @settingsDebtDigest.
  ///
  /// In en, this message translates to:
  /// **'Weekly unpaid summary'**
  String get settingsDebtDigest;

  /// No description provided for @settingsDebtDigestHint.
  ///
  /// In en, this message translates to:
  /// **'When the week starts: who still owes you'**
  String get settingsDebtDigestHint;

  /// No description provided for @settingsBookingReminder.
  ///
  /// In en, this message translates to:
  /// **'Students without lessons'**
  String get settingsBookingReminder;

  /// No description provided for @settingsBookingReminderHint.
  ///
  /// In en, this message translates to:
  /// **'The evening before a week: regular students with nothing booked'**
  String get settingsBookingReminderHint;

  /// No description provided for @settingsNotificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for this app'**
  String get settingsNotificationsBlocked;

  /// No description provided for @settingsNotificationsAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get settingsNotificationsAllow;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navNotes;

  /// No description provided for @notesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes'**
  String get notesSearchHint;

  /// No description provided for @notesFilterGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get notesFilterGeneral;

  /// No description provided for @notesFilterLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get notesFilterLessons;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Lesson plans, homework checklists, ideas: keep them here.'**
  String get notesEmptyMessage;

  /// No description provided for @notesNew.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesNew;

  /// No description provided for @notesNoneLinked.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesNoneLinked;

  /// No description provided for @notesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get notesAdd;

  /// No description provided for @notePinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get notePinned;

  /// No description provided for @notePin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get notePin;

  /// No description provided for @noteUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get noteUnpin;

  /// No description provided for @noteUntitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get noteUntitled;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get noteTitleHint;

  /// No description provided for @noteBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Write something…'**
  String get noteBodyHint;

  /// No description provided for @noteFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Start a line with - for a list or - [ ] for a checklist.'**
  String get noteFormatHint;

  /// No description provided for @noteDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get noteDelete;

  /// No description provided for @noteDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get noteDeleteTitle;

  /// No description provided for @noteDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get noteDeleteMessage;

  /// No description provided for @noteLinkStudent.
  ///
  /// In en, this message translates to:
  /// **'Link to a student'**
  String get noteLinkStudent;

  /// No description provided for @noteUnlink.
  ///
  /// In en, this message translates to:
  /// **'Remove link'**
  String get noteUnlink;

  /// No description provided for @noteSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Your text is still here; keep typing to try again.'**
  String get noteSaveFailed;

  /// No description provided for @noteBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get noteBold;

  /// No description provided for @noteItalic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get noteItalic;

  /// No description provided for @noteBulletList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get noteBulletList;

  /// No description provided for @noteChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get noteChecklist;

  /// No description provided for @noteChecklistProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} done'**
  String noteChecklistProgress(int done, int total);

  /// No description provided for @photoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get photoAdd;

  /// No description provided for @photoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get photoChange;

  /// No description provided for @photoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoFromGallery;

  /// No description provided for @photoTake.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoTake;

  /// No description provided for @photoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get photoRemove;

  /// No description provided for @studentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 student} other{{count} students}}'**
  String studentCount(int count);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfile;

  /// No description provided for @settingsTeacherName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsTeacherName;

  /// No description provided for @settingsTeacherContact.
  ///
  /// In en, this message translates to:
  /// **'Your contact'**
  String get settingsTeacherContact;

  /// No description provided for @settingsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsNotSet;

  /// No description provided for @settingsLessons.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get settingsLessons;

  /// No description provided for @settingsDefaultLength.
  ///
  /// In en, this message translates to:
  /// **'Default lesson length'**
  String get settingsDefaultLength;

  /// No description provided for @settingsWeekStart.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get settingsWeekStart;

  /// No description provided for @settingsMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get settingsMonday;

  /// No description provided for @settingsSunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get settingsSunday;

  /// No description provided for @settingsColorLessons.
  ///
  /// In en, this message translates to:
  /// **'Color lessons by'**
  String get settingsColorLessons;

  /// No description provided for @settingsColorByStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get settingsColorByStatus;

  /// No description provided for @settingsColorByStudent.
  ///
  /// In en, this message translates to:
  /// **'Student or group'**
  String get settingsColorByStudent;

  /// No description provided for @settingsRegional.
  ///
  /// In en, this message translates to:
  /// **'Language & currency'**
  String get settingsRegional;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrency;

  /// No description provided for @settingsCurrencyNone.
  ///
  /// In en, this message translates to:
  /// **'No symbol'**
  String get settingsCurrencyNone;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExport;

  /// No description provided for @settingsExportHint.
  ///
  /// In en, this message translates to:
  /// **'Save or send a copy of all your data'**
  String get settingsExportHint;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get settingsImport;

  /// No description provided for @settingsImportHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything in the app'**
  String get settingsImportHint;

  /// No description provided for @settingsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClear;

  /// No description provided for @settingsClearHint.
  ///
  /// In en, this message translates to:
  /// **'Students, groups, lessons and notes'**
  String get settingsClearHint;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @backupShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Besties Notes backup'**
  String get backupShareSubject;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the backup'**
  String get backupFailed;

  /// No description provided for @restoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get restoreConfirmTitle;

  /// students and lessons are already-pluralized counts (studentCount, lessonCount).
  ///
  /// In en, this message translates to:
  /// **'It contains {students} and {lessons}. Everything currently in the app will be replaced.'**
  String restoreConfirmMessage(String students, String lessons);

  /// No description provided for @restoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreAction;

  /// No description provided for @restoreNotABackup.
  ///
  /// In en, this message translates to:
  /// **'This file isn\'t a Besties Notes backup.'**
  String get restoreNotABackup;

  /// No description provided for @restoreTooNew.
  ///
  /// In en, this message translates to:
  /// **'This backup is from a newer version of the app. Update the app first.'**
  String get restoreTooNew;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore the backup'**
  String get restoreFailed;

  /// No description provided for @clearConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all students, groups, lessons and notes?'**
  String get clearConfirmTitle;

  /// No description provided for @clearConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Settings are kept. Consider exporting a backup first.'**
  String get clearConfirmMessage;

  /// No description provided for @clearSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone'**
  String get clearSecondTitle;

  /// No description provided for @clearSecondMessage.
  ///
  /// In en, this message translates to:
  /// **'All lesson history and payment records will be lost.'**
  String get clearSecondMessage;

  /// No description provided for @clearAction.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get clearAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
