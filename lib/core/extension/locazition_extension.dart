import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:masal/viewmodels/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  LocaleProvider get localeProvider => read<LocaleProvider>();
  AppLocalizations get localizations => AppLocalizations.of(this);
}