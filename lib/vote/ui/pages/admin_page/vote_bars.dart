import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/vote/providers/section_provider.dart';
import 'package:myecl/vote/providers/sections_pretendance_provider.dart';

class VoteBars extends HookConsumerWidget {
  const VoteBars({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Duration animDuration = Duration(milliseconds: 250);
    final sectionsPretendance = ref.watch(sectionPretendanceProvider);
    final section = ref.watch(sectionProvider);
    final touchedIndex = useState(-1);
    final isTouched = useState(false);
    final barBackgroundColor = Colors.grey.shade300;
    const barColor = Colors.black;

    List<BarChartGroupData> pretendanceBars = [];
    List<String> sectionNames = [];
    List<double> voteValue = [];

    sectionsPretendance.when(
        data: (data) {
          if (data[section] != null) {
            data[section]!.when(
                data: ((data) {
                  sectionNames = data.map((e) => e.name).toList();
                  voteValue =
                      data.map((e) => Random().nextDouble() * 800).toList();
                  pretendanceBars = data
                      .map((x) => BarChartGroupData(
                            x: data.indexOf(x),
                            barRods: [
                              BarChartRodData(
                                toY: voteValue[data.indexOf(x)],
                                color: isTouched.value
                                    ? Colors.grey.shade800
                                    : barColor,
                                width: 45,
                                borderSide: isTouched.value
                                    ? const BorderSide(
                                        color: Colors.white, width: 2)
                                    : const BorderSide(
                                        color: Colors.white, width: 0),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  color: barBackgroundColor,
                                ),
                              ),
                            ],
                          ))
                      .toList();
                }),
                error: (Object error, StackTrace? stackTrace) {},
                loading: () {});
          }
        },
        error: (Object error, StackTrace? stackTrace) {},
        loading: () {});

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 25),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.grey.shade200,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  sectionNames[group.x],
                  const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: (rod.toY.toInt() - 1).toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex.value = -1;
                return;
              }
              touchedIndex.value = barTouchResponse.spot!.touchedBarGroupIndex;
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        Text(
                          sectionNames[value.toInt()],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(voteValue[value.toInt()] /
                                      voteValue
                                          .reduce((a, b) => a + b)
                                          .toInt() *
                                      100)
                                  .toStringAsFixed(2)}%',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                reservedSize: 50,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: pretendanceBars,
        ),
        swapAnimationDuration: animDuration,
      ),
    );
  }
}
