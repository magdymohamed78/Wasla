import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import 'chat_table_widget.dart';

class MarkdownMessageContent extends StatelessWidget {
  final String content;

  const MarkdownMessageContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final blocks = _splitContentByTables(content);

    if (blocks.isEmpty) return const SizedBox.shrink();

    if (blocks.length == 1 && !blocks.first.isTable) {
      return _buildMarkdownText(blocks.first.text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: blocks.map((block) {
        if (block.isTable) {
          return ChatTableWidget(markdownTable: block.text);
        }
        return _buildMarkdownText(block.text);
      }).toList(),
    );
  }

  Widget _buildMarkdownText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const SizedBox.shrink();

    return MarkdownWidget(
      data: trimmed,
      styleConfig: StyleConfig(
        pConfig: PConfig(
          textStyle: AppTypography.bodyMedium.copyWith(height: 1.5),
          linkStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.brandRed,
            decoration: TextDecoration.underline,
          ),
          emStyle: AppTypography.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
          strongStyle: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
          delStyle: AppTypography.bodyMedium.copyWith(
            decoration: TextDecoration.lineThrough,
            height: 1.5,
          ),
        ),
        titleConfig: TitleConfig(
          h1: AppTypography.heading3.copyWith(fontSize: 20, height: 1.4),
          h2: AppTypography.heading3.copyWith(fontSize: 18, height: 1.4),
          h3: AppTypography.heading3.copyWith(fontSize: 16, height: 1.4),
          showDivider: false,
        ),
        preConfig: PreConfig(
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd),
          ),
          textStyle: AppTypography.bodySmall.copyWith(
            fontFamily: 'monospace',
            height: 1.4,
          ),
        ),
        codeConfig: CodeConfig(
          codeStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.brandRed,
            backgroundColor: AppColors.buttonSecondary.withValues(alpha: 0.5),
            fontFamily: 'monospace',
          ),
        ),
        ulConfig: UlConfig(
          textStyle: AppTypography.bodyMedium.copyWith(height: 1.5),
          dotSize: 6,
          leftSpacing: 12,
        ),
        olConfig: OlConfig(
          textStyle: AppTypography.bodyMedium.copyWith(height: 1.5),
          leftSpacing: 12,
        ),
        blockQuoteConfig: BlockQuoteConfig(
          blockStyle: AppTypography.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
          blockColor: AppColors.brandRed,
          backgroundColor: AppColors.brandRed.withValues(alpha: 0.05),
          blockWidth: 3,
          leftSpace: 10,
        ),
        hrConfig: HrConfig(color: AppColors.divider, height: 1),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  List<_ContentBlock> _splitContentByTables(String content) {
    final blocks = <_ContentBlock>[];
    final lines = content.split('\n');
    final buffer = StringBuffer();
    var inTable = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      final isSeparator = _isTableSeparatorLine(trimmed);
      final isRow = _isTableRow(trimmed);

      if (isRow || isSeparator) {
        if (!inTable) {
          if (buffer.isNotEmpty) {
            blocks.add(_ContentBlock(text: buffer.toString(), isTable: false));
            buffer.clear();
          }
          inTable = true;
        }
        buffer.writeln(line);
      } else {
        if (inTable) {
          blocks.add(_ContentBlock(text: buffer.toString(), isTable: true));
          buffer.clear();
          inTable = false;
        }
        buffer.writeln(line);
      }
    }

    if (buffer.isNotEmpty) {
      blocks.add(_ContentBlock(text: buffer.toString(), isTable: inTable));
    }

    return blocks.where((b) => b.text.trim().isNotEmpty).toList();
  }

  bool _isTableRow(String line) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('|') || trimmed.length < 3) return false;

    final pipeCount = '|'.allMatches(trimmed).length;
    return pipeCount >= 3;
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
}

class _ContentBlock {
  final String text;
  final bool isTable;

  const _ContentBlock({required this.text, required this.isTable});
}
