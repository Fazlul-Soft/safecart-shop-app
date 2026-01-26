import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:safecart/models/slider_model.dart';
import 'package:http/http.dart' as http;

import '../helpers/common_helper.dart';

class SliderService with ChangeNotifier {
  final Map<int, List<Datum>> _sliderLists = {};
  final Map<int, bool> _sliderLoading = {};

  List<Datum>? getSliderList(int type) => _sliderLists[type];
  bool isSliderLoading(int type) => _sliderLoading[type] ?? false;

  void _setSliderLoading(int type, {bool? value}) {
    _sliderLoading[type] = value ?? !(_sliderLoading[type] ?? false);
    notifyListeners();
  }

  Future<void> fetchSlider(BuildContext context, int type,
      {bool refreshing = false}) async {
    final haveConnection = await checkConnection(context);
    if (!haveConnection) {
      _sliderLists[type] ??= [];
      notifyListeners();
      return;
    }
    if (!refreshing) {
      _setSliderLoading(type, value: true);
    }

    try {
      final request = http.MultipartRequest(
        'GET',
        Uri.parse('$baseApi/mobile-slider/$type'),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final data = jsonDecode(await response.stream.bytesToString());
        _sliderLists[type] = SliderModel.fromJson(data).data;
        _setSliderLoading(type, value: false);
      } else {
        _sliderLists[type] = [];
        _setSliderLoading(type, value: false);
        print(response.reasonPhrase);
      }
    } on TimeoutException {
      _sliderLists[type] = [];
      _setSliderLoading(type, value: false);
      showToast(asProvider.getString('Request timeout'), cc.red);
    } catch (err) {
      _sliderLists[type] = [];
      _setSliderLoading(type, value: false);
      print(err);
    }
  }
}
