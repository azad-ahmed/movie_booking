import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/booking_service.dart';
import '../../models/booking.dart';
import '../../models/movie.dart';
import '../../models/cinema.dart';
import '../../widgets/movie_selection_widget.dart';
import '../../widgets/cinema_selection_widget.dart';
import '../../widgets/datetime_selection_widget.dart';

class AddBookingScreen extends StatefulWidget {
  final Booking? bookingToEdit; // NULL = neue Buchung, sonst = bearbeiten

  const AddBookingScreen({Key? key, this.bookingToEdit}) : super(key: key);

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _movieController = TextEditingController();
  final _cinemaController = TextEditingController();
  final _seatsController = TextEditingController();
  final _priceController = TextEditingController();
  
  final BookingService _bookingService = BookingService();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  bool get isEditing => widget.bookingToEdit != null;

  final List<String> _popularCinemas = [
    'CineStar Basel',
    'Pathé Küchlin',
    'Rex Kino',
    'Cineplex',
    'Scala Kino',
    'Camera Kino'
  ];

  @override
  void initState() {
    super.initState();
    
    // Falls Bearbeitung: Felder mit bestehenden Daten füllen
    if (isEditing) {
      final booking = widget.bookingToEdit!;
      _movieController.text = booking.movieTitle;
      _cinemaController.text = booking.cinema;
      _seatsController.text = booking.seats.toString();
      _priceController.text = booking.totalPrice.toString();
      _selectedDate = booking.showtime;
      _selectedTime = TimeOfDay.fromDateTime(booking.showtime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEditing ? 'Buchung bearbeiten' : 'Neue Buchung'),
        backgroundColor: isEditing ? Colors.orange : Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
              decoration: BoxDecoration(
                color: isEditing ? Colors.orange : Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.movie_creation,
                    size: 60,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    isEditing ? 'Ticket bearbeiten' : 'Film-Tickets buchen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form section
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Movie selection with images and descriptions
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: MovieSelectionWidget(
                          selectedMovieTitle: _movieController.text.isEmpty ? null : _movieController.text,
                          onMovieSelected: (movie) {
                            setState(() {
                              _movieController.text = movie.title;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Cinema selection with images and descriptions
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CinemaSelectionWidget(
                          selectedCinemaName: _cinemaController.text.isEmpty ? null : _cinemaController.text,
                          onCinemaSelected: (cinema) {
                            setState(() {
                              _cinemaController.text = cinema.name;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Date and time selection with improved UI
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: DateTimeSelectionWidget(
                          initialDate: _selectedDate,
                          initialTime: _selectedTime,
                          onDateTimeChanged: (date, time) {
                            setState(() {
                              _selectedDate = date;
                              _selectedTime = time;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Seats and price - simplified for now
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Buchungsdetails ändern' : 'Buchungsdetails',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _seatsController,
                                    decoration: InputDecoration(
                                      labelText: 'Anzahl Plätze',
                                      prefixIcon: Icon(Icons.event_seat),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Anzahl eingeben';
                                      }
                                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                        return 'Gültige Anzahl';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _priceController,
                                    decoration: InputDecoration(
                                      labelText: 'Gesamtpreis (CHF)',
                                      prefixIcon: Icon(Icons.monetization_on),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Preis eingeben';
                                      }
                                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                                        return 'Gültiger Preis';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Submit button
                    ElevatedButton(
                      onPressed: _isLoading ? null : (isEditing ? _updateBooking : _saveBooking),
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              isEditing ? 'Änderungen speichern' : 'Buchung speichern',
                              style: TextStyle(fontSize: 18),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isEditing ? Colors.orange : Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      if (user != null && widget.bookingToEdit?.id != null) {
        final showtime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final updatedBooking = widget.bookingToEdit!.copyWith(
          movieTitle: _movieController.text.trim(),
          cinema: _cinemaController.text.trim(),
          showtime: showtime,
          seats: int.parse(_seatsController.text),
          totalPrice: double.parse(_priceController.text),
        );

        await _bookingService.updateBooking(widget.bookingToEdit!.id!, updatedBooking);
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buchung erfolgreich aktualisiert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Aktualisieren der Buchung'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      if (user != null) {
        final showtime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        final booking = Booking(
          userId: user.uid,
          movieTitle: _movieController.text.trim(),
          cinema: _cinemaController.text.trim(),
          showtime: showtime,
          seats: int.parse(_seatsController.text),
          totalPrice: double.parse(_priceController.text),
          createdAt: DateTime.now(),
        );

        await _bookingService.createBooking(booking);
        
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Buchung erfolgreich gespeichert!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Speichern der Buchung'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _movieController.dispose();
    _cinemaController.dispose();
    _seatsController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}