import 'package:flutter/material.dart';
import '../services/booking_manager.dart';
import '../screens/booking_details_screen.dart';
import '../screens/simple_edit_booking.dart';

class BookingCard extends StatefulWidget {
  final String bookingId;
  final String movieTitle;
  final String cinema;
  final String date;
  final String time;
  final int seats;
  final double price;
  final bool isPast;
  final Duration animationDelay;
  final VoidCallback? onBookingDeleted;

  const BookingCard({
    Key? key,
    required this.bookingId,
    required this.movieTitle,
    required this.cinema,
    required this.date,
    required this.time,
    required this.seats,
    required this.price,
    this.isPast = false,
    this.animationDelay = Duration.zero,
    this.onBookingDeleted,
  }) : super(key: key);

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final BookingManager _bookingManager = BookingManager();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    // Animation mit Verzögerung starten
    Future.delayed(widget.animationDelay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            elevation: widget.isPast ? 2 : 8,
            shadowColor: widget.isPast 
                ? Colors.grey.withOpacity(0.2)
                : Theme.of(context).primaryColor.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: widget.isPast
                    ? LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.1),
                          Colors.grey.withOpacity(0.05),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Colors.blue.withOpacity(0.05),
                        ],
                      ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header mit Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.isPast 
                                ? Colors.grey.withOpacity(0.2)
                                : Theme.of(context).primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.isPast ? '✓ Vergangen' : '🎬 Aktiv',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.isPast 
                                  ? Colors.grey[600]
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        
                        // Mehr-Optionen Button
                        IconButton(
                          icon: Icon(
                            Icons.more_vert_rounded,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () => _showOptionsMenu(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Film Titel
                    Text(
                      widget.movieTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.isPast
                            ? Theme.of(context).textTheme.titleMedium?.color?.withOpacity(0.7)
                            : Theme.of(context).textTheme.titleLarge?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Kino Info
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.cinema,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Datum und Zeit
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 8),
                        
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.time,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12),
                    
                    // Footer mit Sitzplätzen und Preis
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.event_seat_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${widget.seats} ${widget.seats == 1 ? 'Platz' : 'Plätze'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        
                        Text(
                          '${widget.price.toStringAsFixed(2)} CHF',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: widget.isPast
                                ? Colors.grey[600]
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    // Countdown für aktive Buchungen
                    if (!widget.isPast) ...[
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Noch 3 Tage bis zur Vorstellung ⏰',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildMenuOption(
                      context,
                      Icons.info_rounded,
                      'Details anzeigen',
                      'Vollständige Buchungsdetails',
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                        _showBookingDetails(context);
                      },
                    ),
                    
                    if (!widget.isPast) ...[
                      _buildMenuOption(
                        context,
                        Icons.edit_rounded,
                        'Bearbeiten',
                        'Buchung ändern',
                        Colors.orange,
                        () {
                          Navigator.pop(context);
                          _editBooking(context);
                        },
                      ),
                      
                      _buildMenuOption(
                        context,
                        Icons.share_rounded,
                        'Teilen',
                        'Buchung mit Freunden teilen',
                        Colors.green,
                        () {
                          Navigator.pop(context);
                          _shareBooking(context);
                        },
                      ),
                    ],
                    
                    _buildMenuOption(
                      context,
                      Icons.delete_rounded,
                      widget.isPast ? 'Aus Historie entfernen' : 'Stornieren',
                      widget.isPast ? 'Aus Liste entfernen' : 'Buchung stornieren',
                      Colors.red,
                      () {
                        Navigator.pop(context);
                        _deleteBooking(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey[400],
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailsScreen(bookingId: widget.bookingId),
      ),
    );
  }

  void _editBooking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimpleEditBooking(bookingId: widget.bookingId),
      ),
    ).then((result) {
      // Wenn Änderungen gespeichert wurden, aktualisiere die UI
      if (result == true) {
        widget.onBookingDeleted?.call(); // Trigger refresh
      }
    });
  }

  void _shareBooking(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buchung wird geteilt... 📤'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteBooking(BuildContext context) {
    // Sichere die Buchung für Undo-Funktion
    final booking = _bookingManager.getBookingById(widget.bookingId);
    if (booking == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.isPast ? 'Aus Historie entfernen?' : 'Buchung stornieren?'),
        content: Text(
          widget.isPast 
              ? 'Diese Buchung wird aus deiner Historie entfernt.'
              : 'Möchtest du diese Buchung wirklich stornieren?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Buchung wirklich löschen
              final success = _bookingManager.removeBooking(widget.bookingId);
              
              if (success) {
                // UI aktualisieren
                widget.onBookingDeleted?.call();
                
                // Bestätigung mit Undo-Option anzeigen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      widget.isPast 
                          ? '✅ Buchung aus Historie entfernt'
                          : '✅ Buchung erfolgreich storniert'
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 4),
                    action: SnackBarAction(
                      label: 'Rückgängig',
                      textColor: Colors.white,
                      onPressed: () {
                        // Buchung wiederherstellen
                        _bookingManager.restoreBooking(booking);
                        widget.onBookingDeleted?.call(); // UI aktualisieren
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Buchung wiederhergestellt'),
                            backgroundColor: Theme.of(context).primaryColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Fehler beim Löschen der Buchung'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(widget.isPast ? 'Entfernen' : 'Stornieren'),
          ),
        ],
      ),
    );
  }
}