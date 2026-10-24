import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'shared_widgets.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _section = 0;
  int _range = 0;
  static const sections = ['Sales', 'Inventory', 'Customers'];
  static const ranges = ['7 Days', '30 Days', 'Custom'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        title: const Text('Reports & Analytics'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          _SegmentedSelector(
            labels: sections,
            selected: _section,
            onSelected: (index) => setState(() => _section = index),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: List.generate(
              ranges.length,
              (index) => FilterPill(
                label: ranges[index],
                selected: _range == index,
                onTap: () => setState(() => _range = index),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Sales',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        _section == 0
                            ? 'UGX 8,450,000'
                            : _section == 1
                            ? '145 Items'
                            : '328 Customers',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '↑ 15%',
                        style: TextStyle(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.bar_chart_rounded,
                  size: 42,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeading(title: 'Sales Trend'),
          const SizedBox(height: 12),
          Container(
            height: 220,
            padding: const EdgeInsets.fromLTRB(10, 16, 14, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: const _SalesChart(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _InsightButton(
                  icon: Icons.inventory_2_outlined,
                  label: 'Top Products',
                  onTap: () => showAppMessage(context, 'Top products report'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InsightButton(
                  icon: Icons.credit_card_rounded,
                  label: 'Payment Methods',
                  onTap: () =>
                      showAppMessage(context, 'Payment methods report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedSelector extends StatelessWidget {
  const _SegmentedSelector({
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF3F8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: List.generate(
        labels.length,
        (index) => Expanded(
          child: InkWell(
            onTap: () => onSelected(index),
            borderRadius: BorderRadius.circular(9),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected == index
                    ? AppTheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected == index ? Colors.white : AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _SalesChart extends StatelessWidget {
  const _SalesChart();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: Row(
          children: [
            const SizedBox(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '10M',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                  Text(
                    '5M',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                  Text(
                    '0',
                    style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomPaint(
                painter: _ChartPainter(),
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['Oct 10', '11', '12', '13', '14', '15', '16']
            .map(
              (day) => Text(
                day,
                style: TextStyle(fontSize: 9, color: AppTheme.textMuted),
              ),
            )
            .toList(),
      ),
    ],
  );
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final values = [0.28, 0.42, 0.50, 0.68, 0.59, 0.73, 0.91];
    final points = List<Offset>.generate(
      values.length,
      (index) => Offset(
        index * size.width / (values.length - 1),
        size.height * (1 - values[index]),
      ),
    );
    final baseline = size.height;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 0; index < points.length - 1; index++) {
      final current = points[index];
      final next = points[index + 1];
      final middleX = (current.dx + next.dx) / 2;
      path.cubicTo(middleX, current.dy, middleX, next.dy, next.dx, next.dy);
    }
    final fillPath = Path.from(path)
      ..lineTo(size.width, baseline)
      ..lineTo(0, baseline)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x553B82F6), Color(0x003B82F6)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Offset.zero & size),
    );
    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = size.height * fraction;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = AppTheme.border
          ..strokeWidth = 1,
      );
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = AppTheme.primary
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    for (final point in points) {
      canvas.drawCircle(point, 3.3, Paint()..color = AppTheme.primary);
      canvas.drawCircle(point, 1.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => false;
}

class _InsightButton extends StatelessWidget {
  const _InsightButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 19),
    label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    style: OutlinedButton.styleFrom(
      alignment: Alignment.centerLeft,
      foregroundColor: AppTheme.textPrimary,
      minimumSize: const Size.fromHeight(48),
      side: const BorderSide(color: AppTheme.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
