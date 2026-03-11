# Besties Notes

A mobile app for teachers to manage their schedule, students, and lessons — all in one place.

---

## Features

### Schedule
- Weekly lesson calendar with prev/next navigation and a date range picker
- Lessons grouped by day, each showing time, subject, topic, and a status badge
- Tap a lesson card to expand it and see participants with their attendance, payment, and homework status — all toggleable in one tap
- Cancelled lessons appear dimmed with strikethrough text
- Create and edit lessons via a modal form

### Students & Groups
- Two-tab view: **Students** and **Groups**
- Live search and group-based filtering
- 2-column grid of cards with avatar, name, and pricing info
- Manage individual students or teaching groups (groups expand into individual participants on lessons)

### Student Details
- Full profile: avatar, contact, pricing, and notes
- Recent lessons with status badges
- Designed with upcoming **Payments** and **Roadmap** sections in mind

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State management | flutter_bloc (Cubit) |
| Database | Drift (type-safe SQLite ORM) |
| Navigation | GoRouter |
| Testing | flutter_test · bloc_test · mocktail |

### Architecture

```
lib/
├── data/
│   ├── ui_models/       # Domain models (Lesson, Student, Group, …)
│   └── db_models/       # Drift table definitions
├── providers/           # DbClient — Drift database implementation
├── repositories/        # ScheduleRepo — separates domain from data layer
├── cubits/              # LessonsCubit · StudentsAndGroupsCubit · StudentDetailsCubit
├── views/               # Screens (schedule, students, student details)
├── widgets/             # Reusable components (cards, dialogs, inputs, …)
└── common/              # Colors, extensions
```

---

## Getting Started

**Prerequisites:** Flutter SDK ≥ 3.38

```bash
flutter pub get
flutter run
```

To regenerate Drift database code after schema changes:

```bash
dart run build_runner build
```

---

## Tests

```bash
flutter test
```

The test suite covers:

- **Database** (`test/providers/`) — all `DbClient` methods against an in-memory SQLite database
- **Cubits** (`test/cubits/`) — state transitions for all three cubits via mocked `ScheduleRepo`
- **Widgets** (`test/widgets/`) — pure components and cubit-connected cards/dialogs

Tests run automatically on every pull request via GitHub Actions.
