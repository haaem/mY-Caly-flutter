import 'package:flutter/material.dart';
import 'package:my_caly_flutter/config/color.dart';
import 'package:my_caly_flutter/config/text/body_text.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:my_caly_flutter/pages/calendar/event.dart';
import 'package:get/get.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  DateTime? today;

  List<Event> _getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    today = DateTime.now();
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
    const months = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];
    return months[month - 1];
  }

  String _getWeekday(int day) {
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return weekdays[day-1];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '학사일정':
        return const Color(0xff97C2E6);
      case '장학금':
        return const Color(0xffFFE3E3);
      case '인턴':
        return const Color(0xffC9E9D2);
      case '채용':
        return const Color(0xffFEF9D9);
      case '행사':
        return const Color(0xffD2E0FB);
      case '대학원':
        return const Color(0xffFFD09B);
      case '대외활동':
        return const Color(0xffCEA8DE);
      case '동아리':
        return const Color(0xffB6A28E);
      default:
        return const Color(0xffC9C9C9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              // 캘린더
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: Column(
                  children: [
                    // header
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _focusedDay = today!;
                          _selectedDay = _focusedDay;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_focusedDay.year}. ',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                _monthName(_focusedDay.month),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
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
                        setState(() {
                          _focusedDay = focusedDay;
                        });
                      },
                      headerVisible: false,
                      daysOfWeekHeight: 50,
                      calendarStyle: const CalendarStyle(
                        defaultTextStyle: TextStyle(color: primaryBlue),
                        weekendTextStyle: TextStyle(color: Colors.red),
                        outsideDaysVisible: false,
                        // 기본 날짜 스타일
                        defaultDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      rowHeight: 80,
                      availableGestures: AvailableGestures.horizontalSwipe,
                      calendarBuilders: CalendarBuilders(
                        dowBuilder: (context, day) {
                          if (day.weekday == DateTime.saturday) {
                            // 토요일
                            return const Center(
                              child: Text(
                                'Sat',
                                style: TextStyle(color: Colors.blue),
                              ),
                            );
                          } else if (day.weekday == DateTime.sunday) {
                            // 일요일
                            return const Center(
                              child: Text(
                                'Sun',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          // 나머지 요일
                          return null;
                        },
                        defaultBuilder: (context, day, focusedDay) {
                          final dayEvents = _getEventsForDay(day);
                          final isSaturday = day.weekday == DateTime.saturday;
                          final isSunday = day.weekday == DateTime.sunday;
                          return _buildEvent(day, dayEvents, false, primaryTransparent, isSaturday, isSunday);
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          final dayEvents = _getEventsForDay(day);
                          final isSaturday = day.weekday == DateTime.saturday;
                          final isSunday = day.weekday == DateTime.sunday;
                          return _buildEvent(day, dayEvents, true, primaryBlack, isSaturday, isSunday);
                        },
                        todayBuilder: (context, day, focusedDay) {
                          final dayEvents = _getEventsForDay(day);
                          final isSaturday = day.weekday == DateTime.saturday;
                          final isSunday = day.weekday == DateTime.sunday;
                          return _buildEvent(day, dayEvents, true, Colors.black26, isSaturday, isSunday);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 1,
                color: primaryGrey,
              ),
              const SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,0,30,0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: '${_selectedDay!.day}. ${_getWeekday(_selectedDay!.weekday)}',
                      weight: FontWeight.w700,
                      size: 18,
                      color: (_selectedDay!.weekday == 6) ? Colors.blue : (_selectedDay!.weekday == 7) ? Colors.red : Colors.black,
                    ),
                    const SizedBox(height: 30,),
                    _selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _getEventsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final event = _getEventsForDay(_selectedDay!)[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/detail', arguments: {"id": event.id});
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(color: _getCategoryColor(event.category), width: 25, height: 25,)
                              ),
                              Flexible(
                                child: ListTile(
                                  title: BodyText(text: event.title, size: 18, weight: FontWeight.normal,),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        : const Center(
                      child: Text("No events for this day."),
                    ),
                    const SizedBox(height: 30,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvent(DateTime day, List<Event> dayEvents, bool hasCircle, Color circleColor, bool isSat, bool isSun) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 3),
      child: Column(
        children: [
          hasCircle ? Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${day.day}',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: isSat ? Colors.blue : isSun ? Colors.red : Colors.white),
            ),
          ) : Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: isSat ? Colors.blue : isSun ? Colors.red : Colors.black
            ),
          ),
          const SizedBox(height: 2,),
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
                    margin: const EdgeInsets.symmetric(vertical: 0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 8.5,
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