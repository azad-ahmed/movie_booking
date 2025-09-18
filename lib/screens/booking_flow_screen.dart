import 'package:flutter/material.dart';
import '../widgets/cinema_selection.dart';
import '../widgets/showtime_selection.dart';
import '../widgets/seat_selection.dart';
import '../widgets/booking_summary.dart';

class BookingFlowScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  const BookingFlowScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _BookingFlowScreenState createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  int _currentStep = 0;
  
  // Buchungsdaten
  Map<String, dynamic> _bookingData = {
    'movie': {},
    'cinema': null,
    'date': null,
    'time': null,
    'seats': <String>[],
    'totalPrice': 0.0,
  };

  final List<String> _stepTitles = [
    'Kino wählen',
    'Zeit wählen', 
    'Plätze wählen',
    'Bestätigen'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _bookingData['movie'] = widget.movie;
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _bookingData['cinema'] != null;
      case 1:
        return _bookingData['date'] != null && _bookingData['time'] != null;
      case 2:
        return _bookingData['seats'].isNotEmpty;
      case 3:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: Column(
            children: [
              // Header mit Progress Bar
              _buildHeader(),
              
              // Page View für die Schritte
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    CinemaSelection(
                      onCinemaSelected: (cinema) {
                        setState(() {
                          _bookingData['cinema'] = cinema;
                        });
                      },
                      selectedCinema: _bookingData['cinema'],
                    ),
                    ShowtimeSelection(
                      movie: widget.movie,
                      cinema: _bookingData['cinema'],
                      onShowtimeSelected: (date, time) {
                        setState(() {
                          _bookingData['date'] = date;
                          _bookingData['time'] = time;
                        });
                      },
                      selectedDate: _bookingData['date'],
                      selectedTime: _bookingData['time'],
                    ),
                    SeatSelection(
                      onSeatsSelected: (seats, totalPrice) {
                        setState(() {
                          _bookingData['seats'] = seats;
                          _bookingData['totalPrice'] = totalPrice;
                        });
                      },
                      selectedSeats: _bookingData['seats'],
                    ),
                    BookingSummary(
                      bookingData: _bookingData,
                      onBookingConfirmed: _confirmBooking,
                    ),
                  ],
                ),
              ),
              
              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Zurück Button und Titel
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (_currentStep > 0) {
                    _previousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Expanded(
                child: Text(
                  widget.movie['title'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48), // Platz für symmetrie
            ],
          ),
          
          SizedBox(height: 20),
          
          // Progress Indicator
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      // Progress Line
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentStep 
                              ? Theme.of(context).primaryColor
                              : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(height: 8),
                      // Step Label
                      Text(
                        _stepTitles[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: index == _currentStep 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          color: index <= _currentStep
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // Zurück Button
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Zurück',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          
          if (_currentStep > 0) SizedBox(width: 15),
          
          // Weiter/Buchen Button
          Expanded(
            flex: _currentStep == 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _canProceed() ? (_currentStep == 3 ? _confirmBooking : _nextStep) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canProceed() ? Theme.of(context).primaryColor : Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: _canProceed() ? 5 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentStep == 3 ? 'Jetzt buchen' : 'Weiter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (_currentStep == 3) ...[
                    SizedBox(width: 8),
                    Icon(Icons.payment_rounded, color: Colors.white, size: 20),
                  ] else ...[
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() async {
    print('Buchung starten mit Daten: $_bookingData'); // Debug
    
    // Validierung
    if (_bookingData['cinema'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte wähle ein Kino aus'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_bookingData['date'] == null || _bookingData['time'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte wähle Datum und Zeit aus'), backgroundColor: Colors.red),
      );
      return;
    }
    
    if (_bookingData['seats'].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bitte wähle mindestens einen Sitzplatz aus'), backgroundColor: Colors.red),
      );
      return;
    }
    // Zeige Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'Buchung wird verarbeitet...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );

    // Simuliere Buchungsverarbeitung
    await Future.delayed(Duration(seconds: 2));
    
    // Schließe Loading Dialog
    Navigator.pop(context);
    
    // Zeige Erfolgs Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text('Buchung erfolgreich!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deine Buchung wurde erfolgreich erstellt:'),
            SizedBox(height: 15),
            _buildBookingDetail('Film', widget.movie['title']),
            _buildBookingDetail('Kino', _bookingData['cinema']['name']),
            _buildBookingDetail('Datum', _bookingData['date']),
            _buildBookingDetail('Zeit', _bookingData['time']),
            _buildBookingDetail('Plätze', '${_bookingData['seats'].length} Plätze'),
            _buildBookingDetail('Preis', '${_bookingData['totalPrice'].toStringAsFixed(2)} CHF'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Zur vorherigen Seite
              Navigator.pop(context); // Zur Startseite
            },
            child: Text('Zur Startseite'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
              // Hier könntest du zum Ticket-Screen navigieren
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ticket wird generiert... 🎟️'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text('Ticket anzeigen', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetail(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}