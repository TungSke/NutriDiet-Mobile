import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_widgets.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/buy_premium_package_screen_model.dart';
import 'package:diet_plan_app/log_in_flow/buy_premium_package_screen/web_view_page.dart';
import 'package:diet_plan_app/services/package_service.dart';
import 'package:intl/intl.dart';

class BuyPremiumPackageScreenWidget extends StatefulWidget {
  const BuyPremiumPackageScreenWidget({Key? key}) : super(key: key);

  @override
  State<BuyPremiumPackageScreenWidget> createState() =>
      _BuyPremiumPackageScreenWidgetState();
}

class _BuyPremiumPackageScreenWidgetState
    extends State<BuyPremiumPackageScreenWidget>
    with SingleTickerProviderStateMixin {
  late BuyPremiumPackageScreenModel _model;
  final PackageService _packageService = PackageService();

  late AnimationController _animationController;
  late Animation<Offset> _textOffsetAnimation;
  late Animation<double> _buttonOpacityAnimation;
  late Animation<double> _rotatingImageAnimation;
  late Animation<double> _bannerOpacityAnimation; // Thêm animation cho banner

  List<dynamic> packages = [];
  Map<String, dynamic>? premiumStatus;
  String? expiryDate;
  bool isLoading = true;

  // Hàm định dạng giá (99000 -> 99.000)
  String formatPrice(dynamic price) {
    if (price == null) return 'N/A';
    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(price).replaceAll(',', '.');
  }

  @override
  void initState() {
    super.initState();
    _model = BuyPremiumPackageScreenModel();
    _model.initState(context);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _buttonOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _rotatingImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _bannerOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );

    _fetchData();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _animationController.forward();
    });
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final packageList = await _packageService.getPackages();
      final status = await _packageService.isPremium();
      final userPackage = await _packageService.getMyUserPackage();

      String? formattedExpiryDate;
      if (userPackage != null && userPackage['expiryDate'] != null) {
        final expiryDateTime = DateTime.parse(userPackage['expiryDate']);
        formattedExpiryDate = DateFormat('dd/MM/yyyy').format(expiryDateTime);
      }

      setState(() {
        packages = packageList;
        premiumStatus = status;
        expiryDate = formattedExpiryDate;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi tải dữ liệu: $e"),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Thử lại',
            onPressed: _fetchData,
          ),
        ),
      );
    }
  }

  Future<void> _handlePayment(int packageId, String packageType) async {
    print("Handling payment for packageId: $packageId, packageType: $packageType");
    try {
      final isPremium = premiumStatus?['isPremium'] == true;
      final currentPackageType = premiumStatus?['packageType'] ?? 'None';

      if (isPremium) {
        if (currentPackageType == 'Advanced') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bạn đang sử dụng gói Advanced Premium. Không thể thay đổi gói."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
          return;
        }
        if (currentPackageType == 'Basic' && packageType == 'Basic') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Bạn đang sử dụng gói Basic Premium. Vui lòng nâng cấp lên Advanced."),
              backgroundColor: Colors.amber,
              duration: Duration(seconds: 4),
            ),
          );
          return;
        }
      }

      final response = (isPremium && currentPackageType == 'Basic' && packageType == 'Advanced')
          ? await _packageService.upgradePackage(packageId: packageId)
          : await _packageService.fetchPackagePayment(packageId: packageId);

      print("API response: $response");

      if (response != null && response['data'] != null) {
        final String paymentUrl = response['data'];
        print("Navigating to payment URL: $paymentUrl");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: paymentUrl),
          ),
        );
      } else {
        print("Invalid response");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Phản hồi từ server không hợp lệ."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("❌ Payment error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi khi thanh toán: ${e.toString().replaceFirst('Exception: ', '')}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDFFFD7),
                  Color(0xFFA0F0B1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Rotating header image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 200,
            child: AnimatedBuilder(
              animation: _rotatingImageAnimation,
              builder: (context, child) => Transform.rotate(
                angle: _rotatingImageAnimation.value * 0.2,
                child: child,
              ),
              child: Image.asset(
                "assets/images/package.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main scrollable content
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                    constraints: BoxConstraints(minHeight: size.height),
                    color: Colors.white.withOpacity(0.85),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo with fade-in
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: const Duration(milliseconds: 800),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withOpacity(0.9),
                            ),
                            child: Image.asset(
                              'assets/images/app_launcher_icon.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Slide-in text
                        SlideTransition(
                          position: _textOffsetAnimation,
                          child: Column(
                            children: [
                              Text(
                                "Chọn Gói Premium Của Bạn!",
                                style: GoogleFonts.roboto(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1B5E20),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Mở khóa các tính năng AI cá nhân hóa để đạt mục tiêu sức khỏe nhanh hơn!",
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Expiry date banner
                        if (expiryDate != null)
                          FadeTransition(
                            opacity: _bannerOpacityAnimation,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFDFFFD7),
                                    Color(0xFFA0F0B1),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.event,
                                    color: Color(0xFF1B5E20),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "Ngày hết hạn của gói: $expiryDate",
                                      style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1B5E20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // Loading indicator or package list
                        isLoading
                            ? const CircularProgressIndicator()
                            : Column(
                          children: packages.map((package) {
                            final isAdvanced = package['packageType'] == 'Advanced';
                            final isPremium = premiumStatus?['isPremium'] == true;
                            final currentPackageType = premiumStatus?['packageType'] ?? 'None';
                            final isDisabled = isPremium &&
                                (currentPackageType == 'Advanced' ||
                                    (currentPackageType == 'Basic' && !isAdvanced));
                            final buttonText = isPremium && currentPackageType == 'Basic' && isAdvanced
                                ? 'Nâng cấp'
                                : 'Mua ngay';
                            final isActivePackage = isPremium && currentPackageType == package['packageType'];

                            print("Package: ${package['packageName']}, isDisabled: $isDisabled, isActive: $isActivePackage");

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: isActivePackage
                                      ? const BorderSide(color: Color(0xFF1B5E20), width: 2)
                                      : BorderSide.none,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            package['packageName'] ?? 'Gói Premium',
                                            style: GoogleFonts.roboto(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1B5E20),
                                            ),
                                          ),
                                          if (isActivePackage)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF1B5E20),
                                              size: 24,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Giá: ${formatPrice(package['price'])} VND',
                                            style: GoogleFonts.roboto(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          if (isPremium && currentPackageType == 'Basic' && isAdvanced)
                                            Text(
                                              '(${formatPrice(package['price'])} VND là giá gốc. "Nâng cấp" để xem chi phí nâng cấp gói)',
                                              style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Thời gian: ${package['duration'] ?? 'N/A'} ngày',
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        package['description'] ?? 'Không có mô tả',
                                        style: GoogleFonts.roboto(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      FadeTransition(
                                        opacity: _buttonOpacityAnimation,
                                        child: FFButtonWidget(
                                          onPressed: isDisabled
                                              ? null
                                              : () => _handlePayment(
                                            package['packageId'],
                                            package['packageType'],
                                          ),
                                          text: buttonText,
                                          options: FFButtonOptions(
                                            width: double.infinity,
                                            height: 50,
                                            color: isDisabled
                                                ? Colors.grey
                                                : FlutterFlowTheme.of(context).primary,
                                            textStyle: GoogleFonts.roboto(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 30),

                        // Terms & Privacy
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: mở Điều khoản sử dụng
                              },
                              child: Text(
                                "Điều khoản sử dụng",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const WebViewPage(
                                      url: 'https://yourapp.com/privacy-policy',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Chính sách bảo mật",
                                style: TextStyle(
                                  color: FlutterFlowTheme.of(context).grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),

          // Close button on top
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: ClipOval(
              child: Material(
                color: Colors.white.withOpacity(0.8),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}