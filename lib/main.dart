import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:stopwatchdemo/providers/log_provider.dart';
import 'package:stopwatchdemo/model/log_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ja');

    return MaterialApp(
      home: ChangeNotifierProvider<LogProvider>(
        create: (context) => LogProvider(),
        child: _ChildContent()
      )
    );
  }
}

class _ChildContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = context.select((LogProvider provider) => provider.list);
    bool doing = context.select((LogProvider provider) => provider.doing);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '計測サンプル',
            textAlign: TextAlign.center
          )
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          _startOrStopButton(context, doing),
          _listView(list),
          _graphView(list)
        ],
      ),
    );
  }

  RaisedButton _startOrStopButton(BuildContext context, bool doing) {
    if (doing) {
      return RaisedButton(
        child: Text('終了'),
        onPressed: () {
          context.read<LogProvider>().stop();
        }
      );
    }
  
    return RaisedButton(
      child: Text('開始'),
      onPressed: () {
        context.read<LogProvider>().start(35.681236, 139.767125);
      }
    );
  }

  Widget _listView(List<LogModel> list) {
    return Container(
      height: 150,
      child: ListView.builder(
        itemCount: min(list.length, 3),
        itemBuilder: (context, index) {
          final item = list[index];
          final formatter = new DateFormat('yyyy/MM/dd HH:mm:ss', 'ja_JP');
          final start = formatter.format(item.startDt);
          final end = formatter.format(item.endDt);
          return ListTile(
            title: Text("$start - $end"),
          );
        }
      )
    );
  }

  Widget _graphView(List<LogModel> list) {
    final barData = list.map((e) {
      final duration = e.endDt.difference(e.startDt).inSeconds;
      return BarChartGroupData(
        x: e.id,
        barRods: [BarChartRodData(y: duration.toDouble(), color: Colors.lightBlueAccent)],
        showingTooltipIndicators: [0]
      );
    }).toList();

    return Container(
      height: 250,
      padding: EdgeInsets.only(
        top: 32,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              )
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                textStyle: TextStyle(
                    color: const Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  return value.toString();
                }
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: barData
          )
        )
      )
    );
  }
}
