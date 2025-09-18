import 'package:flutter/material.dart';

class SeatSelection extends StatefulWidget {
  final Function(List<String>, double) onSeatsSelected;
  final List<String> selectedSeats;

  const SeatSelection({
    Key? key,
    required this.onSeatsSelected,
    required this.selectedSeats,
  }) : super(key: key);

  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<String> _selectedSeats = [];
  
  // Kino Layout: Reihen A-J, Plätze 1-12
  final int _rows = 10;
  final int _seatsPerRow = 12;
  final List<String> _rowLabels = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'];
  
  // Simulierte belegte Plätze
  final Set<String> _occupiedSeats = {
    'A3', 'A4', 'B7', 'B8', 'C2', 'C11', 'D5', 'D6', 'E9', 'F1', 'F12', 'G4', 'H8', 'I3', 'J7'
  };
  
  // Preise nach Kategorien
  final Map<String, double> _seatPrices = {
    'standard': 18.50,
    'premium': 24.00,
    'vip': 32.00,
  };

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
    
    _selectedSeats = List.from(widget.selectedSeats);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getSeatCategory(String seat) {
    final row = seat[0];
    if (['A', 'B', 'C'].contains(row)) return 'standard';
    if (['D', 'E', 'F', 'G'].contains(row)) return 'premium';
    return 'vip'; // H, I, J
  }

  double _getTotalPrice() {
    double total = 0;
    for (String seat in _selectedSeats) {
      final category = _getSeatCategory(seat);
      total += _seatPrices[category]!;
    }
    return total;
  }

  void _toggleSeat(String seatId) {
    if (_occupiedSeats.contains(seatId)) return;
    
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        if (_selectedSeats.length < 8) { // Max 8 Plätze
          _selectedSeats.add(seatId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Maximal 8 Plätze pro Buchung möglich'),
              backgroundColor: Colors.orange,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }
      
      widget.onSeatsSelected(_selectedSeats, _getTotalPrice());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'Wähle deine Plätze 🎭',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tippe auf die Plätze, um sie auszuwählen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Leinwand
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[300]!, Colors.grey[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_rounded, color: Colors.grey[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'LEINWAND',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.movie_rounded, color: Colors.grey[700], size: 20),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 30),
          
          // Sitzplan
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Sitzreihen
                  for (int rowIndex = 0; rowIndex < _rows; rowIndex++)
                    _buildSeatRow(rowIndex),
                  
                  SizedBox(height: 30),
                  
                  // Legende
                  _buildLegend(),
                  
                  SizedBox(height: 20),
                  
                  // Ausgewählte Plätze und Preis
                  if (_selectedSeats.isNotEmpty) _buildSelectedSeatsInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatRow(int rowIndex) {
    final rowLabel = _rowLabels[rowIndex];
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      child: Row(
        children: [
          // Reihen Label
          SizedBox(
            width: 30,
            child: Text(
              rowLabel,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          SizedBox(width: 10),
          
          // Sitzplätze
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Linke Sitzgruppe (1-5)
                for (int seatIndex = 1; seatIndex <= 5; seatIndex++)
                  _buildSeat('$rowLabel$seatIndex'),
                
                SizedBox(width: 20), // Gang
                
                // Rechte Sitzgruppe (6-12)
                for (int seatIndex = 6; seatIndex <= _seatsPerRow; seatIndex++)
                  _buildSeat('$rowLabel$seatIndex'),
              ],
            ),
          ),
          
          SizedBox(width: 10),
          
          // Preis Kategorie Indikator
          Container(
            width: 30,
            child: Text(
              '${_seatPrices[_getSeatCategory('$rowLabel 1')]!.toStringAsFixed(0)}.-',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getCategoryColor(_getSeatCategory('$rowLabel 1')),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeat(String seatId) {
    final isOccupied = _occupiedSeats.contains(seatId);
    final isSelected = _selectedSeats.contains(seatId);
    final category = _getSeatCategory(seatId);
    final categoryColor = _getCategoryColor(category);
    
    return GestureDetector(
      onTap: () => _toggleSeat(seatId),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 24,
        height: 24,
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isOccupied
              ? Colors.grey[400]
              : isSelected
                  ? Theme.of(context).primaryColor
                  : categoryColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : categoryColor.withOpacity(0.6),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: isOccupied
              ? Icon(Icons.close, size: 12, color: Colors.white)
              : isSelected
                  ? Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legende',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Verfügbar', Colors.green.withOpacity(0.3), Colors.green),
              _buildLegendItem('Ausgewählt', Theme.of(context).primaryColor, Theme.of(context).primaryColor),
              _buildLegendItem('Belegt', Colors.grey[400]!, Colors.grey[400]!),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPriceCategory('Standard', 'A-C', _seatPrices['standard']!, Colors.green),
              _buildPriceCategory('Premium', 'D-G', _seatPrices['premium']!, Colors.orange),
              _buildPriceCategory('VIP', 'H-J', _seatPrices['vip']!, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, Color borderColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPriceCategory(String name, String rows, double price, Color color) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'Reihen $rows',
          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
        ),
        Text(
          '${price.toStringAsFixed(2)} CHF',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedSeatsInfo() {
    final totalPrice = _getTotalPrice();
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ausgewählte Plätze:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
              Text(
                '${_selectedSeats.length}/8',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _selectedSeats.map((seat) {
              final category = _getSeatCategory(seat);
              final price = _seatPrices[category]!;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$seat (${price.toStringAsFixed(2)} CHF)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gesamtpreis:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(2)} CHF',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'standard':
        return Colors.green;
      case 'premium':
        return Colors.orange;
      case 'vip':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}