import 'package:flutter/material.dart';
import '../services/booking_manager.dart';

class EditBookingScreen extends StatefulWidget {
  final String bookingId;

  const EditBookingScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _EditBookingScreenState createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final BookingManager _bookingManager = BookingManager();
  Map<String, dynamic>? _booking;
  
  // Bearbeitbare Felder
  String? _selectedCinema;
  String? _selectedDate;
  String? _selectedTime;
  List<String> _selectedSeats = [];
  double _totalPrice = 0.0;
  String? _paymentMethod;

  // Verfügbare Optionen
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
    '24.09.2025',
    '25.09.2025',
    '26.09.2025'
  ];

  final List<String> _times = [
    '14:30',
    '17:15',
    '19:45', 
    '22:20'
  ];

  final List<String> _availableSeats = [
    'A1', 'A2', 'A3', 'A4', 'A5',
    'B1', 'B2', 'B3', 'B4', 'B5',
    'C1', 'C2', 'C3', 'C4', 'C5',
    'D1', 'D2', 'D3', 'D4', 'D5',
    'E1', 'E2', 'E3', 'E4', 'E5'
  ];

  final List<String> _paymentMethods = [
    'Kreditkarte',
    'PayPal',
    'TWINT'
  ];

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadBookingData();
  }

  void _loadBookingData() {
    _booking = _bookingManager.getBookingById(widget.bookingId);
    if (_booking != null) {
      setState(() {
        _selectedCinema = _booking!['cinema'];
        _selectedDate = _booking!['date'];
        _selectedTime = _booking!['time'];
        _selectedSeats = List.from(_booking!['seatNumbers'] ?? []);
        _totalPrice = _booking!['price'].toDouble();
        _paymentMethod = _booking!['paymentMethod'];
      });
    }
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _updateTotalPrice() {
    setState(() {
      _totalPrice = _selectedSeats.length * 18.50; // Vereinfacht: 18.50 CHF pro Platz
    });
    _markAsChanged();
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
          child: Text('Buchung nicht gefunden'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Buchung bearbeiten'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _saveChanges,
              child: Text(
                'SPEICHERN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.blue.withOpacity(0.05),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film Info (nicht bearbeitbar)
              _buildFilmInfoCard(),
              
              SizedBox(height: 20),
              
              // Kino ändern
              _buildCinemaSelection(),
              
              SizedBox(height: 20),
              
              // Datum ändern
              _buildDateSelection(),
              
              SizedBox(height: 20),
              
              // Zeit ändern
              _buildTimeSelection(),
              
              SizedBox(height: 20),
              
              // Plätze ändern
              _buildSeatSelection(),
              
              SizedBox(height: 20),
              
              // Zahlungsmethode ändern
              _buildPaymentMethodSelection(),
              
              SizedBox(height: 30),
              
              // Änderungen Zusammenfassung
              if (_hasChanges) _buildChangesSummary(),
              
              SizedBox(height: 20),
              
              // Action Buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilmInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.movie, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text(
                'Film (nicht änderbar)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            _booking!['movieTitle'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Buchungs-ID: ${widget.bookingId}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaSelection() {
    return _buildSection(
      'Kino wählen',
      Icons.location_on,
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCinema,
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
              _markAsChanged();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return _buildSection(
      'Datum wählen',
      Icons.calendar_today,
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _dates.map((date) {
          final isSelected = _selectedDate == date;
          return FilterChip(
            label: Text(date),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedDate = date;
              });
              _markAsChanged();
            },
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimeSelection() {
    return _buildSection(
      'Zeit wählen',
      Icons.access_time,
      GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: _times.map((time) {
          final isSelected = _selectedTime == time;
          return ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedTime = time;
              });
              _markAsChanged();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[200],
              foregroundColor: isSelected ? Colors.white : Colors.black87,
              elevation: isSelected ? 3 : 1,
            ),
            child: Text(time),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSeatSelection() {
    return _buildSection(
      'Plätze wählen',
      Icons.event_seat,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktuell: ${_selectedSeats.join(', ')}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: _availableSeats.map((seat) {
              final isSelected = _selectedSeats.contains(seat);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedSeats.remove(seat);
                    } else {
                      if (_selectedSeats.length < 8) {
                        _selectedSeats.add(seat);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Maximal 8 Plätze möglich'),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                    }
                  });
                  _updateTotalPrice();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      seat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 15),
          if (_selectedSeats.isNotEmpty)
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedSeats.length} Plätze',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${_totalPrice.toStringAsFixed(2)} CHF',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelection() {
    return _buildSection(
      'Zahlungsmethode',
      Icons.payment,
      Column(
        children: _paymentMethods.map((method) {
          final isSelected = _paymentMethod == method;
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(method),
              leading: Radio<String>(
                value: method,
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                  _markAsChanged();
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              onTap: () {
                setState(() {
                  _paymentMethod = method;
                });
                _markAsChanged();
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey[300]!,
                ),
              ),
              tileColor: isSelected 
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildChangesSummary() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.orange),
              SizedBox(width: 10),
              Text(
                'Nicht gespeicherte Änderungen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Du hast Änderungen vorgenommen. Vergiss nicht zu speichern!',
            style: TextStyle(color: Colors.orange[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Speichern Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _hasChanges ? _saveChanges : null,
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
              backgroundColor: _hasChanges ? Colors.green : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 15),
        
        // Zurücksetzen & Abbrechen Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _hasChanges ? _resetChanges : null,
                icon: Icon(Icons.refresh),
                label: Text('Zurücksetzen'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
                label: Text('Abbrechen'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _saveChanges() {
    if (!_hasChanges) return;
    
    // Validierung
    if (_selectedCinema == null || _selectedDate == null || 
        _selectedTime == null || _selectedSeats.isEmpty || _paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bitte fülle alle Felder aus'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Änderungen speichern
    final updatedBooking = {
      'cinema': _selectedCinema,
      'date': _selectedDate,
      'time': _selectedTime,
      'seats': _selectedSeats.length,
      'price': _totalPrice,
      'seatNumbers': List.from(_selectedSeats),
      'paymentMethod': _paymentMethod,
    };

    _bookingManager.updateBooking(widget.bookingId, updatedBooking);

    // Erfolg anzeigen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Buchung erfolgreich aktualisiert!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Zurück navigieren
    Navigator.pop(context, true); // true = Änderungen gespeichert
  }

  void _resetChanges() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Änderungen zurücksetzen?'),
        content: Text('Alle nicht gespeicherten Änderungen gehen verloren.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _loadBookingData(); // Ursprüngliche Daten laden
              setState(() {
                _hasChanges = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Änderungen zurückgesetzt'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text('Zurücksetzen'),
          ),
        ],
      ),
    );
  }
}