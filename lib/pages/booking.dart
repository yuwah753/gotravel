import 'package:flutter/material.dart';
import 'package:gotravel/pages/notif.dart';
import 'package:gotravel/pages/payment.dart';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> destination;

  BookingPage({required this.destination});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool _isFlexible = false;
  DateTime _today = DateTime.now();

  void _onDateSelected(DateTime date) {
    if (date.isBefore(_today)) return;

    if (_selectedStartDate == null ||
        (_selectedStartDate != null && _selectedEndDate != null)) {
      setState(() {
        _selectedStartDate = date;
        _selectedEndDate = null;
      });
    } else if (_selectedStartDate != null && _selectedEndDate == null) {
      setState(() {
        _selectedEndDate = date;
      });
    }
  }

  List<Widget> _buildCalendar(DateTime month) {
    final List<Widget> days = [];

    final DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    final DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final int daysInMonth = lastDayOfMonth.day;

    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];

    for (String weekday in weekdays) {
      days.add(
        Container(
          margin: EdgeInsets.all(2.0),
          alignment: Alignment.center,
          child: Text(
            weekday,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    for (int i = 0; i < firstDayOfMonth.weekday - 1; i++) {
      days.add(Container());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      final DateTime date = DateTime(month.year, month.month, i);
      bool isSelected =
          (date == _selectedStartDate || date == _selectedEndDate);
      bool rangeSelected = (_selectedStartDate != null &&
          _selectedEndDate != null &&
          date.isAfter(_selectedStartDate!) &&
          date.isBefore(_selectedEndDate!));
      bool isToday = date.day == _today.day &&
          date.month == _today.month &&
          date.year == _today.year;
      bool isPast = date.isBefore(_today);
      bool isHoliday = _isHoliday(date);

      days.add(
        GestureDetector(
          onTap: () => _onDateSelected(date),
          child: Container(
            margin: EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blue
                  : rangeSelected
                      ? Colors.blue[200]
                      : isToday
                          ? Colors.grey.withOpacity(0.4)
                          : isPast
                              ? Colors.transparent
                              : Colors.transparent,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Text(
                i.toString(),
                style: TextStyle(
                    color: isSelected
                        ? Colors.blue[800]
                        : isPast
                            ? Colors.grey
                            : isHoliday
                                ? Colors.red
                                : Colors.black),
              ),
            ),
          ),
        ),
      );
    }
    return days;
  }

  bool _isHoliday(DateTime date) {
    return date.weekday == DateTime.sunday;
  }

  Widget _buildMonthCalendar(String monthName, DateTime month) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              monthName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Month',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
        SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: _buildCalendar(month),
        ),
      ],
    );
  }

  Widget _customSwitch(bool value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlexible = !_isFlexible;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 24.0,
        width: 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: _isFlexible ? Colors.blue : Colors.grey,
        ),
        child: AnimatedAlign(
          duration: Duration(milliseconds: 200),
          alignment: _isFlexible ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeIn,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Schedule',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none_outlined,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildMonthCalendar('June', DateTime(2024, 6)),
                  SizedBox(height: 20),
                  _buildMonthCalendar('July', DateTime(2024, 7)),
                  SizedBox(height: 20),
                  _buildMonthCalendar('August', DateTime(2024, 8)),
                  SizedBox(height: 20),
                  _buildMonthCalendar('September', DateTime(2024, 9)),
                  SizedBox(height: 20),
                  _buildMonthCalendar('October', DateTime(2024, 10)),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Travel date ± 1 day',
                        style: TextStyle(fontSize: 16),
                      ),
                      Spacer(),
                      _customSwitch(_isFlexible),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedStartDate != null &&
                          _selectedEndDate != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentPage(
                              startDate: _selectedStartDate!,
                              endDate: _selectedEndDate!,
                              destination: widget.destination,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select a date range')),
                        );
                      }
                    },
                    child: Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue[300],
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
