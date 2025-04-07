import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  _BarcodeScannerScreenState createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera quét mã vạch
          MobileScanner(
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final code = barcodes.first.rawValue;
                if (code != null && context.mounted) {
                  context.pop(code);
                }
              }
            },
          ),

          // Overlay làm mờ xung quanh khu vực quét
          _buildOverlay(context),

          // Khung quét mã vạch
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white, // Viền trắng nổi bật
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Hiệu ứng viền động
                  _buildAnimatedBorder(),

                  // Đường quét di chuyển lên xuống
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: 250 * _scanLineAnimation.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          color: Colors.greenAccent, // Đường quét sáng hơn
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Nút đóng
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white, // Nút đóng màu trắng
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Tạo overlay làm mờ xung quanh khu vực quét
  Widget _buildOverlay(BuildContext context) {
    return CustomPaint(
      painter: OverlayPainter(),
      child: Container(),
    );
  }

  // Hiệu ứng viền động cho khung quét
  Widget _buildAnimatedBorder() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.greenAccent.withOpacity(
                0.5 + 0.5 * _animationController.value,
              ),
              width: 3,
            ),
          ),
        );
      },
    );
  }
}

// CustomPainter để vẽ overlay làm mờ xung quanh khu vực quét
class OverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5); // Làm mờ xung quanh

    // Tạo một hình chữ nhật bao quanh toàn màn hình
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Tạo một hình chữ nhật trong suốt ở giữa (khu vực quét)
    final scanArea = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 250,
      height: 250,
    );

    // Vẽ overlay làm mờ, trừ khu vực quét
    final path = Path()
      ..addRect(outerRect)
      ..addRect(scanArea)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}