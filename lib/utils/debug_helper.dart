import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DebugHelper {
  static void checkFirebaseStatus() {
    try {
      // Firebase App Status
      final app = Firebase.app();
      print('✅ Firebase App Name: ${app.name}');
      print('✅ Firebase App Options: ${app.options.projectId}');

      // Auth Status
      final auth = FirebaseAuth.instance;
      print('✅ Firebase Auth initialized: ${auth.app.name}');
      print('✅ Current User: ${auth.currentUser?.email ?? 'None'}');
    } catch (e) {
      print('❌ Firebase Status Error: $e');
    }
  }

  static void logAuthError(dynamic error) {
    print('🔴 AUTH ERROR DETAILS:');
    print('Error Type: ${error.runtimeType}');
    print('Error Message: $error');

    if (error is FirebaseAuthException) {
      print('Firebase Error Code: ${error.code}');
      print('Firebase Error Message: ${error.message}');
    }
  }
}
