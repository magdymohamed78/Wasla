import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chart_data.dart';

class ChatChartWidget extends StatelessWidget {
  final ChartData chartData;

  const ChatChartWidget({super.key, required this.chartData});

  static const List<Color> _chartColors = [
    AppColors.brandRed,
    AppColors.statusAccepted,
    AppColors.statusOfferSent,
    AppColors.statusPending,
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.spacingSm),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chartData.title != null && chartData.title!.isNotEmpty) ...[
            Text(
              chartData.title!,
              style: AppTypography.heading3.copyWith(fontSize: 16),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
          ],
          if (chartData.type == ChartType.bar)
            _buildBarChart()
          else
            _buildPieChart(isDoughnut: chartData.type == ChartType.doughnut),
          const SizedBox(height: AppDimensions.spacingSm),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildPieChart({bool isDoughnut = false}) {
    final sections = chartData.segments;
    if (sections.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _buildPieSections(sections),
          sectionsSpace: 2,
          centerSpaceRadius: isDoughnut ? 40 : 0,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(List<ChartSegment> segments) {
    final total = segments.fold<double>(0, (sum, s) => sum + s.value);
    return segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;
      final percentage = total > 0 ? (segment.value / total) * 100 : 0.0;
      final color =
          _parseColor(segment.color) ??
          _chartColors[index % _chartColors.length];

      return PieChartSectionData(
        value: segment.value,
        title: percentage >= 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        color: color,
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildBarChart() {
    final groups = chartData.barGroups;
    if (groups.isEmpty) return const SizedBox.shrink();

    final maxRodValue = groups.fold<double>(
      0,
      (max, group) => group.rods.fold<double>(
        max,
        (innerMax, rod) => rod.value > innerMax ? rod.value : innerMax,
      ),
    );

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxRodValue * 1.2,
          barGroups: groups.asMap().entries.map((entry) {
            final index = entry.key;
            final group = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: group.rods.asMap().entries.map((rodEntry) {
                final rodIndex = rodEntry.key;
                final rod = rodEntry.value;
                final color =
                    _parseColor(rod.color) ??
                    _chartColors[rodIndex % _chartColors.length];
                return BarChartRodData(
                  toY: rod.value,
                  color: color,
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                );
              }).toList(),
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: AppTypography.bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < groups.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        groups[index].label,
                        style: AppTypography.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxRodValue > 0 ? maxRodValue / 5 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    final items = chartData.type == ChartType.bar
        ? _buildBarLegendItems()
        : _buildPieLegendItems();

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppDimensions.spacingSm,
      runSpacing: AppDimensions.spacingXs,
      children: items,
    );
  }

  List<Widget> _buildPieLegendItems() {
    return chartData.segments.asMap().entries.map((entry) {
      final index = entry.key;
      final segment = entry.value;
      final color =
          _parseColor(segment.color) ??
          _chartColors[index % _chartColors.length];
      return _LegendItem(color: color, label: segment.label);
    }).toList();
  }

  List<Widget> _buildBarLegendItems() {
    if (chartData.barGroups.isEmpty) return [];
    final rods = chartData.barGroups.first.rods;
    return rods.asMap().entries.map((entry) {
      final index = entry.key;
      final color =
          _parseColor(entry.value.color) ??
          _chartColors[index % _chartColors.length];
      return _LegendItem(color: color, label: 'Series ${index + 1}');
    }).toList();
  }

  static Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final hexInt = int.parse(hex.replaceFirst('#', ''), radix: 16);
      return Color(hexInt).withOpacity(1);
    } catch (_) {
      return null;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.bodySmall),
      ],
    );
  }
}
