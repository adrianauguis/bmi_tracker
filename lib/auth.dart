import 'package:final_bmi/model/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }


  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String fullName,
      required String gender,
      required int age}) async {
      UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    Map<String,dynamic> userInfoMap = {
      "email": email,
      "fullName": fullName,
      "gender": gender,
      "age": age,
    };

    if(userCredential != null){
      Storage().addUserInfoToDB(_firebaseAuth.currentUser!.uid, userInfoMap);
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
