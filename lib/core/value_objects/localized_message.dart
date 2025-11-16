import 'package:diary/core/constant/country.dart';

typedef PlaceholderValues = Map<String, Object>;

/// Immutable localized message that can interpolate variables like `{max}`.
class LocalizedMessage {
  const LocalizedMessage(this._translations);

  final Map<Country, String> _translations;

  String resolve(Country country, {PlaceholderValues placeholders = const {}}) {
    if (_translations.isEmpty) return '';
    final template =
        _translations[country] ??
        _translations[Country.korea] ??
        _translations.values.first;
    if (placeholders.isEmpty) return template;

    return placeholders.entries.fold(
      template,
      (previousValue, entry) =>
          previousValue.replaceAll('{${entry.key}}', entry.value.toString()),
    );
  }
}
