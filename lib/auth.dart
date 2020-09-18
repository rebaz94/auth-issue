import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:meta/meta.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

enum AuthState {
  init,
  on_code_sent,
  loading,
  on_auto_retrieve_code,
  on_auth_success,
  on_email_auth_success,
  on_invalid_auth,
  on_timeout,
  on_phone_number_error,
  on_invalid_credential_error,
  on_to_many_request_error,
  on_api_not_available,
  on_error,
}

/// A class for managing Firebase authentication
class Auth {
  /// A wrapper class to manager Authentication of firebase user
  ///
  /// [currentLanguage] is required to set auth language response
  Auth({@required String currentLanguage}) {
    auth.setLanguageCode(currentLanguage ?? 'en');
  }

  // ignore: close_sinks
  /// A StreamController for managing authentications state
  StreamController<AuthState> _authState = StreamController.broadcast();
  String _verificationId;
  bool _onVerificationCalled = false;
  bool _isAuthSuccess = false;
  AuthCredential _authCredential;

  Stream<AuthState> get authState => _authState.stream.asBroadcastStream();

  /// Sign user with [AuthCredential]
  void _signWithAuthCredential(AuthCredential credential) {
    auth.signInWithCredential(credential).then((UserCredential value) {
      if (value.user != null) {
        _isAuthSuccess = true;
        _authState.add(AuthState.on_auth_success);
      } else {
        _authState.add(AuthState.on_invalid_auth);
      }
    }).catchError((e) {
      print(e);
      _authState.add(AuthState.on_error);
      _isAuthSuccess = false;
    });
  }

  Stream<User> get onFirebaseAuthStateChanged => auth.authStateChanges();

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      _authState.add(AuthState.loading);
      final res = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (res?.user != null)
        _authState.add(AuthState.on_email_auth_success);
      else
        _authState.add(AuthState.on_invalid_auth);
    } catch (e) {
      print(e);
      _authState.add(AuthState.on_error);
    }
  }
}