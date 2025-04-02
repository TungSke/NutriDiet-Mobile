import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/services/package_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  final PackageService _packageService = PackageService();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            print("Navigating to: ${request.url}");
            if (request.url.contains("checkoutSuccessScreen")) {
              final uri = Uri.parse(request.url);
              final statusParam = uri.queryParameters['status'] ?? '';
              await _packageService.payosCallback(statusParam);
              context.push("/checkoutSuccessScreen");
              return NavigationDecision.prevent;
            } else if (request.url.contains("checkoutFailScreen")) {
              // Trích xuất tham số status từ URL
              final uri = Uri.parse(request.url);
              final statusParam = uri.queryParameters['status'] ?? '';
              await _packageService.payosCallback(statusParam);
              context.push("/checkoutFailScreen");
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thanh toán"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
