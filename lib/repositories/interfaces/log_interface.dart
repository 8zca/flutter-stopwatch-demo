
import 'package:stopwatchdemo/model/log_model.dart';
abstract class ILogRepository {
  Future<int> insert(LogModel row);
  Future<int> update(LogModel row);
  Future<int> delete(int id);

  Future<LogModel> findById(int id);
  Future<List<LogModel>> findByDateRange(DateTime from, DateTime to);
  Future<List<LogModel>> findAll();
}
