import 'package:flutter/material.dart';

class CinemaSelection extends StatefulWidget {
  final Function(Map<String, dynamic>) onCinemaSelected;
  final Map<String, dynamic>? selectedCinema;

  const CinemaSelection({
    Key? key,
    required this.onCinemaSelected,
    this.selectedCinema,
  }) : super(key: key);

  @override
  _CinemaSelectionState createState() => _CinemaSelectionState();
}

class _CinemaSelectionState extends State<CinemaSelection> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> _cinemas = [
    {
      'id': 1,
      'name': 'CinemaX Basel',
      'address': 'Steinenvorstadt 13, 4051 Basel',
      'distance': '0.8 km',
      'rating': 4.5,
      'features': ['IMAX', 'Dolby Atmos', 'Snack Bar'],
      'image': 'cinema1',
    },
    {
      'id': 2,
      'name': 'Kino Rex',
      'address': 'Klybeckstrasse 247, 4057 Basel',
      'distance': '1.2 km',
      'rating': 4.3,
      'features': ['Premium Sessel', '3D', 'Parkplätze'],
      'image': 'cinema2',
    },
    {
      'id': 3,
      'name': 'Pathé Küchlin',
      'address': 'Küchengasse 5, 4051 Basel',
      'distance': '0.5 km',
      'rating': 4.7,
      'features': ['Laser Projektion', 'Recliner Seats', 'VIP Lounge'],
      'image': 'cinema3',
    },
    {
      'id': 4,
      'name': 'Cinema Capitol',
      'address': 'Centralbahnplatz 6, 4051 Basel',
      'distance': '2.1 km',
      'rating': 4.2,
      'features': ['Klassik Kino', 'Bar', 'Historisch'],
      'image': 'cinema4',
    },
    {
      'id': 5,
      'name': 'Blue Cinema',
      'address': 'Hardstrasse 301, 4058 Basel',
      'distance': '3.2 km',
      'rating': 4.4,
      'features': ['Multiplex', 'Food Court', 'Gaming Zone'],
      'image': 'cinema5',
    },
  ];

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Wähle ein Kino 🎭',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Kinos in deiner Nähe in Basel',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Kino Liste
            Expanded(
              child: ListView.builder(
                itemCount: _cinemas.length,
                itemBuilder: (context, index) {
                  final cinema = _cinemas[index];
                  final isSelected = widget.selectedCinema?['id'] == cinema['id'];
                  
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        widget.onCinemaSelected(cinema);
                        // Haptic Feedback
                        _animationController.reset();
                        _animationController.forward();
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: isSelected 
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected 
                                  ? Theme.of(context).primaryColor.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.05),
                              blurRadius: isSelected ? 15 : 5,
                              offset: Offset(0, isSelected ? 5 : 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Kino "Bild" (Placeholder)
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _getCinemaColors(index),
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.local_movies_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            
                            SizedBox(width: 16),
                            
                            // Kino Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name und Rating
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          cinema['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected 
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context).textTheme.titleMedium?.color,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.star, color: Colors.orange, size: 14),
                                            SizedBox(width: 2),
                                            Text(
                                              cinema['rating'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 6),
                                  
                                  // Adresse
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
                                          cinema['address'],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 6),
                                  
                                  // Entfernung
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.directions_walk_rounded,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        cinema['distance'],
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  SizedBox(height: 8),
                                  
                                  // Features
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: (cinema['features'] as List<String>).take(3).map((feature) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          feature,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Selection Indicator
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected 
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.withOpacity(0.3),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCinemaColors(int index) {
    final colors = [
      [Colors.blue, Colors.purple],
      [Colors.red, Colors.orange],
      [Colors.green, Colors.teal],
      [Colors.purple, Colors.pink],
      [Colors.orange, Colors.red],
    ];
    return colors[index % colors.length];
  }
}