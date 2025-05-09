import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../helpers/common_helper.dart';

// class ResetPasswordService with ChangeNotifier {
//   String? email;
//   bool loadingResetPassword = false;
//   bool obscurePasswordOne = true;
//   bool obscurePasswordTwo = true;

//   setLoadingResetPassword(value) {
//     loadingResetPassword = value;
//     notifyListeners();
//   }

//   setObscurePasswordOne(value) {
//     obscurePasswordOne = value ?? !obscurePasswordOne;
//     notifyListeners();
//   }

//   setObscurePasswordTwo(value) {
//     obscurePasswordTwo = value ?? !obscurePasswordTwo;
//     notifyListeners();
//   }

//   setEmail(value) {
//     email = value;
//     notifyListeners();
//   }

//   resetPassword(BuildContext context, password) async {
//     final haveConnection = await checkConnection(context);
//     if (!haveConnection) {
//       return;
//     }
//     setLoadingResetPassword(true);
//     try {
//       var request =
//           http.MultipartRequest('POST', Uri.parse('$baseApi/reset-password'));
//       request.fields.addAll({
//         'password': password,
//         'email': email.toString(),
//       });

//       http.StreamedResponse response = await request.send();

//       if (response.statusCode == 200) {
//         print(await response.stream.bytesToString());
//         showToast(asProvider.getString('Password reset successful'), cc.green);
//         Navigator.pop(context);
//       } else {
//         print(response.reasonPhrase);
//         showToast(asProvider.getString('Password reset failed'), cc.red);
//       }
//     } on TimeoutException {
//       showToast(asProvider.getString('Request timeout'), cc.red);
//     } catch (err) {
//       showToast(err.toString(), cc.red);
//       print(err);
//     } finally {
//       setLoadingResetPassword(false);
//     }
//   }
// }
class ResetPasswordService with ChangeNotifier {
  String? phone; // Changed from email to phone
  bool loadingResetPassword = false;
  bool obscurePasswordOne = true;
  bool obscurePasswordTwo = true;

  setLoadingResetPassword(value) {
    loadingResetPassword = value;
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

  setPhone(value) {
    // Changed from setEmail to setPhone
    phone = value;
    notifyListeners();
  }

  resetPassword(BuildContext context, password) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      showToast(asProvider.getString('No internet connection'), cc.red);
      return;
    }
    if (phone == null || phone!.isEmpty) {
      showToast(asProvider.getString('Please enter phone number'), cc.red);
      return;
    }
    setLoadingResetPassword(true);
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseApi/reset-password'));
      request.fields.addAll({
        'password': password.trim(),
        'phone': phone!.trim(),
      });

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);
       print('Reset password response: $jsonResponse');
      // http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
         showToast(asProvider.getString('Password reset successful'), cc.green);
        // print(await response.stream.bytesToString());
        Navigator.pop(context);
      } else {
        // print(response.reasonPhrase);
        // showToast(asProvider.getString('Password reset failed'), cc.red);

        final errorMessage = jsonResponse['message'] ?? 
                           asProvider.getString('Password reset failed');
        showToast(errorMessage, cc.red);
        
        // Specific handling for phone not found
        if (jsonResponse['message']?.contains('not found') ?? false) {
          showToast(asProvider.getString('Phone number not registered'), cc.red);
        }
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
    } finally {
      setLoadingResetPassword(false);
    }
  }
}
