import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_caly_flutter/pages/calendar/event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  List<Event> _getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // for header customize
  void _moveToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
      );
    });
  }

  void _moveToNextMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
      );
    });
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 15),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 20,),
                        // header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _monthName(_focusedDay.month),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${_focusedDay.year}',
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.chevron_left),
                                        onPressed: _moveToPreviousMonth,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.chevron_right),
                                        onPressed: _moveToNextMonth,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              TableCalendar(
                                focusedDay: _focusedDay,
                                firstDay: DateTime(_focusedDay.year, 1, 1),
                                lastDay: DateTime(_focusedDay.year, 12, 31),
                                selectedDayPredicate: (day) {
                                  return isSameDay(day, _selectedDay);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                                headerVisible: false,
                                daysOfWeekHeight: 50,
                                calendarStyle: const CalendarStyle(
                                  defaultTextStyle: TextStyle(color: primaryBlue),
                                  weekendTextStyle: TextStyle(color: primaryBlack),
                                  outsideDaysVisible: false,
                                  // 기본 날짜 스타일
                                  defaultDecoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                rowHeight: 80,
                                availableGestures: AvailableGestures.horizontalSwipe,
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    final dayEvents = _getEventsForDay(day);
                                    return _buildEvent(day, dayEvents, false, primaryTransparent);
                                  },
                                  selectedBuilder: (context, day, focusedDay) {
                                    final dayEvents = _getEventsForDay(day);
                                    return _buildEvent(day, dayEvents, true, primaryBlack);
                                  },
                                  todayBuilder: (context, day, focusedDay) {
                                    final dayEvents = _getEventsForDay(day);
                                    return _buildEvent(day, dayEvents, true, Colors.black26);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24,)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _getEventsForDay(_selectedDay!).length,
                  itemBuilder: (context, index) {
                    final event = _getEventsForDay(_selectedDay!)[index];
                    return ListTile(
                      title: BodyText(text: event.title),
                      subtitle: BodyText(text: "Until: ${event.date}", size: 12),
                    );
                  },
                )
                    : const Center(
                  child: Text("No events for this day."),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvent(DateTime day, List<Event> dayEvents, bool hasCircle, Color circleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
      child: Column(
        children: [
          hasCircle ? Container(
            alignment: Alignment.center,
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: Text(
              '${day.day}',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: Colors.white),
            ),
          ) : Text(
            '${day.day}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          hasCircle ? const SizedBox(height: 1,) : const SizedBox(height: 6,),
          if (dayEvents.isNotEmpty)
            Flexible(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                // 이벤트 칸 크기를 내용에 맞춤
                shrinkWrap: true,
                itemCount: dayEvents.length,
                itemBuilder: (context, index) {
                  final event = dayEvents[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
