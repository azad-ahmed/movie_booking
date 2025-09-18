class MovieDataService {
  static final MovieDataService _instance = MovieDataService._internal();
  factory MovieDataService() => _instance;
  MovieDataService._internal();

  static const List<Map<String, dynamic>> _movies = [
    {
      'id': 1,
      'title': 'Avatar: Der Weg des Wassers',
      'genre': 'Sci-Fi',
      'rating': 8.2,
      'duration': '192 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/94xxm5701CzOdJdUEdIuwqZaowx.jpg',
      'description': 'Jake Sully lebt mit seiner neuen Familie auf dem Planeten Pandora. Als eine vertraute Bedrohung zurückkehrt, um das zu beenden, was zuvor begonnen wurde, muss Jake mit Neytiri und der Armee der Na\'vi-Rasse zusammenarbeiten, um ihren Planeten zu schützen.',
      'isNew': true,
      'director': 'James Cameron',
      'cast': ['Sam Worthington', 'Zoe Saldana', 'Kate Winslet'],
      'trailerUrl': 'https://www.youtube.com/watch?v=a8Gx8wiNbs8',
    },
    {
      'id': 2,
      'title': 'Top Gun: Maverick',
      'genre': 'Action',
      'rating': 8.7,
      'duration': '130 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      'description': 'Nach mehr als 30 Jahren als einer der besten Piloten der Navy umgeht Pete "Maverick" Mitchell die Beförderung, die ihn aus dem Cockpit holen würde. Er führt eine Gruppe von Top Gun-Absolventen für eine spezielle Mission an.',
      'isNew': false,
      'director': 'Joseph Kosinski',
      'cast': ['Tom Cruise', 'Miles Teller', 'Jennifer Connelly'],
      'trailerUrl': 'https://www.youtube.com/watch?v=qSqVVswa420',
    },
    {
      'id': 3,
      'title': 'Black Panther: Wakanda Forever',
      'genre': 'Action',
      'rating': 7.3,
      'duration': '161 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
      'description': 'Die Wakandaner kämpfen darum, ihr Zuhause vor eingreifenden Weltmächten zu schützen, während sie den Tod von König T\'Challa betrauern. Während die Wakandaner sich bemühen, in ihr nächstes Kapitel zu gehen, müssen die Helden zusammenkommen.',
      'isNew': true,
      'director': 'Ryan Coogler',
      'cast': ['Letitia Wright', 'Angela Bassett', 'Tenoch Huerta'],
      'trailerUrl': 'https://www.youtube.com/watch?v=_Z3QKkl1WyM',
    },
    {
      'id': 4,
      'title': 'Spider-Man: No Way Home',
      'genre': 'Action',
      'rating': 8.4,
      'duration': '148 min',
      'year': 2021,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      'description': 'Peter Parker ist enttarnt und kann sein normales Leben nicht mehr von den hohen Einsätzen als Superheld trennen. Als er Doctor Strange um Hilfe bittet, wird der Einsatz noch gefährlicher und er wird dazu gedrängt zu entdecken, was es wirklich bedeutet, Spider-Man zu sein.',
      'isNew': false,
      'director': 'Jon Watts',
      'cast': ['Tom Holland', 'Tobey Maguire', 'Andrew Garfield'],
      'trailerUrl': 'https://www.youtube.com/watch?v=JfVOs4VSpmA',
    },
    {
      'id': 5,
      'title': 'The Batman',
      'genre': 'Action',
      'rating': 7.9,
      'duration': '176 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      'description': 'In seinem zweiten Jahr als Verbrechensbekämpfer verfolgt Batman ein Rätsel des Riddlers, das zur Korruption in Gotham City führt und seine Familie mit der Familie Wayne verbindet.',
      'isNew': true,
      'director': 'Matt Reeves',
      'cast': ['Robert Pattinson', 'Zoë Kravitz', 'Paul Dano'],
      'trailerUrl': 'https://www.youtube.com/watch?v=mqqft2x_Aa4',
    },
    {
      'id': 6,
      'title': 'Dune',
      'genre': 'Sci-Fi',
      'rating': 8.1,
      'duration': '155 min',
      'year': 2021,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
      'description': 'Paul Atreides begibt sich auf eine mythische Reise zu dem geheimnisvollsten Planeten des Universums, um die Zukunft seiner Familie und seines Volkes zu sichern. Ein Krieg bricht um eine exklusive Ressource aus.',
      'isNew': false,
      'director': 'Denis Villeneuve',
      'cast': ['Timothée Chalamet', 'Rebecca Ferguson', 'Oscar Isaac'],
      'trailerUrl': 'https://www.youtube.com/watch?v=n9xhJrPXop4',
    },
    {
      'id': 7,
      'title': 'Encanto',
      'genre': 'Animation',
      'rating': 7.3,
      'duration': '102 min',
      'year': 2021,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/4j0PNHkMr5ax3IA8tjtxcmPU3QT.jpg',
      'description': 'Eine magische Familie in Kolumbien lebt in einem verzauberten Haus in den Bergen. Jedes Kind der Familie wurde mit einer einzigartigen Gabe gesegnet, außer einem - Mirabel.',
      'isNew': false,
      'director': 'Jared Bush',
      'cast': ['Stephanie Beatriz', 'María Cecilia Botero', 'John Leguizamo'],
      'trailerUrl': 'https://www.youtube.com/watch?v=CaimKeDcudo',
    },
    {
      'id': 8,
      'title': 'Doctor Strange: Multiverse of Madness',
      'genre': 'Action',
      'rating': 7.0,
      'duration': '126 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      'description': 'Dr. Stephen Strange öffnet ein Portal zum Multiversum und konfrontiert eine mysteriöse neue Bedrohung. Er muss durch die verrückten und gefährlichen alternativen Realitäten des Multiversums navigieren.',
      'isNew': true,
      'director': 'Sam Raimi',
      'cast': ['Benedict Cumberbatch', 'Elizabeth Olsen', 'Xochitl Gomez'],
      'trailerUrl': 'https://www.youtube.com/watch?v=aWzlQ2N6qqg',
    },
    {
      'id': 9,
      'title': 'Jurassic World: Dominion',
      'genre': 'Action',
      'rating': 6.0,
      'duration': '147 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/kAVRgw7GgK1CfYEJq8ME6EvRIgU.jpg',
      'description': 'Vier Jahre nach der Zerstörung von Isla Nublar leben und jagen Dinosaurier nun neben Menschen auf der ganzen Welt. Diese fragile Balance wird die Zukunft neu gestalten und bestimmen, ob Menschen die Spitzenprädatoren bleiben.',
      'isNew': true,
      'director': 'Colin Trevorrow',
      'cast': ['Chris Pratt', 'Bryce Dallas Howard', 'Laura Dern'],
      'trailerUrl': 'https://www.youtube.com/watch?v=fb5ELWi-ekk',
    },
    {
      'id': 10,
      'title': 'Thor: Love and Thunder',
      'genre': 'Action',
      'rating': 6.8,
      'duration': '119 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/pIkRyD18kl4FhoCNQuWxWu5cBLM.jpg',
      'description': 'Thor begibt sich auf eine Reise, die er noch nie zuvor erlebt hat – eine Suche nach innerem Frieden. Aber seine Rente wird durch einen galaktischen Killer unterbrochen, der als Gorr der Götterschlächter bekannt ist.',
      'isNew': false,
      'director': 'Taika Waititi',
      'cast': ['Chris Hemsworth', 'Natalie Portman', 'Christian Bale'],
      'trailerUrl': 'https://www.youtube.com/watch?v=Go8nTmfrQd8',
    },
    {
      'id': 11,
      'title': 'Minions: Auf der Suche nach dem Mini-Boss',
      'genre': 'Animation',
      'rating': 6.7,
      'duration': '87 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/wKiOkZTN9lUUUNZLmtnwubZYONg.jpg',
      'description': 'In den 1970er Jahren wächst Gru in den Vororten auf und ist ein großer Fan einer Superschurkengruppe, die als Vicious 6 bekannt ist. Gru entwickelt einen Plan, böse genug zu werden, um ihnen beizutreten.',
      'isNew': true,
      'director': 'Kyle Balda',
      'cast': ['Steve Carell', 'Pierre Coffin', 'Alan Arkin'],
      'trailerUrl': 'https://www.youtube.com/watch?v=BUIr9UxdYTY',
    },
    {
      'id': 12,
      'title': 'Lightyear',
      'genre': 'Animation',
      'rating': 6.1,
      'duration': '105 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/ox4goZd956BxqJH6iLwhWPL9ct4.jpg',
      'description': 'Die Geschichte des legendären Space Rangers Buzz Lightyear und seiner Abenteuer zur Unendlichkeit und darüber hinaus. Eine Origin-Geschichte des Helden, der das Spielzeug inspirierte.',
      'isNew': false,
      'director': 'Angus MacLane',
      'cast': ['Chris Evans', 'Keke Palmer', 'Peter Sohn'],
      'trailerUrl': 'https://www.youtube.com/watch?v=BwZs3H_UN3k',
    },
    {
      'id': 13,
      'title': 'Sonic the Hedgehog 2',
      'genre': 'Komödie',
      'rating': 6.8,
      'duration': '122 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/6DrHO1jr3qVrViUO6s6kFiAGM7.jpg',
      'description': 'Nach seinem Abenteuer in Green Hills ist Sonic bereit für mehr Freiheit. Tom und Maddie stimmen zu, ihn alleine zu lassen, während sie in den Urlaub fahren. Aber Dr. Robotnik kehrt mit einem neuen Partner zurück.',
      'isNew': true,
      'director': 'Jeff Fowler',
      'cast': ['Ben Schwartz', 'James Marsden', 'Tika Sumpter'],
      'trailerUrl': 'https://www.youtube.com/watch?v=47r8FXYZWNU',
    },
    {
      'id': 14,
      'title': 'Morbius',
      'genre': 'Horror',
      'rating': 5.2,
      'duration': '104 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/6JjfSchsU6daXk2AKX8EEBjO3Fm.jpg',
      'description': 'Biochemiker Michael Morbius versucht, sich selbst von einer seltenen Blutkrankheit zu heilen, infiziert sich aber versehentlich mit einer Form von Vampirismus.',
      'isNew': false,
      'director': 'Daniel Espinosa',
      'cast': ['Jared Leto', 'Matt Smith', 'Adria Arjona'],
      'trailerUrl': 'https://www.youtube.com/watch?v=oZ6iiRrz1SY',
    },
    {
      'id': 15,
      'title': 'The Northman',
      'genre': 'Drama',
      'rating': 7.2,
      'duration': '137 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/zhLKlUaF1SEpO58ppHIAyENkwgw.jpg',
      'description': 'Ein junger Wikingerprinz unternimmt eine Rachequest, um den Mörder seines Vaters zu töten. Die Geschichte folgt seinem Weg von der Kindheit zur Männlichkeit.',
      'isNew': true,
      'director': 'Robert Eggers',
      'cast': ['Alexander Skarsgård', 'Nicole Kidman', 'Anya Taylor-Joy'],
      'trailerUrl': 'https://www.youtube.com/watch?v=oMSdFM12hOw',
    },
    {
      'id': 16,
      'title': 'Fantastic Beasts: Dumbledores Geheimnisse',
      'genre': 'Sci-Fi',
      'rating': 6.3,
      'duration': '142 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/8ZbybiGYe8XM4WGmGlhF0ec5R7u.jpg',
      'description': 'Professor Dumbledore weiß, dass der mächtige dunkle Zauberer Gellert Grindelwald die Kontrolle über die Zauberwelt übernehmen will. Da er ihn nicht allein aufhalten kann, beauftragt er den Magiozoologen Newt Scamander.',
      'isNew': false,
      'director': 'David Yates',
      'cast': ['Eddie Redmayne', 'Jude Law', 'Mads Mikkelsen'],
      'trailerUrl': 'https://www.youtube.com/watch?v=Y9dr2zw-TXQ',
    },
    {
      'id': 17,
      'title': 'Turning Red',
      'genre': 'Animation',
      'rating': 7.0,
      'duration': '100 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/qsdjk9oAKSQMWs0Vt5Pyfh6O4GZ.jpg',
      'description': 'Eine 13-jährige Meilin verwandelt sich in einen riesigen roten Panda, wenn sie zu aufgeregt wird. Sie muss lernen, mit dieser neuen Entwicklung umzugehen, während sie gleichzeitig ihre Mutter zufriedenstellt.',
      'isNew': true,
      'director': 'Domee Shi',
      'cast': ['Rosalie Chiang', 'Sandra Oh', 'Ava Morse'],
      'trailerUrl': 'https://www.youtube.com/watch?v=XdKzUbAiswE',
    },
    {
      'id': 18,
      'title': 'Uncharted',
      'genre': 'Action',
      'rating': 6.4,
      'duration': '116 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/rJHC1RUORuUhtfNb4Npclx0xnOf.jpg',
      'description': 'Nathan Drake wird von dem erfahrenen Schatzsucher Victor Sullivan rekrutiert, um ein Vermögen zu bergen, das Ferdinand Magellan vor 500 Jahren verloren hat. Was als Raub beginnt, wird zu einem Wettlauf um die Welt.',
      'isNew': false,
      'director': 'Ruben Fleischer',
      'cast': ['Tom Holland', 'Mark Wahlberg', 'Sophia Ali'],
      'trailerUrl': 'https://www.youtube.com/watch?v=eHp3MbsCbMg',
    },
    {
      'id': 19,
      'title': 'The Lost City',
      'genre': 'Komödie',
      'rating': 6.8,
      'duration': '112 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/neMZH82Stu91d3iqvLdNQfqPPyl.jpg',
      'description': 'Eine zurückgezogene Romanautorin wird auf eine Werbe-Tour für ihr neues Buch mit ihrem Cover-Model mitgenommen. Ein Entführungsversuch führt beide in ein wildes Dschungelabenteuer.',
      'isNew': true,
      'director': 'Aaron Nee',
      'cast': ['Sandra Bullock', 'Channing Tatum', 'Daniel Radcliffe'],
      'trailerUrl': 'https://www.youtube.com/watch?v=nfKO9rYDmE8',
    },
    {
      'id': 20,
      'title': 'Scream',
      'genre': 'Horror',
      'rating': 6.9,
      'duration': '114 min',
      'year': 2022,
      'imageUrl': 'https://image.tmdb.org/t/p/w500/1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg',
      'description': '25 Jahre nach einer Serie brutaler Morde schockt ein neuer Killer die Stadt Woodsboro. Eine neue Generation muss die Geheimnisse der Vergangenheit aufdecken, um am Leben zu bleiben.',
      'isNew': false,
      'director': 'Matt Bettinelli-Olpin',
      'cast': ['Neve Campbell', 'Courteney Cox', 'David Arquette'],
      'trailerUrl': 'https://www.youtube.com/watch?v=beToTslH17s',
    },
  ];

  List<Map<String, dynamic>> getAllMovies() {
    return List.from(_movies);
  }

  List<Map<String, dynamic>> getMoviesByGenre(String genre) {
    if (genre == 'Alle') return getAllMovies();
    return _movies.where((movie) => movie['genre'] == genre).toList();
  }

  List<Map<String, dynamic>> searchMovies(String query) {
    if (query.isEmpty) return getAllMovies();
    return _movies.where((movie) {
      return movie['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
             movie['genre'].toString().toLowerCase().contains(query.toLowerCase()) ||
             movie['director'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Map<String, dynamic>? getMovieById(int id) {
    try {
      return _movies.firstWhere((movie) => movie['id'] == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> getNewMovies() {
    return _movies.where((movie) => movie['isNew'] == true).toList();
  }

  List<Map<String, dynamic>> getTopRatedMovies() {
    var sortedMovies = List<Map<String, dynamic>>.from(_movies);
    sortedMovies.sort((a, b) => b['rating'].compareTo(a['rating']));
    return sortedMovies.take(10).toList();
  }

  List<String> getAllGenres() {
    var genres = <String>{'Alle'};
    for (var movie in _movies) {
      genres.add(movie['genre']);
    }
    return genres.toList();
  }

  List<Map<String, dynamic>> getRandomMovies(int count) {
    var shuffled = List<Map<String, dynamic>>.from(_movies);
    shuffled.shuffle();
    return shuffled.take(count).toList();
  }

  // Statistiken
  Map<String, dynamic> getMovieStatistics() {
    var genreCounts = <String, int>{};
    var totalRating = 0.0;
    var totalDuration = 0;

    for (var movie in _movies) {
      // Genre zählen
      String genre = movie['genre'];
      genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
      
      // Rating summieren
      totalRating += movie['rating'];
      
      // Dauer summieren (parse "XXX min" format)
      String duration = movie['duration'];
      int minutes = int.parse(duration.replaceAll(' min', ''));
      totalDuration += minutes;
    }

    return {
      'totalMovies': _movies.length,
      'averageRating': totalRating / _movies.length,
      'totalDuration': totalDuration,
      'averageDuration': totalDuration / _movies.length,
      'genreCounts': genreCounts,
      'newMoviesCount': _movies.where((m) => m['isNew']).length,
    };
  }
}