import 'package:flutter/material.dart';

class BookingSummary extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final VoidCallback onBookingConfirmed;

  const BookingSummary({
    Key? key,
    required this.bookingData,
    required this.onBookingConfirmed,
  }) : super(key: key);

  @override
  _BookingSummaryState createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String _selectedPaymentMethod = 'card';
  bool _acceptTerms = false;

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
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get canConfirmBooking => _acceptTerms;
  
  @override
  Widget build(BuildContext context) {
    // Debug Ausgabe
    print('BookingSummary - Buchungsdaten: ${widget.bookingData}');
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Buchung bestätigen 🎟️',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Überprüfe deine Angaben vor der Buchung',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: 25),
              
              // Buchungsdetails Card
              _buildBookingDetailsCard(),
              
              SizedBox(height: 20),
              
              // Zahlungsmethoden
              _buildPaymentMethodsCard(),
              
              SizedBox(height: 20),
              
              // Preisaufschlüsselung
              _buildPriceBreakdownCard(),
              
              SizedBox(height: 20),
              
              // AGB Checkbox
              _buildTermsCheckbox(),
              
              SizedBox(height: 100), // Platz für Navigation Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          
          SizedBox(height: 15),
          
          // Film
          _buildDetailRow(
            Icons.movie_rounded,
            'Film',
            widget.bookingData['movie']['title'] ?? 'Kein Film ausgewählt',
            Colors.blue,
          ),
          
          // Kino
          _buildDetailRow(
            Icons.location_on_rounded,
            'Kino',
            widget.bookingData['cinema']?['name'] ?? 'Kein Kino ausgewählt',
            Colors.green,
          ),
          
          // Datum & Zeit
          _buildDetailRow(
            Icons.calendar_today_rounded,
            'Datum',
            '${widget.bookingData['date'] ?? 'Kein Datum'} um ${widget.bookingData['time'] ?? 'Keine Zeit'}',
            Colors.orange,
          ),
          
          // Plätze
          _buildDetailRow(
            Icons.event_seat_rounded,
            'Plätze',
            _formatSeats(widget.bookingData['seats'] ?? []),
            Colors.purple,
          ),
          
          // Adresse
          if (widget.bookingData['cinema']?['address'] != null)
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.place_rounded,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.bookingData['cinema']['address'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsCard() {
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
            'Zahlungsmethode',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          
          SizedBox(height: 15),
          
          // Kreditkarte
          _buildPaymentOption(
            'card',
            Icons.credit_card_rounded,
            'Kreditkarte',
            'Visa, Mastercard, American Express',
            Colors.blue,
          ),
          
          SizedBox(height: 12),
          
          // PayPal
          _buildPaymentOption(
            'paypal',
            Icons.account_balance_wallet_rounded,
            'PayPal',
            'Zahle sicher mit deinem PayPal-Konto',
            Colors.orange,
          ),
          
          SizedBox(height: 12),
          
          // Twint
          _buildPaymentOption(
            'twint',
            Icons.phone_android_rounded,
            'TWINT',
            'Mobile Payment aus der Schweiz',
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, IconData icon, String title, String subtitle, Color color) {
    final isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            
            SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Radio Button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected 
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdownCard() {
    final seats = widget.bookingData['seats'] as List<String>? ?? [];
    final totalPrice = (widget.bookingData['totalPrice'] as double?) ?? 0.0;
    final serviceFeePro = totalPrice * 0.05; // 5% Servicegebühr
    final finalPrice = totalPrice + serviceFeePro;
    
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
            'Preisübersicht',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          
          SizedBox(height: 15),
          
          // Einzelne Plätze
          if (seats.isNotEmpty)
            for (String seat in seats)
              _buildPriceItem(
                'Platz $seat (${_getSeatCategoryName(seat)})',
                '${_getSeatPrice(seat).toStringAsFixed(2)} CHF',
                false,
              ),
          
          if (seats.isNotEmpty) Divider(height: 20),
          
          // Subtotal
          _buildPriceItem(
            'Zwischensumme',
            '${totalPrice.toStringAsFixed(2)} CHF',
            false,
          ),
          
          // Servicegebühr
          _buildPriceItem(
            'Servicegebühr (5%)',
            '${serviceFeePro.toStringAsFixed(2)} CHF',
            false,
          ),
          
          Divider(height: 20),
          
          // Gesamtsumme
          _buildPriceItem(
            'Gesamtsumme',
            '${finalPrice.toStringAsFixed(2)} CHF',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceItem(String label, String price, bool isTotal) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal 
                  ? Theme.of(context).textTheme.titleLarge?.color
                  : Colors.grey[700],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: isTotal ? 20 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal 
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: _acceptTerms,
              onChanged: (value) {
                setState(() {
                  _acceptTerms = value ?? false;
                });
              },
              activeColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ich akzeptiere die Allgemeinen Geschäftsbedingungen und bestätige, dass ich die Datenschutzbestimmungen gelesen habe.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('AGB werden geöffnet... 📋'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Text(
                          'AGB lesen',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Datenschutz wird geöffnet... 🔒'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Text(
                          'Datenschutz',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSeats(List<String> seats) {
    if (seats.isEmpty) return 'Keine Plätze ausgewählt';
    if (seats.length == 1) return seats.first;
    return '${seats.length} Plätze: ${seats.join(', ')}';
  }

  String _getSeatCategoryName(String seat) {
    final row = seat[0];
    if (['A', 'B', 'C'].contains(row)) return 'Standard';
    if (['D', 'E', 'F', 'G'].contains(row)) return 'Premium';
    return 'VIP';
  }

  double _getSeatPrice(String seat) {
    final row = seat[0];
    if (['A', 'B', 'C'].contains(row)) return 18.50;
    if (['D', 'E', 'F', 'G'].contains(row)) return 24.00;
    return 32.00;
  }
}