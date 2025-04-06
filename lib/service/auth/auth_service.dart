import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:masal/core/extension/locazition_extension.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerWithEmailAndPassword(BuildContext context, String email, String password) async {
    if (!context.mounted) return null;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw _handleFirebaseAuthException(context, e, isRegistration: true);
    } catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw Exception(context.localizations.genericError(e.toString()));
    }
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    if (!context.mounted) return null;
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw _handleFirebaseAuthException(context, e, isRegistration: false);
    } catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw Exception(context.localizations.genericError(e.toString()));
    }
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    if (!context.mounted) return;
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw _handleFirebaseAuthException(context, e, isReset: true);
    } catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw Exception(context.localizations.genericError(e.toString()));
    }
  }

  Future<void> deleteAccount(BuildContext context, String email, String password) async {
    if (!context.mounted) return;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      await credential.user!.delete();
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw _handleFirebaseAuthException(context, e, isDelete: true);
    } catch (e) {
      if (!context.mounted) throw Exception('Context not mounted');
      throw Exception(context.localizations.genericError(e.toString()));
    }
  }

  Exception _handleFirebaseAuthException(BuildContext context, FirebaseAuthException e,
      {bool isRegistration = false, bool isReset = false, bool isDelete = false}) {
    if (!context.mounted) return Exception('Context not mounted');
    
    String baseMessage = e.message ?? 'Bilinmeyen bir hata oluştu';
    
    switch (e.code) {
      case 'email-already-in-use':
        return Exception(context.localizations.emailAlreadyInUse);
      case 'invalid-email':
        return Exception(context.localizations.invalidEmail);
      case 'weak-password':
        return Exception(context.localizations.weakPassword);
      case 'operation-not-allowed':
        return Exception(context.localizations.operationNotAllowed);
      case 'user-not-found':
        return Exception(context.localizations.userNotFound);
      case 'wrong-password':
        return Exception(context.localizations.wrongPassword);
      case 'user-disabled':
        return Exception(context.localizations.userDisabled);
      case 'too-many-requests':
        return Exception(context.localizations.tooManyRequests);
      case 'network-request-failed':
        return Exception(context.localizations.networkRequestFailed);
      case 'invalid-credential':
        return Exception(context.localizations.invalidCredential);
      case 'timeout':
        return Exception(context.localizations.timeout);
      case 'requires-recent-login':
        return Exception(context.localizations.requiresRecentLogin);
      default:
        return Exception(context.localizations.genericError(baseMessage));
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Çıkış sırasında bir hata oluştu: $e');
    }
  }

  User? get currentUser => _auth.currentUser;
}