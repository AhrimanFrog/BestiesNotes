import 'package:besties_notes/cubits/settings/settings_cubit.dart';
import 'package:besties_notes/data/money.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension MoneyContext on BuildContext {
  /// The currency chosen in Settings (null for none). Only call from
  /// `build`: the widget rebuilds when the setting changes.
  String? get currency => select((SettingsCubit c) => c.state.currency);

  /// [amount] in the chosen currency and the current language.
  String money(double amount) => formatMoney(amount, currency: currency);
}
