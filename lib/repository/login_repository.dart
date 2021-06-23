import 'package:firebase_auth/firebase_auth.dart';
import 'package:translator/translator.dart';

class LoginRepository {
  ///tries to login using firebaseAuth.
  ///if there is an error returns the error code and if everything goes well returns null
  Future<String?> login(String email, String password) async {
    try {
      var credencial =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      var translateError = await GoogleTranslator().translate(e.message!, from: 'en', to: 'pt');
      return translateError.text;
    }
  }
}
