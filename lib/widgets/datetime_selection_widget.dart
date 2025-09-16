import 'package:flutter/material.dart';

class DateTimeSelectionWidget extends StatefulWidget {
  final DateTime initialDate;
  final TimeOfDay initialTime;
  final Function(DateTime, TimeOfDay) onDateTimeChanged;

  const DateTimeSelectionWidget({
    Key? key,
    required this.initialDate,
    required this.initialTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  _DateTimeSelectionWidgetState createState() => _DateTimeSelectionWidgetState();
}

class _DateTimeSelectionWidgetState extends State<DateTimeSelectionWidget> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    selectedTime = widget.initialTime;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datum und Uhrzeit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        
        // Quick date selection buttons
        Text(
          'Schnellauswahl',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildQuickDateButtons(),
          ),
        ),
        
        SizedBox(height: 20),
        
        // Current selection display
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event,
                color: Colors.blue[700],
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ausgewählter Termin',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatDateTime(selectedDate, selectedTime),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      _getRelativeDate(selectedDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 20),
        
        // Custom date/time selection
        Row(
          children: [
            Expanded(
              child: _buildCustomButton(
                icon: Icons.calendar_today,
                title: 'Datum wählen',
                subtitle: _formatDate(selectedDate),
                onTap: _selectCustomDate,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildCustomButton(
                icon: Icons.access_time,
                title: 'Zeit wählen',
                subtitle: _formatTime(selectedTime),
                onTap: _selectCustomTime,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16),
        
        // Popular time slots
        Text(
          'Beliebte Zeiten',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildTimeSlots(),
        ),
      ],
    );
  }

  List<Widget> _buildQuickDateButtons() {
    final now = DateTime.now();
    List<Widget> buttons = [];

    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      final isSelected = _isSameDay(date, selectedDate);
      final isToday = i == 0;
      
      buttons.add(
        Container(
          margin: EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () => _selectDate(date),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[600] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    isToday ? 'Heute' : _getWeekday(date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${date.day}.${date.month}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return buttons;
  }

  Widget _buildCustomButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeSlots() {
    final timeSlots = [
      '14:00', '15:30', '17:00', '18:30', '20:00', '21:30'
    ];
    
    return timeSlots.map((timeStr) {
      final parts = timeStr.split(':');
      final time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      final isSelected = selectedTime.hour == time.hour && selectedTime.minute == time.minute;
      
      return InkWell(
        onTap: () => _selectTime(time),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange[600] : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.orange[600]! : Colors.grey[300]!,
            ),
          ),
          child: Text(
            timeStr,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateTimeChanged(selectedDate, selectedTime);
  }

  void _selectTime(TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
    widget.onDateTimeChanged(selectedDate, selectedTime);
  }

  Future<void> _selectCustomDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _selectDate(picked);
    }
  }

  Future<void> _selectCustomTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      _selectTime(picked);
    }
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    return '${_formatDate(date)} um ${_formatTime(time)}';
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final months = [
      'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
      'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${date.day}. ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getWeekday(DateTime date) {
    final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return weekdays[date.weekday - 1];
  }

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(DateTime(now.year, now.month, now.day)).inDays;
    
    if (difference == 0) return 'Heute';
    if (difference == 1) return 'Morgen';
    if (difference == 2) return 'Übermorgen';
    if (difference < 7) return 'In ${difference} Tagen';
    
    return 'In ${(difference / 7).floor()} Woche${difference >= 14 ? 'n' : ''}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}