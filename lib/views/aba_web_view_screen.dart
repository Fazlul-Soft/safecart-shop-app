import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../helpers/common_helper.dart'; // Make sure you have this import for showToast
import '../views/order_confirmation_screen.dart';


class AbaWebViewScreen extends StatefulWidget {
  final String htmlContent;
  final String orderId;

  const AbaWebViewScreen({
    required this.htmlContent,
    required this.orderId,
    Key? key,
  }) : super(key: key);

  @override
  _AbaWebViewScreenState createState() => _AbaWebViewScreenState();
}

class _AbaWebViewScreenState extends State<AbaWebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            // Simply close when payment completes
            if (url.contains('success')) {
              Navigator.pop(context); // Return to previous screen
            }
          },
        ),
      )
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ABA PayWay'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}