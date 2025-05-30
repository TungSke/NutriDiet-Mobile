import 'dart:convert';
import 'dart:io';

import 'package:diet_plan_app/components/barcode_scanner_widget.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_theme.dart';
import 'package:diet_plan_app/flutter_flow/flutter_flow_util.dart';
import 'package:diet_plan_app/services/food_service.dart';
import 'package:diet_plan_app/services/meallog_service.dart';
import 'package:diet_plan_app/services/package_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../log_in_flow/buy_premium_package_screen/buy_premium_package_screen_widget.dart';

class QuickAddWidget extends StatefulWidget {
  final String mealName;
  final DateTime selectedDate;

  const QuickAddWidget({
    Key? key,
    required this.mealName,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _QuickAddWidgetState createState() => _QuickAddWidgetState();
}

class _QuickAddWidgetState extends State<QuickAddWidget> {
  final MeallogService _mealLogService = MeallogService();
  final PackageService _packageService = PackageService();
  final List<String> _mealTypes = const [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks'
  ];
  late String _selectedMeal;
  File? _scannedImage;
  bool _isLoadingImage = false;
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedMeal = widget.mealName;
    _fatController.addListener(_onMacroChanged);
    _carbsController.addListener(_onMacroChanged);
    _proteinController.addListener(_onMacroChanged);
    _caloriesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fatController.removeListener(_onMacroChanged);
    _carbsController.removeListener(_onMacroChanged);
    _proteinController.removeListener(_onMacroChanged);
    _caloriesController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _foodNameController.dispose();
    super.dispose();
  }

  double get _macroCalories {
    final double fat = double.tryParse(_fatController.text) ?? 0;
    final double carbs = double.tryParse(_carbsController.text) ?? 0;
    final double protein = double.tryParse(_proteinController.text) ?? 0;
    return fat * 9 + carbs * 4 + protein * 4;
  }

  void _onMacroChanged() {
    setState(() {});
  }

  int get _typedCalories {
    final double? value = double.tryParse(_caloriesController.text);
    return value != null ? value.round() : 0;
  }

  int get _calDiff => _typedCalories - _macroCalories.round();

  Future<void> _onSave() async {
    final int fats = int.tryParse(_fatController.text) ?? 0;
    final int carbs = int.tryParse(_carbsController.text) ?? 0;
    final int protein = int.tryParse(_proteinController.text) ?? 0;
    final int finalCalories = _typedCalories;

    if (finalCalories == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calories không được để trống!')),
      );
      return;
    }

    final bool exceedsCalories = await _mealLogService.calorieEstimator(
      logDate: widget.selectedDate.toIso8601String(),
      additionalCalories: finalCalories,
    );

    if (exceedsCalories) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Cảnh báo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          content: Text(
            'Đã vượt lượng Calories mục tiêu. Bạn có chắc chắn muốn thêm?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Hủy',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: FlutterFlowTheme.of(context).primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: FlutterFlowTheme.of(context).primary),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Đồng ý',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    final success = await _mealLogService.quickAddMeal(
      logDate: widget.selectedDate,
      mealType: _selectedMeal,
      foodName: _foodNameController.text,
      calories: finalCalories,
      carbohydrates: carbs,
      fats: fats,
      protein: protein,
      imageFile: _scannedImage,
    );

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm món nhanh thất bại!')),
      );
    }
  }

  void _onScanBarcode() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: BarcodeScannerScreen(
            onBarcodeDetected: (barcode) {
              Navigator.pop(dialogContext);
              _fetchDataFromBarcode(barcode);
            },
          ),
        );
      },
    );
  }

  // Hàm hiển thị dialog "Yêu cầu Premium Advanced"
  Future<void> _showPremiumRequiredDialog() async {
    final proceedToPremium = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                'Yêu cầu Premium Advanced',
                style: FlutterFlowTheme.of(context).titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Để sử dụng tính năng "Thêm ảnh", bạn cần nâng cấp lên gói Premium Advanced.\nThưởng thức các tính năng độc quyền ngay hôm nay!',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (proceedToPremium == true && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BuyPremiumPackageScreenWidget(),
        ),
      );
    }
  }

  Future<void> _onAddImage() async {
    // Kiểm tra trạng thái Premium Advanced
    try {
      final premiumData = await _packageService.isPremium();
      final isPremium = premiumData['isPremium'] == true;
      final isAdvanced = premiumData['packageType'] == 'Advanced';

      if (!isPremium || !isAdvanced) {
        await _showPremiumRequiredDialog();
        return;
      }

      // Tiếp tục với logic quét ảnh nếu là Premium Advanced
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);
      setState(() {
        _scannedImage = imageFile;
        _isLoadingImage = true;
      });

      try {
        final result = await FoodService().scanFoodImage(
          imageFile: imageFile,
          context: context,
        );
        final data = (result?['data'] as Map<String, dynamic>?) ?? {};
        setState(() {
          _caloriesController.text =
              (double.tryParse(data['calories']?.toString() ?? '0') ?? 0)
                  .round()
                  .toString();
          _fatController.text =
              (double.tryParse(data['fat']?.toString() ?? '0') ?? 0)
                  .round()
                  .toString();
          _carbsController.text =
              (double.tryParse(data['carbs']?.toString() ?? '0') ?? 0)
                  .round()
                  .toString();
          _proteinController.text =
              (double.tryParse(data['protein']?.toString() ?? '0') ?? 0)
                  .round()
                  .toString();
          _foodNameController.text = data['foodName']?.toString() ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phân tích ảnh thành công!')),
        );
      } catch (e) {
        debugPrint('Error in _onAddImage: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi scan ảnh: $e')),
        );
      } finally {
        setState(() {
          _isLoadingImage = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking Premium status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi kiểm tra trạng thái Premium')),
      );
    }
  }

  Future<void> _fetchDataFromBarcode(String barcode) async {
    if (!mounted) return;

    print('Mã vạch: $barcode');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mã vạch: $barcode')),
    );

    try {
      FoodService _foodService = FoodService();
      final foodData = await _foodService.searchFoodBarCode(
          barcode: barcode, context: context);
      if (foodData != null && mounted) {
        final responseBody = jsonDecode(foodData.body);
        final data = responseBody["data"] as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            _caloriesController.text =
                (double.tryParse(data['calories']?.toString() ?? '0') ?? 0)
                    .round()
                    .toString();
            _fatController.text =
                (double.tryParse(data['fat']?.toString() ?? '0') ?? 0)
                    .round()
                    .toString();
            _carbsController.text =
                (double.tryParse(data['carbs']?.toString() ?? '0') ?? 0)
                    .round()
                    .toString();
            _proteinController.text =
                (double.tryParse(data['protein']?.toString() ?? '0') ?? 0)
                    .round()
                    .toString();
            if (data.containsKey('foodName')) {
              _foodNameController.text = data['foodName'].toString();
            }
          });
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Không có dữ liệu món ăn trong phản hồi!')),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy thông tin món ăn!')),
        );
      }
    } catch (e) {
      if (mounted) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lấy dữ liệu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double macroCals = _macroCalories;
    final int typedCals = _typedCalories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Thêm nhanh',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Quét mã vạch',
            onPressed: _onScanBarcode,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            tooltip: 'Thêm ảnh',
            onPressed: _onAddImage,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _onSave,
          ),
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _buildMealRow(),
          const Divider(),
          _buildFoodNameRow(),
          const Divider(),
          _buildCaloriesRow(macroCals, typedCals),
          const Divider(),
          _buildMacroRow(
            label: 'Fat (g)',
            controller: _fatController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Carbohydrates (g)',
            controller: _carbsController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
          _buildMacroRow(
            label: 'Protein (g)',
            controller: _proteinController,
            hintText: 'Không bắt buộc',
          ),
          const Divider(),
          if (_scannedImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.file(
                    _scannedImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  if (_isLoadingImage)
                    Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  final Map<String, String> mealTypeMapping = const {
    'Breakfast': 'Bữa sáng',
    'Lunch': 'Bữa trưa',
    'Dinner': 'Bữa tối',
    'Snacks': 'Bữa phụ',
  };

  Widget _buildMealRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Bữa',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<String>(
          value: _selectedMeal,
          underline: const SizedBox(),
          items: _mealTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(mealTypeMapping[type] ?? type),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedMeal = val;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildFoodNameRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên món ăn',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _foodNameController,
          decoration: const InputDecoration(
            hintText: 'Nhập tên món ăn',
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesRow(double macroCals, int typedCals) {
    bool hasMacros = macroCals > 0;
    bool userTyped = typedCals > 0;
    String subLabel = '';
    if (!userTyped && hasMacros) {
      subLabel = 'Tính toán dựa trên giá trị dinh dưỡng.';
    } else if (userTyped && hasMacros && (typedCals != macroCals.round())) {
      final diff = typedCals - macroCals.round();
      subLabel =
          "Tổng calo của macros là ${macroCals.round()} cals.\nChênh lệch: $diff cals";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calories',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 130,
              child: TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nhập số lượng calorie',
                ),
              ),
            ),
          ],
        ),
        if (subLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              subLabel,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildMacroRow({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 130,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
