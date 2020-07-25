/// ログモデル(DTO)
class LogModel {
  final int id;
  final DateTime startDt;
  final DateTime endDt;

  LogModel({
    this.id,
    this.startDt,
    this.endDt,
  });

  factory LogModel.fromMap(Map<String, dynamic> map) {
    final startDt = map['start_dt'] == null ? null : DateTime.parse(map['start_dt']).toLocal();
    final endDt = map['end_dt'] == null ? null : DateTime.parse(map['end_dt']).toLocal();

    return LogModel(
      id: map['id'],
      startDt: startDt,
      endDt: endDt,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
    };
    if (startDt != null) map['start_dt'] = startDt.toUtc().toString();
    if (endDt != null) map['end_dt'] = endDt.toUtc().toString();

    map.removeWhere((key, value) => value == null);

    return map;
  }
}
