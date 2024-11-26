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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        // header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
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
                          daysOfWeekHeight: 30,
                          calendarStyle: const CalendarStyle(
                            defaultTextStyle: TextStyle(color: primaryBlue),
                            weekendTextStyle: TextStyle(color: primaryBlack),
                            outsideDaysVisible: false,
                            // 기본 날짜 스타일
                            defaultDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                          availableGestures: AvailableGestures.horizontalSwipe,
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              final eventCount = _getEventsForDay(day).length;
                  
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BodyText(
                                        text: '${day.day}',
                                        color: primaryBlue,
                                        weight: isSameDay(day, _selectedDay)
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                  if (eventCount > 0)
                                    Positioned(
                                      bottom: -5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$eventCount',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                            selectedBuilder: (context, day, focusedDay) {
                              final eventCount = _getEventsForDay(day).length;
                  
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    child: BodyText(
                                      text: '${day.day}',
                                      weight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (eventCount > 0)
                                    Positioned(
                                      bottom: -5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$eventCount',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                            todayBuilder: (context, day, focusedDay) {
                              final eventCount = _getEventsForDay(day).length;
                  
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: primaryBlue, width: 1)
                                    ),
                                    padding: const EdgeInsets.all(9),
                                    child: BodyText(
                                      text: '${day.day}',
                                      color: primaryBlue,
                                    ),
                                  ),
                                  if (eventCount > 0)
                                    Positioned(
                                      bottom: -5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(9),
                                        ),
                                        child: Text(
                                          '$eventCount',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 30,)
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
}
