import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _startOrStopButton(context, doing),
            _listView(list),
          ],
        ),
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

  Expanded _listView(List<LogModel> list) {
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
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
}
