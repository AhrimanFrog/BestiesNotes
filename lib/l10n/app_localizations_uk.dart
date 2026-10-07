// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Besties Notes';

  @override
  String get commonCancel => 'Скасувати';

  @override
  String get commonDelete => 'Видалити';

  @override
  String get commonSave => 'Зберегти';

  @override
  String get commonDiscard => 'Скинути';

  @override
  String get commonEdit => 'Редагувати';

  @override
  String get commonClose => 'Закрити';

  @override
  String get commonMore => 'Більше';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonDone => 'Готово';

  @override
  String commonDoneCount(int count) {
    return 'Готово ($count)';
  }

  @override
  String get commonSearch => 'Пошук';

  @override
  String get commonTryAgain => 'Спробувати знову';

  @override
  String get commonNoMatches => 'Нічого не знайдено';

  @override
  String get commonToday => 'Сьогодні';

  @override
  String get commonNotes => 'Нотатки';

  @override
  String get commonNotesOptional => 'Нотатки (необов’язково)';

  @override
  String get commonTapToSelect => 'Натисніть, щоб вибрати';

  @override
  String get commonSeeAll => 'Усі';

  @override
  String get commonPayments => 'Оплати';

  @override
  String get commonBalance => 'Баланс';

  @override
  String get commonThisMonth => 'Цього місяця';

  @override
  String get commonNoLessons => 'Немає уроків';

  @override
  String get commonNothingOwed => 'Боргів немає';

  @override
  String get commonMembers => 'Учасники';

  @override
  String get commonGroup => 'Група';

  @override
  String get commonStudents => 'Учні';

  @override
  String get commonGroups => 'Групи';

  @override
  String deleteNameTitle(String name) {
    return 'Видалити $name?';
  }

  @override
  String get navSchedule => 'Розклад';

  @override
  String get navStudents => 'Учні';

  @override
  String get stateErrorTitle => 'Щось пішло не так';

  @override
  String get stateEmptyTitle => 'Тут поки порожньо';

  @override
  String get stateNotFoundTitle => 'Не знайдено';

  @override
  String get fieldRequired => 'Поле не може бути порожнім';

  @override
  String get noStudentsAddFirst => 'Учнів поки немає. Спершу додайте їх.';

  @override
  String get unsavedTitle => 'Незбережені зміни';

  @override
  String get unsavedMessage => 'Зберегти їх перед виходом?';

  @override
  String get unsavedSave => 'Зберегти зміни';

  @override
  String get unsavedKeepEditing => 'Продовжити редагування';

  @override
  String get lessonStatusScheduled => 'Заплановано';

  @override
  String get lessonStatusInProgress => 'Триває';

  @override
  String get lessonStatusCompleted => 'Завершено';

  @override
  String get lessonStatusCancelled => 'Скасовано';

  @override
  String get lessonUpNext => 'Далі';

  @override
  String get lessonNoOneAssigned => 'Нікого не призначено';

  @override
  String lessonAudienceMore(String name, int count) {
    return '$name +$count';
  }

  @override
  String durationMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String lessonPresentCount(int present, int total) {
    return 'Присутні: $present/$total';
  }

  @override
  String lessonUnpaidCount(int count) {
    return 'Не оплатили: $count';
  }

  @override
  String lessonCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count уроку',
      many: '$count уроків',
      few: '$count уроки',
      one: '$count урок',
      zero: 'немає уроків',
    );
    return '$_temp0';
  }

  @override
  String get scheduleTitle => 'Розклад';

  @override
  String get scheduleWeek => 'Тиждень';

  @override
  String get scheduleMonth => 'Місяць';

  @override
  String get schedulePreviousWeek => 'Попередній тиждень';

  @override
  String get scheduleNextWeek => 'Наступний тиждень';

  @override
  String get schedulePreviousMonth => 'Попередній місяць';

  @override
  String get scheduleNextMonth => 'Наступний місяць';

  @override
  String get scheduleGoToDate => 'Перейти до дати';

  @override
  String get scheduleNewLesson => 'Урок';

  @override
  String get scheduleFreeWeekTitle => 'Вільний тиждень';

  @override
  String get scheduleFreeWeekMessage =>
      'Натисніть + біля дня, щоб запланувати урок.';

  @override
  String get scheduleNothingPlanned => 'На цей день нічого не заплановано.';

  @override
  String scheduleAddLessonOn(String date) {
    return 'Додати урок на $date';
  }

  @override
  String get lessonNew => 'Новий урок';

  @override
  String get lessonEdit => 'Редагування уроку';

  @override
  String get lessonCreate => 'Створити урок';

  @override
  String get lessonNotFound => 'Можливо, цей урок видалено.';

  @override
  String get lessonCancel => 'Скасувати урок';

  @override
  String get lessonRestore => 'Відновити урок';

  @override
  String get lessonDelete => 'Видалити урок';

  @override
  String get lessonCancelConfirmTitle => 'Скасувати цей урок?';

  @override
  String get lessonCancelConfirmMessage =>
      'Він залишиться в розкладі з позначкою «скасовано».';

  @override
  String get lessonCancelKeep => 'Залишити';

  @override
  String get lessonDeleteConfirmTitle => 'Видалити цей урок?';

  @override
  String get lessonDeleteConfirmMessage =>
      'Записи про відвідування й оплату теж буде видалено.';

  @override
  String get lessonPickSomeone => 'Виберіть хоча б одного учня або групу';

  @override
  String get lessonSaveFailed => 'Не вдалося зберегти урок';

  @override
  String get lessonParticipants => 'Учасники';

  @override
  String lessonParticipantsSummary(int present, int paid, int total) {
    return 'Присутні: $present/$total · Оплатили: $paid/$total';
  }

  @override
  String get lessonAllPresent => 'Усі присутні';

  @override
  String get lessonAllPaid => 'Усі оплатили';

  @override
  String get lessonRestoreToTrack =>
      'Відновіть урок, щоб відмічати відвідування й оплату.';

  @override
  String get lessonAddParticipantsHint =>
      'Відредагуйте урок, щоб додати учнів або групи.';

  @override
  String get lessonNoNotes => 'Нотаток поки немає.';

  @override
  String get lessonStatusPresent => 'Присутній';

  @override
  String get lessonStatusPaid => 'Оплачено';

  @override
  String get lessonStatusHomework => 'Домашнє завдання виконано';

  @override
  String get lessonWhoIsComing => 'Хто прийде?';

  @override
  String get lessonTopic => 'Тема';

  @override
  String get lessonTopicHint => 'Напр. Present Simple';

  @override
  String get lessonSubjects => 'Учні та групи';

  @override
  String get lessonDate => 'Дата';

  @override
  String get lessonTime => 'Час';

  @override
  String get lessonDuration => 'Тривалість (хвилини)';

  @override
  String get lessonDurationError => 'Вкажіть тривалість у хвилинах';

  @override
  String get lessonHistory => 'Історія уроків';

  @override
  String get recentLessons => 'Останні уроки';

  @override
  String get noLessonsYet => 'Уроків поки немає';

  @override
  String get studentsTitle => 'Учні';

  @override
  String get studentsSearch => 'Пошук учнів';

  @override
  String get groupsSearch => 'Пошук груп';

  @override
  String get clearSearch => 'Очистити пошук';

  @override
  String get fabStudent => 'Учень';

  @override
  String get fabGroup => 'Група';

  @override
  String get filterAll => 'Усі';

  @override
  String get noMatchesMessage => 'Спробуйте інше ім’я або фільтр.';

  @override
  String get clearFilters => 'Скинути фільтри';

  @override
  String get noGroupsTitle => 'Груп поки немає';

  @override
  String get noGroupsMessage =>
      'Групи дозволяють планувати урок одразу для кількох учнів.';

  @override
  String get noGroupsAction => 'Створити групу';

  @override
  String get noStudentsTitle => 'Учнів поки немає';

  @override
  String get noStudentsMessage =>
      'Додайте тих, кого навчаєте, щоб планувати уроки.';

  @override
  String get noStudentsAction => 'Додати учня';

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасника',
      many: '$count учасників',
      few: '$count учасники',
      one: '$count учасник',
    );
    return '$_temp0';
  }

  @override
  String owesAmount(String amount) {
    return 'Борг $amount';
  }

  @override
  String get studentNew => 'Новий учень';

  @override
  String get studentEdit => 'Редагування учня';

  @override
  String get studentCreate => 'Додати учня';

  @override
  String get studentNotFound => 'Можливо, цього учня видалено.';

  @override
  String get studentDelete => 'Видалити учня';

  @override
  String get studentDeleteMessage =>
      'Історію уроків і оплат теж буде видалено.';

  @override
  String get studentSaveFailed => 'Не вдалося зберегти учня';

  @override
  String studentOwesFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Борг за $count уроку',
      many: 'Борг за $count уроків',
      few: 'Борг за $count уроки',
      one: 'Борг за $count урок',
    );
    return '$_temp0';
  }

  @override
  String paidOfTotal(int paid, int total) {
    return 'Оплачено $paid/$total';
  }

  @override
  String get studentName => 'Ім’я';

  @override
  String get studentNameHint => 'Напр. Анна Коваленко';

  @override
  String get studentContact => 'Контакт (необов’язково)';

  @override
  String get studentContactHint => 'Номер телефону або нік у месенджері';

  @override
  String get studentNoGroup => 'Без групи';

  @override
  String get rate => 'Ставка';

  @override
  String get rateRequired => 'Вкажіть ставку';

  @override
  String get rateInvalid => 'Вкажіть коректну ставку';

  @override
  String get ratePeriod => 'Період';

  @override
  String get ratePeriodPerLesson => 'За урок';

  @override
  String get ratePeriodMonthly => 'Щомісяця';

  @override
  String ratePerLesson(String amount) {
    return '$amount / урок';
  }

  @override
  String ratePerMonth(String amount) {
    return '$amount / міс.';
  }

  @override
  String get groupNew => 'Нова група';

  @override
  String get groupEdit => 'Редагувати групу';

  @override
  String get groupCreate => 'Створити групу';

  @override
  String get groupNotFound => 'Можливо, цю групу видалено.';

  @override
  String get groupDelete => 'Видалити групу';

  @override
  String get groupDeleteMessage =>
      'Учасники залишаться, просто вийдуть із групи.';

  @override
  String get groupSaveFailed => 'Не вдалося зберегти групу';

  @override
  String get groupNeedsMember => 'Додайте хоча б одного учасника';

  @override
  String groupOwedFor(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Борг за $count уроку',
      many: 'Борг за $count уроків',
      few: 'Борг за $count уроки',
      one: 'Борг за $count урок',
    );
    return '$_temp0';
  }

  @override
  String get groupNoMembersYet => 'Учасників поки немає';

  @override
  String get groupName => 'Назва групи';

  @override
  String get groupNameHint => 'Напр. Суботня розмовна';

  @override
  String get groupPayments => 'Оплати групи';

  @override
  String get paymentsUnpaidLessons => 'Неоплачені уроки';

  @override
  String get paymentsAmountOwed => 'Сума боргу';

  @override
  String get paymentsAllPaidUp => 'Усе оплачено';

  @override
  String get photoAdd => 'Додати фото';

  @override
  String get photoChange => 'Змінити фото';

  @override
  String get photoFromGallery => 'Вибрати з галереї';

  @override
  String get photoTake => 'Зробити фото';

  @override
  String get photoRemove => 'Видалити фото';

  @override
  String studentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учня',
      many: '$count учнів',
      few: '$count учні',
      one: '$count учень',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsProfile => 'Профіль';

  @override
  String get settingsTeacherName => 'Ваше ім’я';

  @override
  String get settingsTeacherContact => 'Ваш контакт';

  @override
  String get settingsNotSet => 'Не вказано';

  @override
  String get settingsLessons => 'Уроки';

  @override
  String get settingsDefaultLength => 'Тривалість уроку за замовчуванням';

  @override
  String get settingsWeekStart => 'Початок тижня';

  @override
  String get settingsMonday => 'Понеділок';

  @override
  String get settingsSunday => 'Неділя';

  @override
  String get settingsColorLessons => 'Колір уроків';

  @override
  String get settingsColorByStatus => 'За статусом';

  @override
  String get settingsColorByStudent => 'За учнем чи групою';

  @override
  String get settingsRegional => 'Мова й валюта';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsLanguageSystem => 'Як у системі';

  @override
  String get settingsCurrency => 'Валюта';

  @override
  String get settingsCurrencyNone => 'Без символу';

  @override
  String get settingsData => 'Дані';

  @override
  String get settingsExport => 'Експортувати резервну копію';

  @override
  String get settingsExportHint => 'Збережіть або надішліть копію всіх даних';

  @override
  String get settingsImport => 'Відновити з резервної копії';

  @override
  String get settingsImportHint => 'Замінює всі дані в застосунку';

  @override
  String get settingsClear => 'Видалити всі дані';

  @override
  String get settingsClearHint => 'Учні, групи й уроки';

  @override
  String get settingsAbout => 'Про застосунок';

  @override
  String get settingsLicenses => 'Ліцензії';

  @override
  String settingsVersion(String version) {
    return 'Версія $version';
  }

  @override
  String get backupShareSubject => 'Резервна копія Besties Notes';

  @override
  String get backupFailed => 'Не вдалося створити резервну копію';

  @override
  String get restoreConfirmTitle => 'Відновити цю копію?';

  @override
  String restoreConfirmMessage(String students, String lessons) {
    return 'У ній $students і $lessons. Усі поточні дані в застосунку буде замінено.';
  }

  @override
  String get restoreAction => 'Відновити';

  @override
  String get restoreNotABackup =>
      'Цей файл не є резервною копією Besties Notes.';

  @override
  String get restoreTooNew =>
      'Цю копію створено новішою версією застосунку. Спершу оновіть застосунок.';

  @override
  String get restoreFailed => 'Не вдалося відновити копію';

  @override
  String get clearConfirmTitle => 'Видалити всіх учнів, групи й уроки?';

  @override
  String get clearConfirmMessage =>
      'Налаштування залишаться. Можливо, спершу варто експортувати копію.';

  @override
  String get clearSecondTitle => 'Цю дію не можна скасувати';

  @override
  String get clearSecondMessage => 'Уся історія уроків і оплат буде втрачена.';

  @override
  String get clearAction => 'Видалити все';
}
