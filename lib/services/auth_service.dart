import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobscan/services/auth_service.dart';
import 'package:mobscan/screens/auth/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;


  static const String adminEmail = 'team.mobScan14@gmail.com';

  bool _isInitialized = false;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  bool get isAdmin => currentUser?.email == adminEmail;


  Future<void> initialize() async {
    if (_isInitialized) return;
    await _googleSignIn.initialize();
    _isInitialized = true;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await initialize();

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();


      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    }on GoogleSignInException catch (e) {
      print("Google Sign-In Error");
      print("Code: ${e.code}");
      print("Message: ${e.description}");

      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }

      rethrow;
    }
  }

    Future<void> signOut() async {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }
  }