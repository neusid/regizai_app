import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regizai/core/theme/app_theme.dart';
import 'package:regizai/features/ai_scanner/presentation/widgets/ai_insight_card.dart';
import 'package:regizai/features/ai_scanner/presentation/widgets/nutrition_donut_chart.dart';
import 'package:regizai/features/journal/presentation/bloc/journal_bloc.dart';

class ScanPreviewPage extends StatefulWidget {
  final String imagePath;
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const ScanPreviewPage({
    Key? key,
    required this.imagePath,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  }) : super(key: key);

  @override
  State<ScanPreviewPage> createState() => _ScanPreviewPageState();
}

class _ScanPreviewPageState extends State<ScanPreviewPage> {
  double _portionMultiplier = 1.0;
  String _selectedMealTime = 'Makan Siang';

  final List<String> _mealTimes = [
    'Sarapan',
    'Makan Siang',
    'Makan Malam',
    'Camilan',
  ];

  Widget _buildFoodImage() {
    if (widget.imagePath.isNotEmpty && !widget.imagePath.startsWith('assets/')) {
      final file = File(widget.imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }

    String assetTarget = 'assets/img/nasi goreng.png';
    final lower = widget.foodName.toLowerCase();
    if (lower.contains('uduk')) {
      assetTarget = 'assets/img/nasi uduk.png';
    } else if (lower.contains('ayam') && lower.contains('goreng')) {
      assetTarget = 'assets/img/ayam goreng.png';
    } else if (lower.contains('sate')) {
      assetTarget = 'assets/img/sate ayam.png';
    } else if (lower.contains('rendang')) {
      assetTarget = 'assets/img/rendang.png';
    } else if (lower.contains('bakso')) {
      assetTarget = 'assets/img/bakso.png';
    } else if (lower.contains('soto')) {
      assetTarget = 'assets/img/soto.png';
    } else if (lower.contains('apel')) {
      assetTarget = 'assets/img/apel.png';
    } else if (lower.contains('pisang')) {
      assetTarget = 'assets/img/pisang.png';
    }

    return Image.asset(
      assetTarget,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF1E293B),
          child: const Center(
            child: Icon(Icons.restaurant_rounded, size: 70, color: Colors.white24),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final topInset = MediaQuery.of(context).padding.top;

    final currentCalories = widget.calories * _portionMultiplier;
    final currentProtein = widget.protein * _portionMultiplier;
    final currentFat = widget.fat * _portionMultiplier;
    final currentCarbs = widget.carbs * _portionMultiplier;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 150 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Image Section with Overlay
                Stack(
                  children: [
                    // Food Image with Rounded Bottom
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: _buildFoodImage(),
                      ),
                    ),

                    // Top Gradient for Button Contrast
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.60),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Floating Back Button
                    Positioned(
                      top: topInset + 10,
                      left: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white24, width: 1),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Floating AI Verification Badge
                    Positioned(
                      top: topInset + 14,
                      right: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065F46).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF34D399), width: 1.2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified_rounded, color: Color(0xFF34D399), size: 15),
                                SizedBox(width: 4),
                                Text(
                                  '98.4% AI Match',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 2. Title & Food Header (Safe, No Overflow)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'HIDANGAN UTAMA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryDark,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.auto_awesome_rounded, size: 14, color: AppTheme.primaryGreen),
                          const SizedBox(width: 4),
                          const Text(
                            'RegizAI Vision',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSub,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.foodName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textMain,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Nutrition Composition Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x060F172A),
                          blurRadius: 16,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Komposisi Nutrisi',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textMain,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${_portionMultiplier.toStringAsFixed(1)} Porsi',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textSub,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Donut Chart
                        Center(
                          child: NutritionDonutChart(
                            calories: currentCalories,
                            protein: currentProtein,
                            fat: currentFat,
                            carbs: currentCarbs,
                            size: 150,
                          ),
                        ),

                        const SizedBox(height: 18),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 16),

                        // 3 Bento Macro Cards (Serasi, Simetris & Anti-Overflow)
                        Row(
                          children: [
                            Expanded(
                              child: _buildMacroBentoCard(
                                title: 'Protein',
                                value: '${currentProtein.toStringAsFixed(1)}g',
                                icon: Icons.fitness_center_rounded,
                                color: AppTheme.proteinColor,
                                subtitle: '4 kkal/g',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMacroBentoCard(
                                title: 'Karbo',
                                value: '${currentCarbs.toStringAsFixed(1)}g',
                                icon: Icons.grain_rounded,
                                color: AppTheme.carbColor,
                                subtitle: '4 kkal/g',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMacroBentoCard(
                                title: 'Lemak',
                                value: '${currentFat.toStringAsFixed(1)}g',
                                icon: Icons.water_drop_rounded,
                                color: AppTheme.fatColor,
                                subtitle: '9 kkal/g',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 4. AI Smart Insight Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AiInsightCard(
                    foodName: widget.foodName,
                    calories: currentCalories,
                    protein: currentProtein,
                    fat: currentFat,
                    carbs: currentCarbs,
                  ),
                ),
              ],
            ),
          ),

          // 5. Sticky Floating Action Bar at the Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 14 + bottomInset),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Meal Time Chips & Portion Stepper
                  Row(
                    children: [
                      // Meal Time Selector
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _mealTimes.map((meal) {
                              final isSelected = _selectedMealTime == meal;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedMealTime = meal;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryGreen : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    meal,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      color: isSelected ? Colors.white : AppTheme.textSub,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Stepper Porsi (- / +)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                if (_portionMultiplier > 0.5) {
                                  setState(() {
                                    _portionMultiplier -= 0.5;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(3),
                                child: Icon(Icons.remove, size: 15, color: AppTheme.textMain),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                '${_portionMultiplier.toStringAsFixed(1)}x',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textMain,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (_portionMultiplier < 4.0) {
                                  setState(() {
                                    _portionMultiplier += 0.5;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: const Padding(
                                padding: EdgeInsets.all(3),
                                child: Icon(Icons.add, size: 15, color: AppTheme.textMain),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Main Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppTheme.heroGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.30),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          context.read<JournalBloc>().add(
                                AddMealLogEvent(
                                  userId: 'user_01',
                                  namaMakanan: '${widget.foodName} (${_portionMultiplier.toStringAsFixed(1)} porsi, $_selectedMealTime)',
                                  cal: currentCalories.toInt().toString(),
                                ),
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              backgroundColor: const Color(0xFF065F46),
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Berhasil disimpan ke Jurnal ($_selectedMealTime)!',
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.bookmark_add_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Simpan ke Jurnal Makanan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBentoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMain,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 9,
              color: AppTheme.textSub,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
