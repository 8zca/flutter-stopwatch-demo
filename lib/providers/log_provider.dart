import 'package:flutter/material.dart';
import 'package:stopwatchdemo/model/log_model.dart';
import 'package:stopwatchdemo/repositories/log_repository.dart';

class LogProvider extends ChangeNotifier {
  int currentId;
  bool doing = false;
  List<LogModel> list = [];
  final _repository = LogRepository();

  LogProvider() {
    getLogs();
  }

  getLogs() async {
    list = await _repository.findAll();
    notifyListeners();
  }

  start(double lat, double lon) async {
    final model = LogModel(startDt: DateTime.now());
    final id = await _repository.insert(model);

    if (id != null) {
      currentId = id;
      doing = true;
      notifyListeners();
    }
  }

  stop() async {
    final model = LogModel(id: currentId, endDt: DateTime.now());
    final id = await _repository.update(model);

    if (id != null) {
      doing = false;
      list.add(await _repository.findById(currentId));
      notifyListeners();
    }
  }
}
