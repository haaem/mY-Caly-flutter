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
  DateTime dt = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                child: TableCalendar(
                  focusedDay: dt,
                  firstDay: DateTime(dt.year, 1, 1),
                  lastDay: DateTime(dt.year, 12, 31),
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
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
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
    );
  }
}
