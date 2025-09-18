import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowtimeSelection extends StatefulWidget {
  final Map<String, dynamic> movie;
  final Map<String, dynamic>? cinema;
  final Function(String, String) onShowtimeSelected;
  final String? selectedDate;
  final String? selectedTime;

  const ShowtimeSelection({
    Key? key,
    required this.movie,
    required this.cinema,
    required this.onShowtimeSelected,
    this.selectedDate,
    this.selectedTime,
  }) : super(key: key);

  @override
  _ShowtimeSelectionState createState() => _ShowtimeSelectionState();
}

class _ShowtimeSelectionState extends State<ShowtimeSelection> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String? _selectedDate;
  String? _selectedTime;

  // Beispiel Daten für die nächsten 7 Tage
  List<Map<String, dynamic>> _dates = [];
  
  Map<String, List<Map<String, dynamic>>> _showtimes = {
    // Verschiedene Zeiten je nach Tag
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _selectedDate = widget.selectedDate;
    _selectedTime = widget.selectedTime;
    
    _generateDates();
    _generateShowtimes();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateDates() {
    _dates.clear();
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      _dates.add({
        'date': DateFormat('dd.MM.yyyy').format(date),
        'dayName': _getDayName(date),
        'isToday': i == 0,
        'isTomorrow': i == 1,
      });
    }
  }

  String _getDayName(DateTime date) {
    final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return weekdays[date.weekday - 1];
  }

  void _generateShowtimes() {
    final times = ['14:30', '17:15', '19:45', '22:20'];
    final types = ['2D', '3D', 'IMAX', 'VIP'];
    final prices = [18.50, 22.00, 26.50, 32.00];
    
    for (final dateItem in _dates) {
      final date = dateItem['date'];
      _showtimes[date] = [];
      
      for (int i = 0; i < times.length; i++) {
        _showtimes[date]!.add({
          'time': times[i],
          'type': types[i],
          'price': prices[i],
          'availableSeats': 45 - (i * 8), // Simulierte verfügbare Plätze
          'isAlmostFull': (45 - (i * 8)) < 15,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cinema == null) {
      return Center(
        child: Text(
          'Bitte wähle zuerst ein Kino aus',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Wähle Datum & Zeit ⏰',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${widget.movie['title']} im ${widget.cinema!['name']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Datum Auswahl
            Text(
              'Datum wählen',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: 12),
            
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final dateItem = _dates[index];
                  final isSelected = _selectedDate == dateItem['date'];
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = dateItem['date'];
                        _selectedTime = null; // Reset time selection
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: 12),
                      width: 70,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected 
                              ? Theme.of(context).primaryColor
                              : Colors.grey.withOpacity(0.2),
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateItem['dayName'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.white : Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            dateItem['date'].split('.')[0], // Nur Tag
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
                            ),
                          ),
                          if (dateItem['isToday'])
                            Text(
                              'Heute',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : Theme.of(context).primaryColor,
                              ),
                            )
                          else if (dateItem['isTomorrow'])
                            Text(
                              'Morgen',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            SizedBox(height: 25),
            
            // Zeit Auswahl
            if (_selectedDate != null) ...[
              Row(
                children: [
                  Text(
                    'Vorstellungszeit wählen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  Spacer(),
                  Text(
                    _selectedDate!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _showtimes[_selectedDate]?.length ?? 0,
                  itemBuilder: (context, index) {
                    final showtime = _showtimes[_selectedDate]![index];
                    final isSelected = _selectedTime == showtime['time'];
                    
                    return GestureDetector(
                      onTap: () {
                        print('Zeit ausgewählt: ${showtime['time']}'); // Debug
                        setState(() {
                          _selectedTime = showtime['time'];
                        });
                        widget.onShowtimeSelected(_selectedDate!, showtime['time']);
                        print('Callback aufgerufen mit: $_selectedDate, ${showtime['time']}'); // Debug
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? Theme.of(context).primaryColor
                                : Colors.grey.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  showtime['time'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected 
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).textTheme.titleMedium?.color,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getTypeColor(showtime['type']).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    showtime['type'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _getTypeColor(showtime['type']),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${showtime['price'].toStringAsFixed(2)} CHF',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.event_seat,
                                      size: 12,
                                      color: showtime['isAlmostFull'] ? Colors.orange : Colors.green,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '${showtime['availableSeats']}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: showtime['isAlmostFull'] ? Colors.orange : Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 80,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Wähle zuerst ein Datum aus 📅',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case '2D':
        return Colors.blue;
      case '3D':
        return Colors.orange;
      case 'IMAX':
        return Colors.red;
      case 'VIP':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}