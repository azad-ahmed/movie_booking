import 'package:flutter/material.dart';
import '../widgets/booking_card.dart';
import '../widgets/quick_actions_widget.dart';
import '../widgets/stats_widget.dart';
import '../services/booking_manager.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToMovies;

  const HomeScreen({Key? key, this.onNavigateToMovies}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final BookingManager _bookingManager = BookingManager();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));
    
    // Starte die Animationen nacheinander
    _fadeController.forward();
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });
    
    // Aktualisiere vergangene Buchungen
    _bookingManager.updatePastBookings();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.purple.withOpacity(0.05),
              Colors.blue.withOpacity(0.1),
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
                  // Kreativer App Bar
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Willkommen zurück! 👋',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.titleLarge?.color,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Deine Kinowelt wartet auf dich',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                // Benachrichtigungen Button
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.notifications_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () {
                                      // Benachrichtigungen anzeigen
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Keine neuen Benachrichtigungen 📱'),
                                          backgroundColor: Theme.of(context).primaryColor,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Schnellaktionen
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: QuickActionsWidget(onNavigateToMovies: widget.onNavigateToMovies),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // Statistiken
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: StatsWidget(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 30)),

                  // Deine Buchungen Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deine Buchungen 🎬',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.titleLarge?.color,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Alle Buchungen anzeigen
                            },
                            child: Text(
                              'Alle anzeigen',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 15)),

                  // Buchungen Liste
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bookings = _bookingManager.bookings;
                        if (index >= bookings.length) return null;
                        
                        final booking = bookings[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: BookingCard(
                            bookingId: booking['id'],
                            movieTitle: booking['movieTitle'],
                            cinema: booking['cinema'],
                            date: booking['date'],
                            time: booking['time'],
                            seats: booking['seats'],
                            price: booking['price'],
                            isPast: booking['isPast'],
                            animationDelay: Duration(milliseconds: 100 * index),
                            onBookingDeleted: () {
                              setState(() {}); // Refresh the list
                            },
                          ),
                        );
                      },
                      childCount: _bookingManager.bookings.length,
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 100)), // Platz für Bottom Nav
                ],
              ),
            ),
          ),
        ),
      ),
      
      // Floating Action Button für neue Buchung
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Colors.purple,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate zum Movies Tab
            if (widget.onNavigateToMovies != null) {
              widget.onNavigateToMovies!();
              
              // Zusätzlicher Hinweis
              Future.delayed(Duration(milliseconds: 500), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Wähle einen Film zum Buchen aus! 🎬'),
                    backgroundColor: Theme.of(context).primaryColor,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          label: Text(
            'Neuer Film',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          icon: Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Beispieldaten für die Buchungen
  String _getMovieTitle(int index) {
    final movies = [
      'Avatar: Der Weg des Wassers',
      'Top Gun: Maverick',
      'Spider-Man: No Way Home',
      'The Batman',
      'Doctor Strange 2',
      'Jurassic World Dominion',
    ];
    return movies[index % movies.length];
  }

  String _getCinemaName(int index) {
    final cinemas = [
      'CinemaX Basel',
      'Kino Rex',
      'Pathé Küchlin',
      'Cinema Capitol',
      'Blue Cinema',
      'Kinepolis',
    ];
    return cinemas[index % cinemas.length];
  }

  String _getBookingDate(int index) {
    final dates = [
      '20.09.2025',
      '18.09.2025',
      '15.09.2025',
      '10.09.2025',
      '08.09.2025',
      '05.09.2025',
    ];
    return dates[index % dates.length];
  }

  String _getBookingTime(int index) {
    final times = [
      '20:30',
      '18:15',
      '21:00',
      '19:45',
      '17:30',
      '20:00',
    ];
    return times[index % times.length];
  }

  int _getSeatsCount(int index) {
    return (index % 4) + 1;
  }

  double _getPrice(int index) {
    final prices = [24.50, 19.80, 32.00, 21.20, 18.90, 26.40];
    return prices[index % prices.length];
  }
}