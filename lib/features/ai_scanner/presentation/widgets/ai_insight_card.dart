import 'package:flutter/material.dart';
import 'package:regizai/core/theme/app_theme.dart';

class AiInsightCard extends StatelessWidget {
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  const AiInsightCard({
    Key? key,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Estimasi persentase AKG berbasis 2000 kkal
    final int akgPercent = ((calories / 2000) * 100).clamp(5, 100).toInt();

    // Tentukan Nutri-Grade sederhana berbasis rasio protein & lemak
    final bool isHealthy = protein >= 12 && fat <= 20;
    final String grade = isHealthy ? 'A' : 'B';
    final Color gradeColor = isHealthy ? const Color(0xFF10B981) : const Color(0xFF3B82F6);
    final String gradeStatus = isHealthy ? 'Sangat Seimbang' : 'Cukup Baik';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Insight + Nutri-Grade Badge (Resilient Row, No Overflow)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'AI Smart Insights',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textMain,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Analisis Pintar RegizAI',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSub),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Compact Nutri-Grade Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: gradeColor.withOpacity(0.25), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: gradeColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        grade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Grade $grade',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: gradeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Poin-poin Insight AI (Setiap baris dibungkus Expanded & tertata rapi)
          _buildInsightRow(
            icon: Icons.fitness_center_rounded,
            color: AppTheme.proteinColor,
            title: 'Kandungan Protein',
            subtitle: '${protein.toStringAsFixed(1)}g protein baik untuk pemulihan dan massa otot.',
          ),
          const SizedBox(height: 10),
          _buildInsightRow(
            icon: Icons.pie_chart_rounded,
            color: AppTheme.calorieColor,
            title: 'Porsi Kalori',
            subtitle: 'Menyumbang ~$akgPercent% dari acuan 2.000 kkal per hari ($gradeStatus).',
          ),
          const SizedBox(height: 10),
          _buildInsightRow(
            icon: Icons.water_drop_rounded,
            color: AppTheme.carbColor,
            title: 'Tips Sehat',
            subtitle: 'Cukupi dengan segelas air mineral dan serat sayuran hijau.',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSub,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
