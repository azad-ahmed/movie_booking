import 'package:flutter/material.dart';

class BookingManager extends ChangeNotifier {
  static final BookingManager _instance = BookingManager._internal();
  factory BookingManager() => _instance;
  BookingManager._internal();

  List<Map<String, dynamic>> _bookings = [
    // Beispiel-Buchungen mit vollständigen Details
    {
      'id': '1',
      'movieTitle': 'Avatar: Der Weg des Wassers',
      'cinema': 'CinemaX Basel',
      'date': '20.09.2025',
      'time': '20:30',
      'seats': 2,
      'price': 37.00,
      'isPast': false,
      'seatNumbers': ['G7', 'G8'],
      'bookingDate': '15.09.2025',
      'paymentMethod': 'Kreditkarte',
      'ticketType': 'Standard',
    },
    {
      'id': '2',
      'movieTitle': 'Top Gun: Maverick',
      'cinema': 'Kino Rex',
      'date': '18.09.2025',
      'time': '18:15',
      'seats': 1,
      'price': 18.50,
      'isPast': false,
      'seatNumbers': ['F5'],
      'bookingDate': '12.09.2025',
      'paymentMethod': 'PayPal',
      'ticketType': 'Standard',
    },
    {
      'id': '3',
      'movieTitle': 'Spider-Man: No Way Home',
      'cinema': 'Pathé Küchlin',
      'date': '15.09.2025',
      'time': '21:00',
      'seats': 3,
      'price': 55.50,
      'isPast': false,
      'seatNumbers': ['D4', 'D5', 'D6'],
      'bookingDate': '10.09.2025',
      'paymentMethod': 'TWINT',
      'ticketType': 'Premium',
    },
    {
      'id': '4',
      'movieTitle': 'The Batman',
      'cinema': 'Cinema Capitol',
      'date': '10.09.2025',
      'time': '19:45',
      'seats': 2,
      'price': 37.00,
      'isPast': true,
      'seatNumbers': ['H3', 'H4'],
      'bookingDate': '05.09.2025',
      'paymentMethod': 'Kreditkarte',
      'ticketType': 'Standard',
    },
    {
      'id': '5',
      'movieTitle': 'Doctor Strange 2',
      'cinema': 'Blue Cinema',
      'date': '08.09.2025',
      'time': '17:30',
      'seats': 1,
      'price': 18.50,
      'isPast': true,
      'seatNumbers': ['C2'],
      'bookingDate': '03.09.2025',
      'paymentMethod': 'Kreditkarte',
      'ticketType': 'Standard',
    },
  ];

  List<Map<String, dynamic>> get bookings => List.unmodifiable(_bookings);
  
  List<Map<String, dynamic>> get activeBookings => 
      _bookings.where((booking) => !booking['isPast']).toList();
  
  List<Map<String, dynamic>> get pastBookings => 
      _bookings.where((booking) => booking['isPast']).toList();

  void addBooking(Map<String, dynamic> booking) {
    booking['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    booking['isPast'] = false;
    _bookings.insert(0, booking); // Neue Buchungen oben
    notifyListeners();
    print('Buchung hinzugefügt: ${booking['movieTitle']}');
  }

  bool removeBooking(String bookingId) {
    final index = _bookings.indexWhere((booking) => booking['id'] == bookingId);
    if (index != -1) {
      final removedBooking = _bookings.removeAt(index);
      notifyListeners();
      print('Buchung entfernt: ${removedBooking['movieTitle']}');
      return true;
    }
    return false;
  }

  Map<String, dynamic>? restoreBooking(Map<String, dynamic> booking) {
    _bookings.insert(0, booking);
    notifyListeners();
    print('Buchung wiederhergestellt: ${booking['movieTitle']}');
    return booking;
  }

  Map<String, dynamic>? getBookingById(String id) {
    try {
      return _bookings.firstWhere((booking) => booking['id'] == id);
    } catch (e) {
      return null;
    }
  }

  void updateBooking(String id, Map<String, dynamic> updatedData) {
    final index = _bookings.indexWhere((booking) => booking['id'] == id);
    if (index != -1) {
      _bookings[index] = {..._bookings[index], ...updatedData};
      notifyListeners();
      print('Buchung aktualisiert: ${_bookings[index]['movieTitle']}');
    }
  }

  // Statistiken für die Startseite
  int get totalBookingsThisYear => _bookings.length;
  
  double get totalSavedMoney {
    // Simulierte Ersparnisse durch Angebote
    return _bookings.fold(0.0, (sum, booking) => sum + (booking['price'] * 0.1));
  }
  
  String get favoriteGenre => 'Action'; // Vereinfacht
  
  // Simuliere das Markieren alter Buchungen als vergangen
  void updatePastBookings() {
    final now = DateTime.now();
    for (var booking in _bookings) {
      try {
        final bookingDate = _parseDate(booking['date']);
        if (bookingDate.isBefore(now)) {
          booking['isPast'] = true;
        }
      } catch (e) {
        print('Fehler beim Parsen des Datums: ${booking['date']}');
      }
    }
    notifyListeners();
  }

  DateTime _parseDate(String dateString) {
    // Parse DD.MM.YYYY Format
    final parts = dateString.split('.');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    return DateTime.now();
  }

  void clearAllBookings() {
    _bookings.clear();
    notifyListeners();
    print('Alle Buchungen gelöscht');
  }

  // Für Debug-Zwecke
  void printAllBookings() {
    print('=== Alle Buchungen ===');
    for (var booking in _bookings) {
      print('${booking['id']}: ${booking['movieTitle']} - ${booking['isPast'] ? 'Vergangen' : 'Aktiv'}');
    }
    print('======================');
  }
}