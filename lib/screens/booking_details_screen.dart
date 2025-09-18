import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/booking_manager.dart';
import '../screens/edit_booking_screen.dart';
import 'dart:math';

class BookingDetailsScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailsScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final BookingManager _bookingManager = BookingManager();
  Map<String, dynamic>? _booking;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _loadBookingDetails();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadBookingDetails() {
    setState(() {
      _booking = _bookingManager.getBookingById(widget.bookingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_booking == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Buchungsdetails'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'Buchung nicht gefunden',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Die gesuchte Buchung existiert nicht mehr.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  // App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text('Ticket Details'),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Colors.purple,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.local_activity,
                            size: 60,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: _shareTicket,
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () => _showMoreOptions(context),
                      ),
                    ],
                  ),

                  // Ticket Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Digitales Ticket
                          _buildDigitalTicket(),
                          
                          SizedBox(height: 30),
                          
                          // Buchungsdetails
                          _buildBookingDetails(),
                          
                          SizedBox(height: 20),
                          
                          // QR Code & Barcode
                          _buildQRCodeSection(),
                          
                          SizedBox(height: 20),
                          
                          // Kino Informationen
                          _buildCinemaInfo(),
                          
                          SizedBox(height: 20),
                          
                          // Buttons
                          _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDigitalTicket() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.purple[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIGITALES TICKET',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _booking!['movieTitle'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _booking!['isPast'] ? Colors.grey : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _booking!['isPast'] ? Icons.history : Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Ticket Info Grid
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildTicketInfo('KINO', _booking!['cinema'])),
                      Container(width: 1, height: 40, color: Colors.white30),
                      Expanded(child: _buildTicketInfo('DATUM', _booking!['date'])),
                    ],
                  ),
                  Divider(color: Colors.white30, height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildTicketInfo('ZEIT', _booking!['time'])),
                      Container(width: 1, height: 40, color: Colors.white30),
                      Expanded(child: _buildTicketInfo('PLÄTZE', '${_booking!['seats']} Plätze')),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 15),
            
            // Preis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gesamtpreis:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${_booking!['price'].toStringAsFixed(2)} CHF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBookingDetails() {
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
          Text(
            'Buchungsdetails',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          _buildDetailRow('Buchungs-ID', widget.bookingId),
          _buildDetailRow('Status', _booking!['isPast'] ? 'Vergangen' : 'Aktiv'),
          _buildDetailRow('Film', _booking!['movieTitle']),
          _buildDetailRow('Kino', _booking!['cinema']),
          _buildDetailRow('Adresse', _getCinemaAddress(_booking!['cinema'])),
          _buildDetailRow('Datum', _booking!['date']),
          _buildDetailRow('Uhrzeit', _booking!['time']),
          _buildDetailRow('Anzahl Plätze', '${_booking!['seats']} Plätze'),
          _buildDetailRow('Preis pro Platz', '${(_booking!['price'] / _booking!['seats']).toStringAsFixed(2)} CHF'),
          _buildDetailRow('Gesamtpreis', '${_booking!['price'].toStringAsFixed(2)} CHF', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: isTotal ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Theme.of(context).primaryColor : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeSection() {
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
        children: [
          Text(
            'Ticket QR-Code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          // QR Code Placeholder
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code, size: 60, color: Colors.grey[600]),
                  SizedBox(height: 8),
                  Text(
                    'QR-Code',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 10),
          Text(
            'Zeige diesen Code an der Kasse vor',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 15),
          
          // Booking Reference
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              'Ref: ${widget.bookingId.toUpperCase()}',
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaInfo() {
    final cinemaAddress = _getCinemaAddress(_booking!['cinema']);
    
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
              Icon(Icons.location_on, color: Theme.of(context).primaryColor),
              SizedBox(width: 10),
              Text(
                'Kino Informationen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          
          Text(
            _booking!['cinema'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            cinemaAddress,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          
          SizedBox(height: 15),
          
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openMaps,
                  icon: Icon(Icons.directions, size: 18),
                  label: Text('Route'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _callCinema,
                  icon: Icon(Icons.phone, size: 18),
                  label: Text('Anrufen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_booking!['isPast']) ...[
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _addToCalendar,
              icon: Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                'Zum Kalender hinzufügen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareTicket,
                icon: Icon(Icons.share),
                label: Text('Teilen'),
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
              child: ElevatedButton.icon(
                onPressed: _downloadTicket,
                icon: Icon(Icons.download, color: Colors.white),
                label: Text(
                  'Download',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
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

  String _getCinemaAddress(String cinemaName) {
    final addresses = {
      'CinemaX Basel': 'Steinenvorstadt 13, 4051 Basel',
      'Kino Rex': 'Klybeckstrasse 247, 4057 Basel',
      'Pathé Küchlin': 'Küchengasse 5, 4051 Basel',
      'Cinema Capitol': 'Centralbahnplatz 6, 4051 Basel',
      'Blue Cinema': 'Hardstrasse 301, 4058 Basel',
    };
    return addresses[cinemaName] ?? 'Basel, Schweiz';
  }

  void _shareTicket() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket wird geteilt... 📤'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToCalendar() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Termin wird zum Kalender hinzugefügt... 📅'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _downloadTicket() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket wird heruntergeladen... 💾'),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openMaps() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Karten-App wird geöffnet... 🗺️'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _callCinema() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kino wird angerufen... 📞'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
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
                    _buildOptionTile(
                      Icons.edit,
                      'Buchung bearbeiten',
                      'Details ändern',
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                        _editBooking();
                      },
                    ),
                    _buildOptionTile(
                      Icons.cancel,
                      'Buchung stornieren',
                      'Ticket stornieren',
                      Colors.red,
                      () {
                        Navigator.pop(context);
                        _cancelBooking();
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

  Widget _buildOptionTile(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _editBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBookingScreen(bookingId: widget.bookingId),
      ),
    ).then((result) {
      // Wenn Änderungen gespeichert wurden, lade die Daten neu
      if (result == true) {
        _loadBookingDetails();
      }
    });
  }

  void _cancelBooking() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buchung stornieren?'),
        content: Text('Möchtest du diese Buchung wirklich stornieren?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dialog schließen
              Navigator.pop(context); // Details schließen
              _bookingManager.removeBooking(widget.bookingId);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Buchung storniert ❌'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Stornieren'),
          ),
        ],
      ),
    );
  }
}