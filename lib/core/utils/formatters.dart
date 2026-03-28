import 'package:intl/intl.dart';

class Formatters {
  static final _money = NumberFormat.currency(symbol: 'ETB ', decimalDigits: 2);
  static final _usd = NumberFormat.currency(symbol: 'USD ', decimalDigits: 2);
  static final _date = DateFormat('MMM d, yyyy • HH:mm');

  // Demo conversion rate used for quick wallet reference in UI.
  static const double etbPerUsd = 56.0;

  static String money(num amount) => _money.format(amount);
  static String moneyUsd(num etbAmount) => _usd.format((etbAmount / etbPerUsd));
  static String dateTime(DateTime dt) => _date.format(dt.toLocal());
}

