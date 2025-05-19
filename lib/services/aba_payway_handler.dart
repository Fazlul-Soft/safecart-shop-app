// aba_payway_handler.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safecart/helpers/common_helper.dart';

class AbaPaywayHandler {
  static Future<Map<String, dynamic>> confirmPayment({
    required String orderId,
    required String transactionId,
  }) async {
    try {
      var headers = {
        'app-secret-key': paymentStatusUpdateKey,
        'Content-Type': 'application/json',
      };
      
      final body = {
        'order_id': orderId,
        'transaction_id': transactionId,
        'gateway': 'abapayway',
        'status': 'complete',
      };

      final response = await http.post(
        Uri.parse('$baseApi/update-payment'),
        headers: headers,
        body: json.encode(body),
      );

      final data = json.decode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'order_id': orderId,
          'message': 'Payment confirmed successfully',
        };
      } else {
        throw Exception(data['message'] ?? 'Payment confirmation failed');
      }
    } catch (e) {
      throw Exception('Failed to confirm payment: ${e.toString()}');
    }
  }
}