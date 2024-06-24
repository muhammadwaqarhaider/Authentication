import 'package:firebase/view/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';
import '../services/database_manager.dart';
import '../view/screens/auth/sign_in.dart';
import '../view/widget/custom_snackbar.dart';
import '../view/widget/loading_dialog.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Rx<User?> _firebaseUser = Rx<User?>(null);
  User? get user => _firebaseUser.value;
  DatabaseService db = DatabaseService();

  @override
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
    update();
    super.onInit();
  }

  Future<void> signInWithGoogle() async {
    showLoadingDialog();
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if(googleUser==null){
        dismissLoadingDialog();
        showCustomSnackBar("Login Failed", "User has canceled SignIn with Google");
        showConsole("Login Failed: User has canceled SignIn with Google");
        return;
      }
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        showConsole(user);
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel newUser = UserModel(
            email: user.email!,
            Name: user.displayName,
            phone: user.phoneNumber,
            profilePicture: user.photoURL,
            accountType: "SignInWithGoogle",
            googleId: user.providerData.first.uid,
          );
          await _createUserFirestore(newUser, user);
        }
        dismissLoadingDialog();
        Get.offAll(() => HomeScreen());
      }
      else{
        dismissLoadingDialog();
        showConsole("user");
        showCustomSnackBar("Login Failed", "Something went Wrong");
      }
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showConsole('Login Failed ${error.message}');
      showCustomSnackBar("Login Failed", error.message.toString());
    }
  }
  //
  // Future<void> signInWithFacebook() async {
  //   showLoadingDialog();
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status != LoginStatus.success){
  //       dismissLoadingDialog();
  //       showCustomSnackBar("Login Failed", "User has canceled SignIn with Facebook");
  //       showConsole("Login Failed: User has canceled SignIn with Facebook");
  //       return;
  //     }
  //       showConsole("Result LoginStatus.success");
  //       final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
  //       UserCredential userCredential =
  //       await _auth.signInWithCredential(credential);
  //       User? user = userCredential.user;
  //       userCredential.credential!.asMap();
  //       if (user != null) {
  //         showConsole(user);
  //         if (userCredential.additionalUserInfo!.isNewUser) {
  //           UserModel newUser = UserModel(
  //             userId: user.uid,
  //             email: user.email!,
  //             userName: user.displayName,
  //             phone: user.phoneNumber,
  //             profilePicture: user.photoURL,
  //             accountType: "SignInWithFacebook",
  //             facebookId: user.providerData.first.uid,
  //             status: "Active",
  //           );
  //           await _createUserFirestore(newUser, user);
  //         }
  //         dismissLoadingDialog();
  //         Get.offAll(() => DashboardScreen(pageIndex: 0));
  //       }
  //       else{
  //         dismissLoadingDialog();
  //         showConsole("user");
  //         showCustomSnackBar("Login Failed", "Something went Wrong");
  //       }
  //     } on FirebaseAuthException catch (error) {
  //     if(error.code=="account-exists-with-different-credential"){
  //       List<String> userSignInMethods= await _auth.fetchSignInMethodsForEmail(error.email!);
  //       showConsole(userSignInMethods);
  //     }
  //     dismissLoadingDialog();
  //     showConsole('Login Failed ${error.message}');
  //     showCustomSnackBar("Login Failed", error.message.toString());
  //   }
  // }

  Future<void> signInWithEmailAndPassword(UserModel userModel) async {
    showLoadingDialog();
    try {
      await _auth.signInWithEmailAndPassword(
          email: userModel.email!,
          password: userModel.password!
      ).then((value) {
        showConsole(value);
      });
      dismissLoadingDialog();
      Get.offAll(() => HomeScreen());
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showConsole('Login Failed ${error.message}');
      showCustomSnackBar("Login Failed", error.message.toString());
    }
  }
  Future<void> registerWithEmailAndPassword(UserModel userModel) async {
    showLoadingDialog();
    try {
      UserCredential result=await _auth.createUserWithEmailAndPassword(
          email: userModel.email!,
          password: userModel.password!,
      );
      if(result.additionalUserInfo!.isNewUser){
        UserModel newUser = UserModel(
          email: result.user!.email!,
          Name: userModel.Name,
          phone: userModel.phone,
          accountType: "SignInWithEmail",
        );
        await _createUserFirestore(newUser, result.user!);
        dismissLoadingDialog();
        Get.offAll(() => HomeScreen());
      }
      else{
        dismissLoadingDialog();
        showConsole("user");
        showCustomSnackBar("Login Failed", "Something went Wrong");
      }
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showConsole('Sign up Failed ${error.code}');
      showCustomSnackBar("Sign up Failed ", error.message.toString());
    }
  }
  Future<void> _createUserFirestore(UserModel user, User firebaseUser) async {
    await db.usersCollection.doc(firebaseUser.uid).set(user.toMap());
    update();
  }

  Future<void> updateUserProfile(UserModel userModel) async {
    showLoadingDialog();
    try {
      await _auth.currentUser!.updateEmail(userModel.email!).then((result) async {
        db.usersCollection.doc(_auth.currentUser!.uid).update({
          'email': userModel.email,
          'Name': userModel.Name,
          'phone': userModel.phone,
        });
        dismissLoadingDialog();
        showCustomSnackBar("Update Success", "Profile updated successfully");
      });
    } on FirebaseException catch (error) {
      dismissLoadingDialog();
      showCustomSnackBar("Update Failed", error.message.toString());
      showConsole("Update Failed: ${error.message.toString()}");
    }
  }

  Future<void> updateProfileImage(UserModel userModel) async {
    showLoadingDialog();
    try {
        db.usersCollection.doc(_auth.currentUser!.uid).update({
          'profilePicture': userModel.profilePicture,
        });
        dismissLoadingDialog();
        showCustomSnackBar("Update Success", "Profile Image updated successfully");
    } on FirebaseException catch (error) {
      dismissLoadingDialog();
      showCustomSnackBar("Update Failed", error.message.toString());
      showConsole("Update Failed: ${error.message.toString()}");
    }
  }


  Future<void> updatePassword(UserModel userModel) async {
    showLoadingDialog();
    try {
      showConsole(_auth.currentUser);
      await _auth.currentUser!.updatePassword(userModel.password!).then((value) {
        dismissLoadingDialog();
        showCustomSnackBar("Password Reset", "Password changed successfully");
        showConsole("Password Reset: Password changed successfully");
      });
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showCustomSnackBar("Password Reset", error.message.toString());
      showConsole("Password Reset: ${error.message}");
    }
  }

  Future<void> forgotPassword(UserModel userModel) async {
    showLoadingDialog();
    try {
      await _auth.sendPasswordResetEmail(email: userModel.email!).then((value) {
        dismissLoadingDialog();
        showCustomSnackBar("Password Reset", "Forgot password email send to given email");
        showConsole("Password Reset: Forgot Password email send to given email");
      });
    } on FirebaseAuthException catch (error) {
      dismissLoadingDialog();
      showCustomSnackBar("Forgot Password Failed", error.message.toString());
      showConsole("Forgot Password Failed: ${error.message}");
    }
  }

  void signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    //await FacebookAuth.instance.logOut();
    Get.offAll(() => SignIn());
  }
}
