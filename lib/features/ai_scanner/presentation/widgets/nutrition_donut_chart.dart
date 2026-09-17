import 'dart:math';
import 'package:flutter/material.dart';
import 'package:regizai/core/theme/app_theme.dart';

class NutritionDonutChart extends StatelessWidget {
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double size;

  const NutritionDonutChart({
    Key? key,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.size = 170,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hitung proporsi kalori dari tiap makro (Protein: 4kcal/g, Carbs: 4kcal/g, Fat: 9kcal/g)
    final double proteinCal = protein * 4;
    final double carbsCal = carbs * 4;
    final double fatCal = fat * 9;
    final double totalMacroCal = proteinCal + carbsCal + fatCal;

    final double proteinRatio = totalMacroCal > 0 ? (proteinCal / totalMacroCal) : 0.25;
    final double carbsRatio = totalMacroCal > 0 ? (carbsCal / totalMacroCal) : 0.50;
    final double fatRatio = totalMacroCal > 0 ? (fatCal / totalMacroCal) : 0.25;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutChartPainter(
              proteinRatio: proteinRatio,
              carbsRatio: carbsRatio,
              fatRatio: fatRatio,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.calorieColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_fire_department_rounded, size: 14, color: AppTheme.calorieColor),
                    SizedBox(width: 2),
                    Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.calorieColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                calories.toInt().toString(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textMain,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'kkal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSub,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final double proteinRatio;
  final double carbsRatio;
  final double fatRatio;

  _DonutChartPainter({
    required this.proteinRatio,
    required this.carbsRatio,
    required this.fatRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 14.0;
    const gapAngle = 0.06; // jeda halus antar segmen (radian)

    final bgPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);

    // List proporsi & warna
    final segments = [
      _SegmentData(ratio: proteinRatio, color: AppTheme.proteinColor),
      _SegmentData(ratio: carbsRatio, color: AppTheme.carbColor),
      _SegmentData(ratio: fatRatio, color: AppTheme.fatColor),
    ];

    double startAngle = -pi / 2; // Mulai dari atas (jam 12)

    for (final segment in segments) {
      if (segment.ratio <= 0.01) continue;

      final sweepAngle = (segment.ratio * 2 * pi) - gapAngle;
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle + (gapAngle / 2), sweepAngle, false, paint);
      startAngle += (segment.ratio * 2 * pi);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.proteinRatio != proteinRatio ||
        oldDelegate.carbsRatio != carbsRatio ||
        oldDelegate.fatRatio != fatRatio;
  }
}

class _SegmentData {
  final double ratio;
  final Color color;

  _SegmentData({required this.ratio, required this.color});
}
