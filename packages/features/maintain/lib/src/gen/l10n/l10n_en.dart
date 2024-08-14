// ignore_for_file: type=lint

import 'l10n.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get maintainAppBar => 'Maintenance mode';

  @override
  String get maintainDescription => 'Maintenance in progress.\n\n\n';

  @override
  String get maintainDisableButtonTitle => 'Disable maintenance mode';
}
