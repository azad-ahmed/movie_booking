class Cinema {
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final String city;
  final String phone;
  final List<String> amenities;
  final double rating;
  final int screens;
  final bool hasIMAX;
  final bool has3D;
  final bool hasVIP;

  Cinema({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.city,
    required this.phone,
    required this.amenities,
    required this.rating,
    required this.screens,
    required this.hasIMAX,
    required this.has3D,
    required this.hasVIP,
  });

  String get fullAddress => '$address, $city';
  
  List<String> get specialFeatures {
    List<String> features = [];
    if (hasIMAX) features.add('IMAX');
    if (has3D) features.add('3D');
    if (hasVIP) features.add('VIP');
    return features;
  }
}

// Statische Kino-Daten für Basel und Umgebung
class CinemaData {
  static final List<Cinema> popularCinemas = [
    Cinema(
      name: 'CineStar Basel',
      description: 'Modernes Multiplex-Kino im Herzen von Basel mit den neuesten Blockbustern und komfortablen Sitzen. Perfekte Bild- und Tonqualität für ein unvergessliches Kinoerlebnis.',
      imageUrl: 'https://images.unsplash.com/photo-1489599735927-85b996b50882?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Steinenvorstadt 24',
      city: 'Basel',
      phone: '+41 61 123 45 67',
      amenities: ['Snackbar', 'Online-Buchung', 'Klimaanlage', 'Rollstuhlgerecht'],
      rating: 4.2,
      screens: 12,
      hasIMAX: true,
      has3D: true,
      hasVIP: false,
    ),
    Cinema(
      name: 'Pathé Küchlin',
      description: 'Traditionelles Kino mit Charme und Geschichte. Bietet eine gemütliche Atmosphäre für Filmliebhaber und zeigt sowohl Mainstream- als auch Arthouse-Filme.',
      imageUrl: 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Küchlinstr. 6',
      city: 'Basel',
      phone: '+41 61 234 56 78',
      amenities: ['Café', 'Arthouse-Filme', 'Studentenrabatt', 'Bar'],
      rating: 4.4,
      screens: 8,
      hasIMAX: false,
      has3D: true,
      hasVIP: true,
    ),
    Cinema(
      name: 'Rex Kino',
      description: 'Familiäres Programmkino mit sorgfältig ausgewählten Filmen. Bekannt für seine entspannte Atmosphäre und persönlichen Service. Ein Geheimtipp für Cineasten.',
      imageUrl: 'https://images.unsplash.com/photo-1616530940355-351fabd9524b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Klybeckstrasse 42',
      city: 'Basel',
      phone: '+41 61 345 67 89',
      amenities: ['Programmkino', 'Persönlicher Service', 'Gemütlich', 'Dokumentarfilme'],
      rating: 4.6,
      screens: 3,
      hasIMAX: false,
      has3D: false,
      hasVIP: false,
    ),
    Cinema(
      name: 'Cineplex Liestal',
      description: 'Großes Multiplex-Kino mit modernster Technik und breitem Filmangebot. Ideal für Familien und Gruppen mit vielen Vorstellungszeiten und komfortablen Sitzen.',
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Kasernenstrasse 23',
      city: 'Liestal',
      phone: '+41 61 456 78 90',
      amenities: ['Familienfreundlich', 'Großer Parkplatz', 'Restaurant', 'Popcorn-Bar'],
      rating: 4.0,
      screens: 10,
      hasIMAX: true,
      has3D: true,
      hasVIP: true,
    ),
    Cinema(
      name: 'Scala Kino',
      description: 'Boutique-Kino mit exklusiver Auswahl und erstklassigem Service. Bietet ein Premium-Erlebnis mit hochwertigen Sitzen und ausgewählten Filmen.',
      imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Freie Strasse 81',
      city: 'Basel',
      phone: '+41 61 567 89 01',
      amenities: ['Premium-Service', 'Luxus-Sitze', 'Champagner-Bar', 'Exklusive Filme'],
      rating: 4.7,
      screens: 5,
      hasIMAX: false,
      has3D: true,
      hasVIP: true,
    ),
    Cinema(
      name: 'Camera Kino',
      description: 'Alternatives Kino für Independent- und Dokumentarfilme. Ein kultureller Treffpunkt für Menschen, die das besondere Kinoerlebnis schätzen.',
      imageUrl: 'https://images.unsplash.com/photo-1626814026160-2237a95fc5a0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
      address: 'Rebgasse 1',
      city: 'Basel',
      phone: '+41 61 678 90 12',
      amenities: ['Independent-Filme', 'Kulturell', 'Diskussionsrunden', 'Filmmaker-Events'],
      rating: 4.5,
      screens: 4,
      hasIMAX: false,
      has3D: false,
      hasVIP: false,
    ),
  ];

  static Cinema? getCinemaByName(String name) {
    try {
      return popularCinemas.firstWhere((cinema) => cinema.name == name);
    } catch (e) {
      return null;
    }
  }
}