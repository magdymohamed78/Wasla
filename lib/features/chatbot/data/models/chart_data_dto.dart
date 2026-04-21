import '../../domain/entities/chart_data.dart';

class ChartSegmentDto {
  final String label;
  final double value;
  final String? color;

  const ChartSegmentDto({required this.label, required this.value, this.color});

  factory ChartSegmentDto.fromJson(Map<String, dynamic> json) {
    return ChartSegmentDto(
      label: json['label'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
    );
  }

  ChartSegment toDomain() {
    return ChartSegment(label: label, value: value, color: color);
  }
}

class BarRodDto {
  final double value;
  final String? color;

  const BarRodDto({required this.value, this.color});

  factory BarRodDto.fromJson(Map<String, dynamic> json) {
    return BarRodDto(
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      color: json['color'] as String?,
    );
  }

  BarRod toDomain() {
    return BarRod(value: value, color: color);
  }
}

class BarGroupDto {
  final String label;
  final List<BarRodDto> rods;

  const BarGroupDto({required this.label, required this.rods});

  factory BarGroupDto.fromJson(Map<String, dynamic> json) {
    final rodsRaw = json['rods'] as List<dynamic>? ?? [];
    return BarGroupDto(
      label: json['label'] as String? ?? '',
      rods: rodsRaw
          .map((e) => BarRodDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  BarGroup toDomain() {
    return BarGroup(label: label, rods: rods.map((r) => r.toDomain()).toList());
  }
}

class ChartDataDto {
  final String? id;
  final ChartType type;
  final String? title;
  final List<ChartSegmentDto> segments;
  final List<BarGroupDto> barGroups;

  const ChartDataDto({
    this.id,
    required this.type,
    this.title,
    this.segments = const [],
    this.barGroups = const [],
  });

  factory ChartDataDto.fromJson(Map<String, dynamic> json) {
    final typeString = (json['type'] as String?)?.toLowerCase() ?? 'pie';
    final ChartType chartType;
    switch (typeString) {
      case 'doughnut':
        chartType = ChartType.doughnut;
      case 'bar':
        chartType = ChartType.bar;
      default:
        chartType = ChartType.pie;
    }

    final segmentsRaw = json['segments'] as List<dynamic>? ?? [];
    final barGroupsRaw =
        json['bar_groups'] as List<dynamic>? ??
        json['barGroups'] as List<dynamic>? ??
        [];

    return ChartDataDto(
      id: json['id'] as String?,
      type: chartType,
      title: json['title'] as String?,
      segments: segmentsRaw
          .map((e) => ChartSegmentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      barGroups: barGroupsRaw
          .map((e) => BarGroupDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ChartData toDomain() {
    return ChartData(
      id: id ?? '',
      type: type,
      title: title,
      segments: segments.map((s) => s.toDomain()).toList(),
      barGroups: barGroups.map((g) => g.toDomain()).toList(),
    );
  }

  static ChartDataDto fromDomain(ChartData data) {
    return ChartDataDto(
      id: data.id,
      type: data.type,
      title: data.title,
      segments: data.segments
          .map(
            (s) =>
                ChartSegmentDto(label: s.label, value: s.value, color: s.color),
          )
          .toList(),
      barGroups: data.barGroups
          .map(
            (g) => BarGroupDto(
              label: g.label,
              rods: g.rods
                  .map((r) => BarRodDto(value: r.value, color: r.color))
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': type.name};
    if (id != null) json['id'] = id!;
    if (title != null) json['title'] = title!;
    json['segments'] = segments.map((s) {
      final segJson = <String, dynamic>{'label': s.label, 'value': s.value};
      if (s.color != null) segJson['color'] = s.color;
      return segJson;
    }).toList();
    json['bar_groups'] = barGroups.map((g) {
      return <String, dynamic>{
        'label': g.label,
        'rods': g.rods.map((r) {
          final rodJson = <String, dynamic>{'value': r.value};
          if (r.color != null) rodJson['color'] = r.color;
          return rodJson;
        }).toList(),
      };
    }).toList();
    return json;
  }
}
