// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safecart/models/city_dropdown_model.dart';
import 'package:safecart/models/profile_info_model.dart';
import 'package:safecart/models/state_model.dart';

import '../helpers/common_helper.dart';
import '../models/country_model.dart';
import '../utils/responsive.dart';

class ProfileInfoService with ChangeNotifier {
  ProfileInfoModel? profileInfo;
  var containerSize = screenWidth / 3.6;
  String? selectedCountryName;
  String? selectedStateName;
  File? selectedImage;
  bool loadingProfileUpdate = false;
  Country? selectedCountry;
  States? selectedState;
  City? selectedCity;

  logout() {
    profileInfo = null;
    notifyListeners();
  }

  login() {
    profileInfo = null;
    notifyListeners();
  }

  setSize(vaule) {
    containerSize = (screenWidth / 3.6) - vaule;
    notifyListeners();
  }

  setSelectedState(value) {
    selectedState = value;
    notifyListeners();
  }

  setSelectedCountry(value) {
    selectedCountry = value;
    notifyListeners();
  }

  setSelectedCity(value) {
    selectedCity = value;
    notifyListeners();
  }

  setSelectedImage(File? imageFile) {
    selectedImage = imageFile;
    notifyListeners();
  }

  setLoadingProfileUpdate(value) {
    loadingProfileUpdate = value ?? !loadingProfileUpdate;
    notifyListeners();
  }

  fetchProfileInfo(BuildContext context, {token}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }

    try {
      var headers = {'Authorization': 'Bearer ${token ?? getToken}'};
      var request = http.Request('GET', Uri.parse('$baseApi/user/profile'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        profileInfo = ProfileInfoModel.fromJson(data);
        // print(data);
        notifyListeners();
      } else {
        print(response.reasonPhrase);
        // showToast(response.reasonPhrase.toString().capitalize(), cc.red);
      }
    } on TimeoutException {
      // showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      // showToast(err.toString(), cc.red);
    }
  }

  updateProfileInfo(
    BuildContext context, {
    name,
    email,
    phone,
    city,
    zipcode,
    address,
  }) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      return;
    }
    if (selectedCountryName == null &&
        profileInfo?.userDetails.userCountry?.name == null) {
      showToast(asProvider.getString('Please select a country'), cc.red);
      return;
    }
    if (selectedStateName == null &&
        profileInfo?.userDetails.userState?.name == null) {
      showToast(asProvider.getString('Please select a state'), cc.red);
      return;
    }
    setLoadingProfileUpdate(true);

    try {
      var headers = {'Authorization': 'Bearer $getToken'};
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseApi/user/update-profile'));
      request.fields.addAll({
        'name': name,
        'email': email,
        'phone': phone,
        'zipcode': zipcode,
        'state': selectedState?.id.toString() ??
            profileInfo?.userDetails.userState?.id?.toString() ??
            '',
        'city': selectedCity?.id.toString() ??
            profileInfo?.userDetails.userCity?.id?.toString() ??
            "",
        'country': selectedCountry?.id.toString() ??
            profileInfo?.userDetails.userCountry?.id?.toString() ??
            "",
        'address': address
      });

      if (selectedImage != null) {
        print('Uploading image, this might take some time');
        snackBar(
            context,
            asProvider
                .getString('Uploading image, this might take some time...'),
            backgroundColor: cc.green,
            duration: const Duration(seconds: 1000));
        request.files.add(
            await http.MultipartFile.fromPath('file', selectedImage!.path));
      }
      request.headers.addAll(headers);
      await Future.delayed(const Duration(seconds: 5));

      http.StreamedResponse response = await request.send();

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (response.statusCode == 200) {
        await fetchProfileInfo(context);
        print('profile update response');
        print(await response.stream.bytesToString());
        showToast(asProvider.getString('Profile info successfully updated'),
            cc.green);
        Navigator.pop(context);
        setLoadingProfileUpdate(false);
      } else {
        showToast(
            asProvider.getString('Profile info updated failed'), cc.green);
        print(response.reasonPhrase);
        setLoadingProfileUpdate(false);
      }
    } on TimeoutException {
      showToast(asProvider.getString('Request timeout'), cc.red);
      setLoadingProfileUpdate(false);
    } catch (err) {
      showToast(asProvider.getString(err.toString()), cc.red);
      print(err);
      setLoadingProfileUpdate(false);
    }
  }
}
