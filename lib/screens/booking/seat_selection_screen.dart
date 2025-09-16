import 'package:flutter/material.dart';

enum SeatCategory {
  standard,
  premium,
  vip,
}

class SeatInfo {
  final String id;
  final SeatCategory category;
  final bool isOccupied;

  SeatInfo({
    required this.id,
    required this.category,
    this.isOccupied = false,
  });

  double get price {
    switch (category) {
      case SeatCategory.standard:
        return 18.0; // CHF
      case SeatCategory.premium:
        return 25.0; // CHF
      case SeatCategory.vip:
        return 35.0; // CHF
    }
  }

  Color get categoryColor {
    switch (category) {
      case SeatCategory.standard:
        return Colors.grey[600]!;
      case SeatCategory.premium:
        return Colors.blue[600]!;
      case SeatCategory.vip:
        return Colors.purple[600]!;
    }
  }

  String get categoryName {
    switch (category) {
      case SeatCategory.standard:
        return 'Standard';
      case SeatCategory.premium:
        return 'Premium';
      case SeatCategory.vip:
        return 'VIP';
    }
  }
}

class SeatSelectionScreen extends StatefulWidget {
  final String movieTitle;
  final String cinema;
  final DateTime showtime;
  final Function(List<SeatInfo> selectedSeats, double totalPrice) onSeatsSelected;

  const SeatSelectionScreen({
    Key? key,
    required this.movieTitle,
    required this.cinema,
    required this.showtime,
    required this.onSeatsSelected,
  }) : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int rows = 10;
  final int seatsPerRow = 12;
  
  Map<String, SeatInfo> seats = {};
  Set<String> selectedSeatIds = {};
  
  // Simulierte bereits besetzte Plätze
  final Set<String> occupiedSeatIds = {
    'A3', 'A4', 'A9',
    'B1', 'B7', 'B8',
    'C5', 'C6',
    'D2', 'D10', 'D11',
    'E3', 'E9',
    'F1', 'F12',
    'G4', 'G5', 'G6',
    'H7', 'H8'
  };

  @override
  void initState() {
    super.initState();
    _initializeSeats();
  }

  void _initializeSeats() {
    for (int rowIndex = 0; rowIndex < rows; rowIndex++) {
      String rowLetter = String.fromCharCode(65 + rowIndex); // A, B, C, ...
      
      for (int seatIndex = 0; seatIndex < seatsPerRow; seatIndex++) {
        String seatId = '$rowLetter${seatIndex + 1}';
        
        // Bestimme Kategorie basierend auf Position
        SeatCategory category;
        if (rowIndex <= 2) {
          // Erste 3 Reihen: Premium (näher zur Leinwand)
          category = SeatCategory.premium;
        } else if (rowIndex >= 7) {
          // Letzte 3 Reihen: VIP (beste Sicht)
          category = SeatCategory.vip;
        } else {
          // Mittlere Reihen: Standard
          category = SeatCategory.standard;
        }
        
        // Mittlere Plätze in VIP-Reihen sind auch VIP
        if (rowIndex >= 7 && seatIndex >= 3 && seatIndex <= 8) {
          category = SeatCategory.vip;
        }
        
        seats[seatId] = SeatInfo(
          id: seatId,
          category: category,
          isOccupied: occupiedSeatIds.contains(seatId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Sitzplätze auswählen'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Movie info header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.movieTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.cinema,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${widget.showtime.day}.${widget.showtime.month}.${widget.showtime.year} ${widget.showtime.hour}:${widget.showtime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Screen indicator
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'LEINWAND',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          // Price legend
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPriceLegendItem(SeatCategory.standard),
                _buildPriceLegendItem(SeatCategory.premium),
                _buildPriceLegendItem(SeatCategory.vip),
              ],
            ),
          ),
          
          // Seat map
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: List.generate(rows, (rowIndex) {
                    String rowLetter = String.fromCharCode(65 + rowIndex);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          // Row label
                          Container(
                            width: 30,
                            child: Text(
                              rowLetter,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 10),
                          
                          // Seats
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(seatsPerRow, (seatIndex) {
                                String seatId = '$rowLetter${seatIndex + 1}';
                                SeatInfo seatInfo = seats[seatId]!;
                                bool isSelected = selectedSeatIds.contains(seatId);
                                
                                return GestureDetector(
                                  onTap: seatInfo.isOccupied ? null : () => _toggleSeat(seatId),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: _getSeatColor(seatInfo, isSelected),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isSelected ? Colors.white : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: seatInfo.isOccupied
                                        ? Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : isSelected
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                            : null,
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(width: 10),
                          
                          // Row label (right side)
                          Container(
                            width: 30,
                            child: Text(
                              rowLetter,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          
          // Legend for seat status
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusLegendItem(Colors.grey[700]!, 'Verfügbar'),
                _buildStatusLegendItem(Colors.green, 'Ausgewählt'),
                _buildStatusLegendItem(Colors.red, 'Besetzt'),
              ],
            ),
          ),
          
          // Bottom bar with selection info and confirm button
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                if (selectedSeatIds.isNotEmpty) ...[
                  // Selected seats breakdown
                  Column(
                    children: _buildSelectedSeatsBreakdown(),
                  ),
                  SizedBox(height: 15),
                  
                  // Total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gesamtpreis:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'CHF ${_calculateTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
                
                // Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedSeatIds.isEmpty ? null : _confirmSelection,
                    child: Text(
                      selectedSeatIds.isEmpty 
                          ? 'Plätze auswählen' 
                          : 'Buchung bestätigen (${selectedSeatIds.length} ${selectedSeatIds.length == 1 ? 'Platz' : 'Plätze'})',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedSeatIds.isEmpty ? Colors.grey : Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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

  Widget _buildPriceLegendItem(SeatCategory category) {
    SeatInfo dummySeat = SeatInfo(id: '', category: category);
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: dummySeat.categoryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 4),
        Text(
          dummySeat.categoryName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'CHF ${dummySeat.price.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSelectedSeatsBreakdown() {
    Map<SeatCategory, List<String>> categoryBreakdown = {};
    
    for (String seatId in selectedSeatIds) {
      SeatInfo seat = seats[seatId]!;
      if (!categoryBreakdown.containsKey(seat.category)) {
        categoryBreakdown[seat.category] = [];
      }
      categoryBreakdown[seat.category]!.add(seatId);
    }
    
    List<Widget> widgets = [];
    
    categoryBreakdown.forEach((category, seatIds) {
      SeatInfo dummySeat = SeatInfo(id: '', category: category);
      double categoryTotal = seatIds.length * dummySeat.price;
      
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${seatIds.length}x ${dummySeat.categoryName} (${seatIds.join(', ')})',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            Text(
              'CHF ${categoryTotal.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
    
    return widgets;
  }

  Color _getSeatColor(SeatInfo seatInfo, bool isSelected) {
    if (seatInfo.isOccupied) return Colors.red;
    if (isSelected) return Colors.green;
    return seatInfo.categoryColor;
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (String seatId in selectedSeatIds) {
      total += seats[seatId]!.price;
    }
    return total;
  }

  void _toggleSeat(String seatId) {
    setState(() {
      if (selectedSeatIds.contains(seatId)) {
        selectedSeatIds.remove(seatId);
      } else {
        selectedSeatIds.add(seatId);
      }
    });
  }

  void _confirmSelection() {
    List<SeatInfo> selectedSeats = selectedSeatIds
        .map((seatId) => seats[seatId]!)
        .toList();
    
    double totalPrice = _calculateTotalPrice();
    widget.onSeatsSelected(selectedSeats, totalPrice);
    Navigator.pop(context);
  }
}