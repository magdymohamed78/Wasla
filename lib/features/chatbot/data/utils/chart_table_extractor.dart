import '../../domain/entities/chart_data.dart';

class ChartTableExtractor {
  static List<ChartData> extractChartsFromMarkdown(String markdown) {
    final parsedTables = _parseAllTables(markdown);
    if (parsedTables.isEmpty) return [];

    final charts = <ChartData>[];
    var chartIndex = 0;

    for (final tableData in parsedTables) {
      if (tableData.length < 2) continue;

      final headers = tableData.first;
      final numericColumnIndices = _findNumericColumns(tableData);
      if (numericColumnIndices.isEmpty) continue;

      final labelColumnIndex = _findLabelColumn(headers, numericColumnIndices);
      if (labelColumnIndex == null) continue;

      if (numericColumnIndices.length > 1) {
        charts.add(
          _buildBarChart(
            tableData,
            headers,
            labelColumnIndex,
            numericColumnIndices,
            chartIndex,
          ),
        );
      } else {
        final numericIndex = numericColumnIndices.first;
        final segments = <ChartSegment>[];
        for (int i = 1; i < tableData.length; i++) {
          final row = tableData[i];
          final label = labelColumnIndex < row.length
              ? row[labelColumnIndex]
              : 'Item $i';
          final value = numericIndex < row.length
              ? _parseDouble(row[numericIndex])
              : 0.0;
          if (value > 0) {
            segments.add(ChartSegment(label: label, value: value));
          }
        }
        if (segments.isNotEmpty) {
          charts.add(
            ChartData(
              id: 'auto-pie-$chartIndex',
              type: ChartType.doughnut,
              title: numericIndex < headers.length
                  ? headers[numericIndex]
                  : null,
              segments: segments,
            ),
          );
        }
      }
      chartIndex++;
    }

    return charts;
  }

  static List<List<List<String>>> _parseAllTables(String markdown) {
    final result = <List<List<String>>>[];
    final lines = markdown.split('\n');
    List<String>? currentRawRows;

    for (final line in lines) {
      final trimmed = line.trim();
      if (_isTableRow(trimmed)) {
        if (_isTableSeparatorLine(trimmed)) continue;
        currentRawRows ??= [];
        currentRawRows.add(trimmed);
      } else {
        if (currentRawRows != null && currentRawRows.isNotEmpty) {
          result.add(_rawRowsToTable(currentRawRows));
          currentRawRows = null;
        }
      }
    }
    if (currentRawRows != null && currentRawRows.isNotEmpty) {
      result.add(_rawRowsToTable(currentRawRows));
    }

    return result;
  }

  static List<List<String>> _rawRowsToTable(List<String> rawRows) {
    final table = <List<String>>[];
    int maxCols = 0;

    for (final row in rawRows) {
      final cells = _splitRowCells(row);
      if (cells.length > maxCols) maxCols = cells.length;
      table.add(cells);
    }

    for (final row in table) {
      while (row.length < maxCols) {
        row.add('');
      }
    }

    return table;
  }

  static List<String> _splitRowCells(String row) {
    final trimmed = row.trim();
    if (!trimmed.startsWith('|')) return [];

    final parts = trimmed.split('|');
    final cells = <String>[];
    for (int i = 1; i < parts.length - 1; i++) {
      cells.add(_stripFormatting(parts[i].trim()));
    }
    return cells;
  }

  static List<int> _findNumericColumns(List<List<String>> table) {
    if (table.length < 2) return [];

    final columnCount = table.first.length;
    final numericIndices = <int>[];

    for (int col = 0; col < columnCount; col++) {
      var numericCount = 0;
      for (int row = 1; row < table.length; row++) {
        if (col < table[row].length && _isNumericValue(table[row][col])) {
          numericCount++;
        }
      }
      if (numericCount > 0) {
        numericIndices.add(col);
      }
    }

    return numericIndices;
  }

  static int? _findLabelColumn(List<String> headers, List<int> numericIndices) {
    for (int i = 0; i < headers.length; i++) {
      if (!numericIndices.contains(i)) {
        return i;
      }
    }
    return headers.isNotEmpty ? 0 : null;
  }

  static ChartData _buildBarChart(
    List<List<String>> table,
    List<String> headers,
    int labelColumnIndex,
    List<int> numericColumnIndices,
    int chartIndex,
  ) {
    final groups = <BarGroup>[];

    for (int row = 1; row < table.length; row++) {
      final cells = table[row];
      final label = labelColumnIndex < cells.length
          ? cells[labelColumnIndex]
          : 'Item $row';

      final rods = <BarRod>[];
      for (final colIndex in numericColumnIndices) {
        if (colIndex < cells.length) {
          rods.add(BarRod(value: _parseDouble(cells[colIndex])));
        }
      }
      if (rods.isNotEmpty) {
        groups.add(BarGroup(label: label, rods: rods));
      }
    }

    return ChartData(
      id: 'auto-bar-$chartIndex',
      type: ChartType.bar,
      title: labelColumnIndex < headers.length
          ? headers[labelColumnIndex]
          : null,
      barGroups: groups,
    );
  }

  static bool _isTableRow(String line) {
    return line.startsWith('|') && line.endsWith('|');
  }

  static bool _isTableSeparatorLine(String line) {
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

  static bool _isNumericValue(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'[,\s%]'), '')
        .replaceAll('\u2212', '-')
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-');
    if (cleaned.isEmpty) return false;
    return double.tryParse(cleaned) != null;
  }

  static double _parseDouble(String value) {
    var cleaned = value
        .replaceAll(RegExp(r'[,]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final rangeMatch = RegExp(
      r'([\d.]+)\s*[\u2013\u2014\-]\s*([\d.]+)',
    ).firstMatch(cleaned);
    if (rangeMatch != null) {
      return double.tryParse(rangeMatch.group(1)!) ?? 0.0;
    }

    cleaned = cleaned
        .replaceAll(RegExp(r'%'), '')
        .replaceAll('\u2212', '-')
        .replaceAll('\u2013', '-')
        .replaceAll('\u2014', '-')
        .trim();

    return double.tryParse(cleaned) ?? 0.0;
  }

  static String _stripFormatting(String text) {
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
    result = result.replaceAll(RegExp(r'[\u2588\u2591\u2592\u2593]+'), '');
    result = result.replaceAll(RegExp(r'[\u2B50\u2605]'), '');
    return result.trim();
  }
}
