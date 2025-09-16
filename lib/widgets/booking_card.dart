import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onDelete;

  const BookingCard({
    Key? key,
    required this.booking,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPastEvent = booking.showtime.isBefore(now);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: isPastEvent
              ? LinearGradient(
                  colors: [Colors.grey[100]!, Colors.grey[50]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.red[50]!, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with movie title and action buttons
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.movieTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPastEvent ? Colors.grey[600] : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (isPastEvent)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Vergangen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Bevorstehend',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Action buttons
                  if (!isPastEvent) ...[
                    IconButton(
                      onPressed: () {
                        _showEditDialog(context);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.orange[600],
                      ),
                      tooltip: 'Buchung bearbeiten',
                    ),
                  ],
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red[400],
                    ),
                    tooltip: 'Buchung löschen',
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Cinema and date info
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: isPastEvent ? Colors.grey[500] : Colors.red[300],
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      booking.cinema,
                      style: TextStyle(
                        fontSize: 14,
                        color: isPastEvent ? Colors.grey[600] : Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 8),
              
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isPastEvent ? Colors.grey[500] : Colors.red[300],
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDateTime(booking.showtime),
                    style: TextStyle(
                      fontSize: 14,
                      color: isPastEvent ? Colors.grey[600] : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Divider
              Container(
                height: 1,
                color: Colors.grey[200],
              ),
              
              SizedBox(height: 12),
              
              // Booking details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plätze',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${booking.seats}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPastEvent ? Colors.grey[600] : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Gesamtpreis',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'CHF ${booking.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isPastEvent ? Colors.grey[600] : Colors.red[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Time until showtime (only for upcoming events)
              if (!isPastEvent) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getTimeUntilShowtime(booking.showtime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final weekdays = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final months = [
      'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
      'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
    ];
    
    final weekday = weekdays[dateTime.weekday - 1];
    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$weekday, $day. $month $year um $hour:$minute';
  }

  String _getTimeUntilShowtime(DateTime showtime) {
    final now = DateTime.now();
    final difference = showtime.difference(now);
    
    if (difference.inDays > 0) {
      return 'In ${difference.inDays} Tag${difference.inDays == 1 ? '' : 'en'}';
    } else if (difference.inHours > 0) {
      return 'In ${difference.inHours} Stunde${difference.inHours == 1 ? '' : 'n'}';
    } else if (difference.inMinutes > 0) {
      return 'In ${difference.inMinutes} Minute${difference.inMinutes == 1 ? '' : 'n'}';
    } else {
      return 'Beginnt jetzt';
    }
  }

  void _showEditDialog(BuildContext context) {
    final _movieController = TextEditingController(text: booking.movieTitle);
    final _cinemaController = TextEditingController(text: booking.cinema);
    final _seatsController = TextEditingController(text: booking.seats.toString());
    final _priceController = TextEditingController(text: booking.totalPrice.toString());
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.orange),
            SizedBox(width: 8),
            Text('Buchung bearbeiten'),
          ],
        ),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _movieController,
                  decoration: InputDecoration(
                    labelText: 'Film',
                    prefixIcon: Icon(Icons.movie),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Film eingeben' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cinemaController,
                  decoration: InputDecoration(
                    labelText: 'Kino',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'Kino eingeben' : null,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _seatsController,
                        decoration: InputDecoration(
                          labelText: 'Plätze',
                          prefixIcon: Icon(Icons.event_seat),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Anzahl eingeben';
                          if (int.tryParse(value!) == null) return 'Nur Zahlen';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Preis (CHF)',
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value?.isEmpty == true) return 'Preis eingeben';
                          if (double.tryParse(value!) == null) return 'Ungültiger Preis';
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final updatedBooking = booking.copyWith(
                    movieTitle: _movieController.text.trim(),
                    cinema: _cinemaController.text.trim(),
                    seats: int.parse(_seatsController.text),
                    totalPrice: double.parse(_priceController.text),
                  );
                  
                  await BookingService().updateBooking(booking.id!, updatedBooking);
                  
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Buchung erfolgreich aktualisiert!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Fehler beim Aktualisieren: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text('Speichern', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}