import 'package:firebase_auth/firebase_auth.dart';
import 'action_code_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alias_engine.dart';
import 'slur_filter.dart';

class AuthService {
	final FirebaseAuth _auth = FirebaseAuth.instance;

	// Get current user
	User? get currentUser => _auth.currentUser;

	// Get current user's display name (username)
	String? get username => currentUser?.displayName;

	// Get current user's UID
	String? get uid => currentUser?.uid;

	// Ensure user is signed in (anonymous if needed)
	// Future<User?> ensureSignedIn() async {
	// 	var user = _auth.currentUser;
	// 	user ??= (await _auth.signInAnonymously()).user;
	// 	return user;
	// }

	// Sign in with username (sets displayName, signs in anonymously if needed)
	Future<String?> signInWithUsername(String username) async {
		if (SlurFilter.containsSlur(username)) {
			return "Don't be a dick.";
		}
		try {
			User? user = _auth.currentUser;
			user ??= (await _auth.signInAnonymously()).user;
			if (user == null) {
				return 'Unable to sign in.';
			}
			await user.updateDisplayName(username);
			await user.reload();
			final refreshedUser = _auth.currentUser;
			final refreshedDisplayName = refreshedUser?.displayName?.trim();
			if (refreshedDisplayName == null || refreshedDisplayName.isEmpty) {
				return 'Could not set username. Please try a different username.';
			}
			return null; // Success
		} on FirebaseAuthException catch (error) {
			return error.message ?? error.code;
		} catch (_) {
			return 'Something went wrong. Please try again.';
		}
	}

	// Generate a suggested username
	String generateSuggestedUsername() {
		var suggestion = AliasEngine.name;

		return suggestion;
	}

  Future<void> deleteCurrentUser() async {
    await _auth.currentUser!.delete();
  }

  static const _emailForSignInKey = 'email_for_sign_in';

  /// Sends a passwordless sign-in link to the given email.
  /// Store email in SharedPreferences (required for signInWithEmailLink when user returns).
  Future<String?> sendSignInLinkToEmail(String email) async {
		try {
			final prefs = await SharedPreferences.getInstance();
			await prefs.setString(_emailForSignInKey, email);

			final actionCodeSettings = AuthActionCodeSettings.settings;

			await _auth.sendSignInLinkToEmail(
				email: email.trim(),
				actionCodeSettings: actionCodeSettings,
			);
			return null;
		} on FirebaseAuthException catch (e) {
			return e.message ?? e.code;
		} catch (e) {
			return e.toString();
		}
  }

  /// Call when app opens from the email link to complete sign-in.
  /// Pass the full link URL (e.g. from app_links or getInitialLink).
  Future<String?> signInWithEmailLink(String link) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_emailForSignInKey);
      if (email == null || email.isEmpty) {
        return 'Email not found. Please request a new link.';
      }
      if (!_auth.isSignInWithEmailLink(link)) {
        return 'Invalid sign-in link.';
      }
      await _auth.signInWithEmailLink(email: email, emailLink: link);
      await prefs.remove(_emailForSignInKey);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.code;
    } catch (e) {
      return e.toString();
    }
  }
}