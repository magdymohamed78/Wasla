enum ChartType { pie, doughnut, bar }

class ChartData {
  final String id;
  final ChartType type;
  final String? title;
  final List<ChartSegment> segments;
  final List<BarGroup> barGroups;

  const ChartData({
    required this.id,
    required this.type,
    this.title,
    this.segments = const [],
    this.barGroups = const [],
  });
}

class ChartSegment {
  final String label;
  final double value;
  final String? color;

  const ChartSegment({required this.label, required this.value, this.color});
}

class BarGroup {
  final String label;
  final List<BarRod> rods;

  const BarGroup({required this.label, required this.rods});
}

class BarRod {
  final double value;
  final String? color;

  const BarRod({required this.value, this.color});
}
