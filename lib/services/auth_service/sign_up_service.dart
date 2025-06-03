import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:safecart/services/auth_service/otp_service.dart';
import 'package:safecart/services/auth_service/save_sign_in_info_service.dart';
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import '../../views/enter_otp_view.dart';
import 'sign_in_service.dart';

class SignUpService with ChangeNotifier {
  bool loadingSignUp = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;
  bool acceptTPP = false;

  setLoadingSignUp(value) {
    loadingSignUp = value;
    notifyListeners();
  }

  setObscurePasswordOne(value) {
    obscurePasswordOne = value ?? !obscurePasswordOne;
    notifyListeners();
  }

  setObscurePasswordTwo(value) {
    obscurePasswordTwo = value ?? !obscurePasswordTwo;
    notifyListeners();
  }

  setAcceptTPP(value) {
    acceptTPP = value ?? !acceptTPP;
    notifyListeners();
  }

  Future<void> signUp(
    BuildContext context,
    String name,
    String email,
    String username,
    String password,
    String phone,
  ) async {
    setLoadingSignUp(true);
    try {
      // 1. First send OTP
      final otpCode = await Provider.of<OtpService>(context, listen: false)
          .sendOTP(context, phone);

      if (otpCode == null) {
        showToast('Failed to send OTP', cc.red);
        return;
      }

      // 2. Navigate to OTP verification with user data
      final verified = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => EnterOtpView(
            otpCode,
            phoneNumber: phone,
            fromRegister: true,
          ),
          settings: RouteSettings(arguments: {
            'name': name,
            'email': email,
            'username': username,
            'password': password,
            'phone': phone,
          }),
        ),
      );

      // 3. Only register if OTP verified
      if (verified == true) {
        final success = await _registerUser(
          context,
          name: name,
          email: email,
          username: username,
          password: password,
          phone: phone,
        );

        if (success) {
          // Automatically log in the user after registration
          // await Provider.of<SignInService>(context, listen: false)
          //     .signIn(context, username, password);
          try {
            await Provider.of<SignInService>(context, listen: false)
                .signIn(context, phone, password);
          } catch (e) {
            print('Login with phone failed: $e');
            // If phone login fails, try with email
            try {
              await Provider.of<SignInService>(context, listen: false)
                  .signIn(context, email, password);
            } catch (e) {
              print('Login with email failed: $e');
              showToast('Registration successful! Please sign in', cc.green);
              Navigator.pop(context); // Return to sign in screen
            }
          }
        }
      }
    } catch (e) {
      showToast('Registration failed: ${e.toString()}', cc.red);
    } finally {
      setLoadingSignUp(false);
    }
  }

  Future<bool> _registerUser(
    BuildContext context, {
    required String name,
    required String email,
    required String username,
    required String password,
    required String phone,
  }) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/register'));
      request.fields.addAll({
        'username': username,
        'password': password,
        'full_name': name,
        'email': email,
        'phone': phone,
        'terms_conditions': 'on',
      });

      final response = await request.send();
      final data = jsonDecode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      showToast(e.toString(), cc.red);
      return false;
    }
  }
}