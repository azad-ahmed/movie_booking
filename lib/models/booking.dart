import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String? id;
  final String userId;
  final String movieTitle;
  final String cinema;
  final DateTime showtime;
  final int seats;
  final double totalPrice;
  final DateTime createdAt;

  Booking({
    this.id,
    required this.userId,
    required this.movieTitle,
    required this.cinema,
    required this.showtime,
    required this.seats,
    required this.totalPrice,
    required this.createdAt,
  });

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'movieTitle': movieTitle,
      'cinema': cinema,
      'showtime': Timestamp.fromDate(showtime),
      'seats': seats,
      'totalPrice': totalPrice,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      userId: data['userId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      cinema: data['cinema'] ?? '',
      showtime: (data['showtime'] as Timestamp).toDate(),
      seats: data['seats'] ?? 1,
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create a copy with updated values
  Booking copyWith({
    String? id,
    String? userId,
    String? movieTitle,
    String? cinema,
    DateTime? showtime,
    int? seats,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      movieTitle: movieTitle ?? this.movieTitle,
      cinema: cinema ?? this.cinema,
      showtime: showtime ?? this.showtime,
      seats: seats ?? this.seats,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}