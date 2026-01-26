import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UrlWebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const UrlWebViewScreen({
    required this.url,
    this.title,
    super.key,
  });

  @override
  State<UrlWebViewScreen> createState() => _UrlWebViewScreenState();
}

class _UrlWebViewScreenState extends State<UrlWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Open Link'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
