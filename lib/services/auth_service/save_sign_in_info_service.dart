import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safecart/helpers/common_helper.dart';
import 'package:safecart/services/auth_service/sign_in_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveSignInInfoService with ChangeNotifier {
  String? emailUsername;
  String? password;

  saveSignInInfo(usernameEmail, password) async {
    final spInstance = await SharedPreferences.getInstance();
    spInstance.setString('username_email', usernameEmail);
    spInstance.setString('password', password);

    this.emailUsername = usernameEmail;
    this.password = password;
    notifyListeners();
  }

  saveToken(token) async {
    final spInstance = await SharedPreferences.getInstance();
    spInstance.setString('token', token);
    setToken(token);
  }

  clearToken() async {
    final spInstance = await SharedPreferences.getInstance();
    spInstance.remove('token');
    setToken('');
  }

  clearCredentials() async {
    final spInstance = await SharedPreferences.getInstance();
    await spInstance.remove('username_email');
    await spInstance.remove('password');
    emailUsername = null;
    password = null;
    notifyListeners();
  }

  Future<void> getSaveinfos(BuildContext context) async {
    final spInstance = await SharedPreferences.getInstance();
    emailUsername = spInstance.getString('username_email');
    password = spInstance.getString('password');
    final token = spInstance.getString('token');

    if (password != null && password!.isNotEmpty) {
      Provider.of<SignInService>(context, listen: false)
          .setRememberPassword(true);
    }
    setToken(token ?? '');
    notifyListeners();
  }
  // getSaveinfos(BuildContext context) async {
  //   final spInstance = await SharedPreferences.getInstance();
  //   emailUsername = spInstance.getString('username_email');
  //   password = spInstance.getString('password');
  //   final token = spInstance.getString('token');
  //   print('the token is: $token');
  //   if (password != null && password!.isNotEmpty) {
  //     Provider.of<SignInService>(context, listen: false)
  //         .setRememberPassword(true);
  //   }
  //   setToken(token ?? '');
  // }
}
