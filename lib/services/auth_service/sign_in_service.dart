// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/common_helper.dart';
import '../../views/enter_otp_view.dart';
import '../../views/home_front_view.dart';

class SignInService with ChangeNotifier {
  bool loadingSignIn = false;
  bool obscurePassword = true;
  bool rememberPassword = false;

  setLoadingSignIn(value) {
    loadingSignIn = value;
    notifyListeners();
  }

  setObscurePassword(value) {
    obscurePassword = value ?? !obscurePassword;
    notifyListeners();
  }

  setRememberPassword(value) {
    rememberPassword = value ?? !rememberPassword;
    notifyListeners();
    if (value != null) {
      _saveRememberMePreference(value);
    }
  }

  Future<void> _saveRememberMePreference(bool value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('remember_me', value);
  }

  Future<bool> _loadRememberMePreference() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool('remember_me') ?? false;
  }

  Future<void> initializeRememberMe() async {
    rememberPassword = await _loadRememberMePreference();
    notifyListeners();
  }

  Future<void> signIn(
      BuildContext context, String identifier, String password) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) return;

    setLoadingSignIn(true);

    if (rememberPassword) {
      Provider.of<SaveSignInInfoService>(context, listen: false)
          .saveSignInInfo(identifier, password);
    } else {
      Provider.of<SaveSignInInfoService>(context, listen: false)
          .clearCredentials();
    }
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseApi/login'));

      // Determine if identifier is phone or email
      if (identifier.contains('@')) {
        request.fields.addAll({
          'username': identifier.trim(),
          'password': password.trim(),
        });
      } else {
        request.fields.addAll({
          'username': identifier.trim(),
          'password': password.trim(),
        });
      }

      http.StreamedResponse response = await request.send();
      final data = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        // Handle successful login
        Provider.of<SaveSignInInfoService>(context, listen: false)
            .saveToken(data['token']);
        await Provider.of<ProfileInfoService>(context, listen: false)
            .fetchProfileInfo(context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeFrontView()),
          (route) => false,
        );
      } else {
        showToast(data['message'] ?? 'Invalid credentials', cc.red);
      }
    } on TimeoutException {
      showToast('Request timeout', cc.red);
    } catch (err) {
      showToast('Invalid credentials', cc.red);
    } finally {
      setLoadingSignIn(false);
    }
  }
  // signIn(BuildContext context, usernameEmail, password) async {
  //   final haveConnection = await checkConnection(context);
  //   if (!haveConnection) {
  //     return;
  //   }
  //   setLoadingSignIn(true);

  //   // Save credentials if "Remember Me" is enabled
  //   if (rememberPassword) {
  //     Provider.of<SaveSignInInfoService>(context, listen: false)
  //         .saveSignInInfo(usernameEmail, password);
  //   } else {
  //     Provider.of<SaveSignInInfoService>(context, listen: false)
  //         .saveSignInInfo('', '');
  //   }

  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse('$baseApi/login'));
  //     request.fields.addAll({
  //       'username': usernameEmail,
  //       'password': password,
  //     });

  //     http.StreamedResponse response = await request.send();
  //     final data = jsonDecode(await response.stream.bytesToString());

  //     if (response.statusCode == 200) {
  //       // Save token and fetch profile
  //       Provider.of<SaveSignInInfoService>(context, listen: false)
  //           .saveToken(data['token']);
  //       await Provider.of<ProfileInfoService>(context, listen: false)
  //           .fetchProfileInfo(context);

  //       setLoadingSignIn(false);
  //       Navigator.pop(context, true); // Return to previous screen
  //     } else {
  //       // Handle errors
  //       showToast(
  //         data['message'] != null
  //             ? asProvider.getString(data['message'])
  //             : asProvider.getString('Sign in failed'),
  //         cc.red,
  //       );
  //       setLoadingSignIn(false);
  //     }
  //   } on TimeoutException {
  //     showToast(asProvider.getString('Request timeout'), cc.red);
  //     setLoadingSignIn(false);
  //   } catch (err) {
  //     showToast(err.toString(), cc.red);
  //     print(err);
  //     setLoadingSignIn(false);
  //   }
  // }

  Future<void> handleEmailVerification(
      BuildContext context, dynamic data) async {
    final otpProvider = Provider.of<OtpService>(context, listen: false);
    final profileService =
        Provider.of<ProfileInfoService>(context, listen: false);

    await profileService.fetchProfileInfo(context, token: data['token']);
    final email = profileService.profileInfo?.userDetails.email ?? '';

    final otpCode = await otpProvider.sendOTP(context, email);
    if (otpCode != null) {
      await Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => EnterOtpView(
            otpCode,
            fromRegister: false,
            phoneNumber: data['users']['phone'],
          ),
        ),
      )
          .then((verified) async {
        if (verified == true) {
          await otpProvider.verifyPhone(context, data['users']['id'], otpCode);
          await handleSuccessfulSignIn(context, data);
        }
      });
    }
  }

  Future<void> handleSuccessfulSignIn(
      BuildContext context, dynamic data) async {
    // Save token
    Provider.of<SaveSignInInfoService>(context, listen: false)
        .saveToken(data['token']);

    // Fetch profile info
    await Provider.of<ProfileInfoService>(context, listen: false)
        .fetchProfileInfo(context);
  }

  // signIn(BuildContext context, usernameEmail, password) async {
  //   final haveConnection = await checkConnection(context);
  //   if (!haveConnection) {
  //     return;
  //   }
  //   setLoadingSignIn(true);
  //   if (rememberPassword) {
  //     Provider.of<SaveSignInInfoService>(context, listen: false)
  //         .saveSignInInfo(usernameEmail, password);
  //   } else {
  //     Provider.of<SaveSignInInfoService>(context, listen: false)
  //         .saveSignInInfo('', '');
  //   }
  //   Provider.of<SaveSignInInfoService>(context, listen: false)
  //       .getSaveinfos(context);
  //   final otpProvider = Provider.of<OtpService>(context, listen: false);
  //   try {
  //     var request = http.MultipartRequest('POST', Uri.parse('$baseApi/login'));
  //     request.fields.addAll({
  //       'username': usernameEmail,
  //       'password': password,
  //     });

  //     http.StreamedResponse response = await request.send();

  //     final data = jsonDecode(await response.stream.bytesToString());
  //     if (response.statusCode == 200) {
  //       print(data);
  //       final emailVerified = data['users']['email_verified'] == '1';
  //       if (!emailVerified) {
  //         await Provider.of<ProfileInfoService>(context, listen: false)
  //             .fetchProfileInfo(context, token: data['token']);
  //         final otpCode = await otpProvider.sendOTP(
  //             context,
  //             Provider.of<ProfileInfoService>(context, listen: false)
  //                 .profileInfo!
  //                 .userDetails
  //                 .email);
  //         if (otpCode != null) {
  //           await Navigator.of(context)
  //               .push(PageRouteBuilder(
  //                   pageBuilder: (context, animation, anotherAnimation) {
  //             return EnterOtpView(
  //               otpCode,
  //               fromRegister: true,
  //               phoneNumber: data['users']['phone'],
  //             );
  //           }, transitionsBuilder:
  //                       (context, animation, anotherAnimation, child) {
  //             animation =
  //                 CurvedAnimation(curve: Curves.decelerate, parent: animation);
  //             return Align(
  //               child: FadeTransition(
  //                 opacity: animation,
  //                 child: child,
  //               ),
  //             );
  //           }))
  //               .then((value) async {
  //             if (value == true) {
  //               await otpProvider.verifyPhone(
  //                 context,
  //                 data['users']['id'],
  //                 otpCode,
  //               );
  //               Provider.of<SaveSignInInfoService>(context, listen: false)
  //                   .saveToken(data['token']);
  //               await Provider.of<ProfileInfoService>(context, listen: false)
  //                   .fetchProfileInfo(context);
  //               Navigator.pop(context, true);
  //             }
  //           });
  //         }

  //         setLoadingSignIn(false);
  //         return;
  //       }
  //       Provider.of<SaveSignInInfoService>(context, listen: false)
  //           .saveToken(data['token']);
  //       await Provider.of<ProfileInfoService>(context, listen: false)
  //           .fetchProfileInfo(context);
  //       setLoadingSignIn(false);
  //       Navigator.pop(context, true);
  //     } else if (data['message'] != null) {
  //       showToast(asProvider.getString(data['message']), cc.red);
  //       setLoadingSignIn(false);
  //     } else {
  //       showToast(asProvider.getString('Sign in failed'), cc.red);
  //       print(data);
  //       setLoadingSignIn(false);
  //     }
  //   } on TimeoutException {
  //     showToast(asProvider.getString('Request timeout'), cc.red);
  //     setLoadingSignIn(false);
  //   } catch (err) {
  //     showToast(err.toString(), cc.red);
  //     print(err);
  //     setLoadingSignIn(false);
  //   }
  // }
}
