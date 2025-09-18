import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chips.dart';
import '../services/movie_data_service.dart';
import 'booking_screen.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  final MovieDataService _movieService = MovieDataService();
  String _selectedCategory = 'Alle';
  String _searchQuery = '';
  
  List<String> _categories = [];
  List<Map<String, dynamic>> _allMovies = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    // Lade echte Daten
    _loadMovieData();
    _controller.forward();
  }

  void _loadMovieData() {
    setState(() {
      _categories = _movieService.getAllGenres();
      _allMovies = _movieService.getAllMovies();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMovies {
    var movies = _allMovies;
    
    // Nach Kategorie filtern
    if (_selectedCategory != 'Alle') {
      movies = movies.where((movie) => movie['genre'] == _selectedCategory).toList();
    }
    
    // Nach Suche filtern
    if (_searchQuery.isNotEmpty) {
      movies = movies.where((movie) {
        return movie['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               movie['genre'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               movie['director'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.orange.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: CustomScrollView(
                slivers: [
                  // Header mit Suchleiste
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titel
                          Row(
                            children: [
                              Icon(
                                Icons.movie_rounded,
                                size: 32,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Filme entdecken',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.titleLarge?.color,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Suchleiste
                          SearchBarWidget(
                            onSearchChanged: (query) {
                              setState(() {
                                _searchQuery = query;
                              });
                            },
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Kategorie Chips
                          CategoryChips(
                            categories: _categories,
                            selectedCategory: _selectedCategory,
                            onCategorySelected: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Filme Grid
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 20,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= _filteredMovies.length) return null;
                          
                          final movie = _filteredMovies[index];
                          return MovieCard(
                            movie: movie,
                            animationDelay: Duration(milliseconds: 100 * index),
                            onTap: () => _showMovieDetails(movie),
                          );
                        },
                      ),
                    ),
                  ),

                  // Leer-State wenn keine Filme gefunden
                  if (_filteredMovies.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_outlined,
                              size: 80,
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.3),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Keine Filme gefunden 🎭',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Versuche es mit anderen Suchbegriffen',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMovieDetails(Map<String, dynamic> movie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MovieDetailsSheet(movie: movie),
    );
  }
}

// Movie Details Bottom Sheet
class MovieDetailsSheet extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsSheet({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Film Poster
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: movie['imageUrl'] != null
                          ? Image.network(
                              movie['imageUrl'],
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Colors.purple,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(color: Colors.white),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Colors.purple,
                                      ],
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.movie_rounded,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          movie['title'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Colors.purple,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.movie_rounded,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      movie['title'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Titel
                  Text(
                    movie['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Film Info Chips
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip('${movie['year']}', Icons.calendar_today),
                      _buildInfoChip(movie['genre'], Icons.category),
                      _buildInfoChip('⭐ ${movie['rating']}', Icons.star),
                      _buildInfoChip(movie['duration'], Icons.access_time),
                      if (movie['isNew'])
                        _buildInfoChip('NEU', Icons.fiber_new, isNew: true),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Regie & Cast
                  if (movie['director'] != null) ...[
                    Text(
                      'Regie',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      movie['director'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                  
                  if (movie['cast'] != null && movie['cast'].isNotEmpty) ...[
                    Text(
                      'Darsteller',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      (movie['cast'] as List).join(', '),
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                  
                  SizedBox(height: 20),
                  
                  // Beschreibung
                  Text(
                    'Beschreibung',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    movie['description'],
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Buchen Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingFlowScreen(movie: movie),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_activity, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Jetzt buchen',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, {bool isNew = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isNew ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: isNew ? Border.all(color: Colors.red.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isNew ? Colors.red : Colors.grey[600],
          ),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isNew ? Colors.red : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}