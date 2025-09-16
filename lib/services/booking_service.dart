import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user bookings stream
  Stream<List<Booking>> getUserBookings(String userId) {
    print('Getting bookings for user: $userId'); // Debug

    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        // TEMPORÄR: orderBy entfernt um Index-Problem zu umgehen
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      print(
          'Firestore snapshot received: ${snapshot.docs.length} documents'); // Debug

      // Sortierung im Code statt in Firestore
      final bookings = snapshot.docs
          .map((doc) {
            try {
              return Booking.fromFirestore(doc);
            } catch (e) {
              print('Error parsing booking document ${doc.id}: $e'); // Debug
              return null;
            }
          })
          .where((booking) => booking != null)
          .cast<Booking>()
          .toList();

      // Manuell sortieren nach createdAt (neueste zuerst)
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return bookings;
    });
  }

  // Create new booking
  Future<void> createBooking(Booking booking) async {
    try {
      print('Creating booking: ${booking.movieTitle}'); // Debug
      await _firestore.collection('bookings').add(booking.toMap());
      print('Booking created successfully'); // Debug
    } catch (e) {
      print('Error creating booking: $e');
      throw e;
    }
  }

  // Delete booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      print('Deleting booking: $bookingId'); // Debug
      await _firestore.collection('bookings').doc(bookingId).delete();
      print('Booking deleted successfully'); // Debug
    } catch (e) {
      print('Error deleting booking: $e');
      throw e;
    }
  }

  // Update booking
  Future<void> updateBooking(String bookingId, Booking booking) async {
    try {
      print('Updating booking: $bookingId'); // Debug
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update(booking.toMap());
      print('Booking updated successfully'); // Debug
    } catch (e) {
      print('Error updating booking: $e');
      throw e;
    }
  }

  // Test Firestore connection
  Future<void> testConnection() async {
    try {
      print('Testing Firestore connection...');
      await _firestore.collection('test').doc('test').set({'test': true});
      await _firestore.collection('test').doc('test').delete();
      print('Firestore connection successful!');
    } catch (e) {
      print('Firestore connection failed: $e');
      throw e;
    }
  }
}
