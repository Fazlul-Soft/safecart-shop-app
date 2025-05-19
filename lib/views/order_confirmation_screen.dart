// order_confirmation_screen.dart
import 'package:flutter/material.dart';
import '../helpers/common_helper.dart';

class OrderConfirmationScreen extends StatelessWidget {
  static const routeName = 'order_confirmation';
  
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final orderId = args['orderId'];
    final status = args['status'] ?? 'confirmed';
    
    return Scaffold(
      appBar: AppBar(title: Text('Order Confirmation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              status == 'confirmed' ? Icons.check_circle : Icons.error,
              color: status == 'confirmed' ? Colors.green : Colors.red,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              status == 'confirmed' 
                  ? 'Payment Successful!' 
                  : 'Payment Processing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Order ID: $orderId'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}