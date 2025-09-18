import 'package:flutter/material.dart';
import '../services/booking_manager.dart';

class SimpleEditBooking extends StatefulWidget {
  final String bookingId;

  const SimpleEditBooking({Key? key, required this.bookingId}) : super(key: key);

  @override
  _SimpleEditBookingState createState() => _SimpleEditBookingState();
}

class _SimpleEditBookingState extends State<SimpleEditBooking> {
  final BookingManager _bookingManager = BookingManager();
  Map<String, dynamic>? _booking;
  
  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  String? _selectedCinema;
  String? _selectedDate;
  String? _selectedTime;
  int _numberOfSeats = 1;
  double _totalPrice = 18.50;

  // Dropdown Options
  final List<String> _cinemas = [
    'CinemaX Basel',
    'Kino Rex',
    'Pathé Küchlin',
    'Cinema Capitol',
    'Blue Cinema'
  ];

  final List<String> _dates = [
    '20.09.2025',
    '21.09.2025',
    '22.09.2025',
    '23.09.2025',
    '24.09.2025'
  ];

  final List<String> _times = [
    '14:30',
    '17:15',
    '19:45',
    '22:20'
  ];

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  void _loadBooking() {
    _booking = _bookingManager.getBookingById(widget.bookingId);
    if (_booking != null) {
      setState(() {
        _selectedCinema = _booking!['cinema'];
        _selectedDate = _booking!['date'];
        _selectedTime = _booking!['time'];
        _numberOfSeats = _booking!['seats'];
        _totalPrice = _booking!['price'].toDouble();
      });
    }
  }

  void _updatePrice() {
    setState(() {
      _totalPrice = _numberOfSeats * 18.50;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Buchung bearbeiten'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text('Buchung nicht gefunden', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Buchung bearbeiten'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Film Info (nicht editierbar)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Film (nicht änderbar)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        _booking!['movieTitle'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Buchungs-ID: ${widget.bookingId}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Kino
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kino wählen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedCinema,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        items: _cinemas.map((cinema) {
                          return DropdownMenuItem(
                            value: cinema,
                            child: Text(cinema),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCinema = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte wähle ein Kino aus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Datum
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Datum wählen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedDate,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        items: _dates.map((date) {
                          return DropdownMenuItem(
                            value: date,
                            child: Text(date),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDate = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte wähle ein Datum aus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Zeit
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zeit wählen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        ),
                        items: _times.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTime = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bitte wähle eine Zeit aus';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Anzahl Plätze
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Anzahl Plätze',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _numberOfSeats > 1 ? () {
                              setState(() {
                                _numberOfSeats--;
                              });
                              _updatePrice();
                            } : null,
                            icon: Icon(Icons.remove_circle_outline),
                            color: Theme.of(context).primaryColor,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_numberOfSeats',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            onPressed: _numberOfSeats < 8 ? () {
                              setState(() {
                                _numberOfSeats++;
                              });
                              _updatePrice();
                            } : null,
                            icon: Icon(Icons.add_circle_outline),
                            color: Theme.of(context).primaryColor,
                          ),
                          Spacer(),
                          Text(
                            '${_totalPrice.toStringAsFixed(2)} CHF',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Preis pro Platz: 18.50 CHF',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Speichern Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    'Änderungen speichern',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Abbrechen Button
              SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.cancel),
                  label: Text('Abbrechen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Loading anzeigen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Speichere Änderungen...'),
          ],
        ),
      ),
    );

    // Simulate saving
    await Future.delayed(Duration(seconds: 1));

    // Buchung aktualisieren
    final updatedData = {
      'cinema': _selectedCinema!,
      'date': _selectedDate!,
      'time': _selectedTime!,
      'seats': _numberOfSeats,
      'price': _totalPrice,
    };

    _bookingManager.updateBooking(widget.bookingId, updatedData);

    // Loading Dialog schließen
    Navigator.pop(context);

    // Erfolgs-Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Gespeichert!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deine Buchung wurde erfolgreich aktualisiert:'),
            SizedBox(height: 10),
            Text('🎬 ${_booking!['movieTitle']}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('🏢 $_selectedCinema'),
            Text('📅 $_selectedDate um $_selectedTime'),
            Text('🎫 $_numberOfSeats Plätze'),
            Text('💰 ${_totalPrice.toStringAsFixed(2)} CHF', 
                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context, true); // Zurück mit Änderungen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}