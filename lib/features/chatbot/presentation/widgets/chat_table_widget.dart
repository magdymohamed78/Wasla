import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ChatTableWidget extends StatelessWidget {
  final String markdownTable;

  const ChatTableWidget({super.key, required this.markdownTable});

  static const double _minCellWidth = 60.0;
  static const double _cellPaddingH = 10.0;
  static const double _cellPaddingV = 8.0;

  @override
  Widget build(BuildContext context) {
    final parsed = _parseMarkdownTable(markdownTable);
    if (parsed.length < 2) return const SizedBox.shrink();

    final headers = parsed.first;
    final columnCount = headers.length;
    if (columnCount == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLg),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: _buildTable(parsed, columnCount),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(List<List<String>> parsed, int columnCount) {
    final headers = parsed.first;
    final rows = parsed.sublist(1);
    final colWidths = _calculateColumnWidths(parsed);

    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      columnWidths: {
        for (int i = 0; i < columnCount; i++) i: FixedColumnWidth(colWidths[i]),
      },
      border: TableBorder.all(color: AppColors.divider, width: 0.5),
      children: [
        _buildHeaderRow(headers, columnCount),
        for (int i = 0; i < rows.length; i++)
          _buildDataRow(rows[i], i, columnCount),
      ],
    );
  }

  TableRow _buildHeaderRow(List<String> headers, int columnCount) {
    return TableRow(
      decoration: const BoxDecoration(color: AppColors.brandRed),
      children: List.generate(columnCount, (index) {
        final text = index < headers.length ? headers[index] : '';
        return _buildCell(text: text, isHeader: true);
      }),
    );
  }

  TableRow _buildDataRow(List<String> cells, int rowIndex, int columnCount) {
    return TableRow(
      decoration: BoxDecoration(
        color: rowIndex.isEven ? AppColors.surface : AppColors.background,
      ),
      children: List.generate(columnCount, (index) {
        final text = index < cells.length ? cells[index] : '';
        return _buildCell(text: text, isHeader: false);
      }),
    );
  }

  Widget _buildCell({required String text, required bool isHeader}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _cellPaddingH,
        vertical: _cellPaddingV,
      ),
      child: Text(
        text,
        style: isHeader
            ? AppTypography.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )
            : AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
        softWrap: true,
      ),
    );
  }

  List<double> _calculateColumnWidths(List<List<String>> parsed) {
    final columnCount = parsed.first.length;
    final maxWidths = List<double>.filled(columnCount, 0.0);

    for (final row in parsed) {
      for (int i = 0; i < columnCount; i++) {
        if (i < row.length) {
          final charCount = row[i].length;
          final estimatedWidth = charCount * 7.0 + _cellPaddingH * 2;
          if (estimatedWidth > maxWidths[i]) {
            maxWidths[i] = estimatedWidth;
          }
        }
      }
    }

    return maxWidths.map((w) => w.clamp(_minCellWidth, 280.0)).toList();
  }

  List<List<String>> _parseMarkdownTable(String markdown) {
    final lines = markdown.split('\n');
    final result = <List<String>>[];

    for (final line in lines) {
      final trimmed = line.trim();
      if (_isTableSeparatorLine(trimmed)) continue;

      if (trimmed.startsWith('|') && trimmed.endsWith('|')) {
        final cells = <String>[];
        final parts = trimmed.split('|');
        for (int i = 1; i < parts.length - 1; i++) {
          cells.add(_stripMarkdownFormatting(parts[i].trim()));
        }
        if (cells.isNotEmpty) {
          result.add(cells);
        }
      } else if (trimmed.startsWith('|')) {
        final parts = trimmed
            .split('|')
            .where((s) => s.trim().isNotEmpty)
            .map((s) => _stripMarkdownFormatting(s.trim()))
            .toList();
        if (parts.isNotEmpty) {
          result.add(parts);
        }
      }
    }

    if (result.isEmpty) return result;

    final maxColumns = result.fold<int>(
      0,
      (max, row) => row.length > max ? row.length : max,
    );
    for (final row in result) {
      while (row.length < maxColumns) {
        row.add('');
      }
    }

    return result;
  }

  bool _isTableSeparatorLine(String line) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('|') || !trimmed.endsWith('|')) return false;

    final cells = trimmed.split('|');
    for (int i = 1; i < cells.length - 1; i++) {
      final cell = cells[i].trim();
      if (cell.isEmpty) continue;
      if (!RegExp(r'^:?-+:?$').hasMatch(cell)) return false;
    }
    return true;
  }

  String _stripMarkdownFormatting(String text) {
    var result = text;
    result = result.replaceAllMapped(
      RegExp(r'\*\*(.+?)\*\*'),
      (m) => m.group(1)!,
    );
    result = result.replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => m.group(1)!);
    result = result.replaceAllMapped(RegExp(r'__(.+?)__'), (m) => m.group(1)!);
    result = result.replaceAllMapped(RegExp(r'_(.+?)_'), (m) => m.group(1)!);
    result = result.replaceAllMapped(RegExp(r'~~(.+?)~~'), (m) => m.group(1)!);
    result = result.replaceAllMapped(RegExp(r'`(.+?)`'), (m) => m.group(1)!);
    return result.trim();
  }
}
