import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      print("========== GOOGLE SIGN IN ==========");

      await initialize();

      print("Google Sign In Initialized");

      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      print("User Email: ${googleUser.email}");
      print("User Name : ${googleUser.displayName}");

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      print("ID Token : ${googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);

      print("Firebase Login Success");
      print("UID : ${userCredential.user?.uid}");
      print("Email : ${userCredential.user?.email}");

      return userCredential;
    } on GoogleSignInException catch (e, s) {
      print("========== GoogleSignInException ==========");
      print("Code : ${e.code}");
      print("Description : ${e.description}");
      print(e);
      print(s);

      if (e.code == GoogleSignInExceptionCode.canceled) {
        print("User cancelled login");
        return null;
      }

      rethrow;
    } on FirebaseAuthException catch (e, s) {
      print("========== FirebaseAuthException ==========");
      print("Code : ${e.code}");
      print("Message : ${e.message}");
      print(e);
      print(s);
      rethrow;
    } catch (e, s) {
      print("========== UNKNOWN ERROR ==========");
      print(e);
      print(s);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}