class Movie {
  final String title;
  final String description;
  final String imageUrl;
  final String genre;
  final int duration; // Minuten
  final double rating; // 1.0 - 5.0
  final String director;
  final List<String> cast;

  Movie({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.director,
    required this.cast,
  });

  String get durationText {
    int hours = duration ~/ 60;
    int minutes = duration % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else {
      return '${minutes}min';
    }
  }
}

// Statische Film-Daten
class MovieData {
  static final List<Movie> popularMovies = [
    Movie(
      title: 'Avatar 3',
      description: 'Jake Sully lebt mit seiner neuen Familie auf dem Planeten Pandora. Als eine vertraute Bedrohung zurückkehrt, muss Jake mit Neytiri und der Armee der Na\'vi-Rasse kämpfen, um ihren Heimatplaneten zu schützen.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      genre: 'Sci-Fi, Action',
      duration: 192,
      rating: 4.2,
      director: 'James Cameron',
      cast: ['Sam Worthington', 'Zoe Saldana', 'Sigourney Weaver'],
    ),
    Movie(
      title: 'Spider-Man: Beyond',
      description: 'Peter Parker steht vor seiner bisher größten Herausforderung. Mit neuen Kräften und einem multiveralen Abenteuer muss er das Schicksal aller Spider-Menschen retten.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      genre: 'Action, Abenteuer',
      duration: 140,
      rating: 4.5,
      director: 'Jon Watts',
      cast: ['Tom Holland', 'Zendaya', 'Benedict Cumberbatch'],
    ),
    Movie(
      title: 'The Batman 2',
      description: 'Bruce Wayne kehrt zurück als Gothams dunkler Ritter. Mit neuen Feinden und einer noch dunkleren Geschichte erforscht Batman die Abgründe seiner Stadt.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      genre: 'Action, Krimi',
      duration: 155,
      rating: 4.3,
      director: 'Matt Reeves',
      cast: ['Robert Pattinson', 'Zoë Kravitz', 'Paul Dano'],
    ),
    Movie(
      title: 'Fast & Furious 11',
      description: 'Die Familie ist zurück für ein letztes Abenteuer. Dom und sein Team müssen sich der ultimativen Bedrohung stellen, die alles in Frage stellt, wofür sie gekämpft haben.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/fiVW06jE7z9YnO4trhaMEdclSiC.jpg',
      genre: 'Action, Thriller',
      duration: 125,
      rating: 3.8,
      director: 'Louis Leterrier',
      cast: ['Vin Diesel', 'Michelle Rodriguez', 'Jason Statham'],
    ),
    Movie(
      title: 'John Wick 5',
      description: 'John Wick kämpft um sein Leben und seine Freiheit. In seinem bisher persönlichsten und brutalsten Abenteuer muss er sich seiner Vergangenheit stellen.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg',
      genre: 'Action, Thriller',
      duration: 139,
      rating: 4.4,
      director: 'Chad Stahelski',
      cast: ['Keanu Reeves', 'Laurence Fishburne', 'Ian McShane'],
    ),
    Movie(
      title: 'Mission Impossible 8',
      description: 'Ethan Hunt steht vor seiner unmöglichsten Mission. Mit der Welt am Rande des Abgrunds muss das IMF-Team alles riskieren, um die Menschheit zu retten.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/NNxYkU70HPurnNCSiCjYAmacwm.jpg',
      genre: 'Action, Thriller',
      duration: 163,
      rating: 4.1,
      director: 'Christopher McQuarrie',
      cast: ['Tom Cruise', 'Rebecca Ferguson', 'Simon Pegg'],
    ),
    Movie(
      title: 'Top Gun 3',
      description: 'Maverick kehrt für eine neue Generation von Piloten zurück. Neue Technologie und alte Rivalitäten kollidieren in den Himmel über dem Pazifik.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      genre: 'Action, Drama',
      duration: 131,
      rating: 4.6,
      director: 'Joseph Kosinski',
      cast: ['Tom Cruise', 'Miles Teller', 'Jennifer Connelly'],
    ),
    Movie(
      title: 'Guardians of the Galaxy 4',
      description: 'Die Guardians begeben sich auf ihre letzte Mission zusammen. Mit dem Schicksal der Galaxis in der Schwebe müssen sie lernen, dass manche Familien für immer sind.',
      imageUrl: 'https://image.tmdb.org/t/p/w500/5YZbUmjbMa3ClvSW1Wj3Zbm7kbv.jpg',
      genre: 'Sci-Fi, Abenteuer',
      duration: 150,
      rating: 4.0,
      director: 'James Gunn',
      cast: ['Chris Pratt', 'Zoe Saldana', 'Dave Bautista'],
    ),
  ];

  static Movie? getMovieByTitle(String title) {
    try {
      return popularMovies.firstWhere((movie) => movie.title == title);
    } catch (e) {
      return null;
    }
  }
}