part of '../p_display_diary.dart';

class _MonthPickerSheet extends StatefulWidget {
  const _MonthPickerSheet({required this.initialMonth});

  final DateTime initialMonth;

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  static const int _yearWindow = 120;
  static const int _monthSpanYears = 200;

  late final int _firstYear;
  late final int _lastYear;
  late final FixedExtentScrollController _yearController;

  late final int _totalMonthItems;
  late final int _monthAnchorIndex;
  late final FixedExtentScrollController _monthController;

  late int _selectedYear;
  late int _selectedMonth;
  late int _currentMonthIndex;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialMonth;
    _selectedYear = initial.year;
    _selectedMonth = initial.month;
    _firstYear = _selectedYear - _yearWindow;
    _lastYear = _selectedYear + _yearWindow;
    _yearController = FixedExtentScrollController(
      initialItem: (_selectedYear - _firstYear).clamp(
        0,
        _lastYear - _firstYear,
      ),
    );

    _totalMonthItems = _monthSpanYears * 12;
    _monthAnchorIndex =
        (_totalMonthItems ~/ 2) - ((_totalMonthItems ~/ 2) % 12);
    _currentMonthIndex = _monthAnchorIndex + (_selectedMonth - 1);
    _monthController = FixedExtentScrollController(
      initialItem: _currentMonthIndex,
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _handleYearChanged(int index) {
    final nextYear = (_firstYear + index).clamp(_firstYear, _lastYear);
    if (nextYear == _selectedYear) return;
    setState(() => _selectedYear = nextYear);
  }

  void _handleMonthChanged(int index) {
    if (index < 0 || index >= _totalMonthItems || index == _currentMonthIndex) {
      return;
    }

    final delta = index - _currentMonthIndex;
    var totalMonths = (_selectedYear * 12) + (_selectedMonth - 1) + delta;
    var nextYear = totalMonths ~/ 12;
    var nextMonth = (totalMonths % 12) + 1;

    if (nextYear < _firstYear) {
      nextYear = _firstYear;
      nextMonth = 1;
      totalMonths = (_firstYear * 12);
      _currentMonthIndex = _monthAnchorIndex;
      _monthController.jumpToItem(_currentMonthIndex);
    } else if (nextYear > _lastYear) {
      nextYear = _lastYear;
      nextMonth = 12;
      _currentMonthIndex = _monthAnchorIndex + 11;
      _monthController.jumpToItem(_currentMonthIndex);
    } else {
      _currentMonthIndex = index;
    }

    setState(() {
      _selectedYear = nextYear;
      _selectedMonth = nextMonth;
    });
    _yearController.jumpToItem(_selectedYear - _firstYear);
  }

  void _confirmSelection() {
    Navigator.of(context).pop(DateTime(_selectedYear, _selectedMonth));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '월 선택',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    child: _WheelPanel(
                      child: ListWheelScrollView.useDelegate(
                        controller: _yearController,
                        physics: const FixedExtentScrollPhysics(),
                        itemExtent: 46,
                        diameterRatio: 1.3,
                        onSelectedItemChanged: _handleYearChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final year = _firstYear + index;
                            if (year < _firstYear || year > _lastYear) {
                              return null;
                            }
                            final isSelected = year == _selectedYear;
                            return Center(
                              child: Text(
                                '$year년',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _WheelPanel(
                      child: ListWheelScrollView.useDelegate(
                        controller: _monthController,
                        physics: const FixedExtentScrollPhysics(),
                        itemExtent: 46,
                        diameterRatio: 1.3,
                        onSelectedItemChanged: _handleMonthChanged,
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            if (index < 0 || index >= _totalMonthItems) {
                              return null;
                            }
                            final month = (index % 12) + 1;
                            final isSelected = index == _currentMonthIndex;
                            return Center(
                              child: Text(
                                '$month월',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _confirmSelection,
                child: const Text('선택'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WheelPanel extends StatelessWidget {
  const _WheelPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: colorScheme.surfaceContainerHighest,
      ),
      child: child,
    );
  }
}
