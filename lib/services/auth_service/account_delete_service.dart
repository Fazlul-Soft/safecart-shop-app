import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/services/profile_info_service.dart';

import '../../helpers/common_helper.dart';
import 'save_sign_in_info_service.dart';

class AccountDeleteService with ChangeNotifier {
  bool loadingAccountDelete = false;

  setLoadingAccountDelete(value) {
    loadingAccountDelete = value;
    notifyListeners();
  }

  Future<bool> accountDelete(BuildContext context,
      {required String password}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return false;
    }
    setLoadingAccountDelete(true);
    try {
      if (baseApi.toString().toLowerCase().contains("safecart")) {
        await Future.delayed(const Duration(seconds: 2));
        showToast(
            asProvider
                .getString('This feature is not available for the demo app'),
            cc.red);
        setLoadingAccountDelete(false);
        return false;
      }
      var headers = {
        'Authorization': 'Bearer $getToken',
      };
      final response = await http.post(
        Uri.parse('$baseApi/user/delete-account'),
        headers: {
          ...headers,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        showToast(
            asProvider.getString('Account delete successful'), cc.primaryColor);
        Provider.of<SaveSignInInfoService>(context, listen: false).clearToken();
        Provider.of<ProfileInfoService>(context, listen: false).logout();
        return true;
      } else if (data['message'] != null) {
        showToast(asProvider.getString(data['message']), cc.red);
        return false;
      } else {
        showToast(response.reasonPhrase.toString().capitalize(), cc.red);
        print(data);
        return false;
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
      return false;
    } catch (err) {
      showToast(err.toString(), cc.red);
      print(err);
      return false;
    } finally {
      setLoadingAccountDelete(false);
    }
  }
}
