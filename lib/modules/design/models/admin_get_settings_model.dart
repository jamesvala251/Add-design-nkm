class AdminGetSettingsModel {
  late Data _data;
  late String _message;
  late bool _success;
  late int _statusCode;

  Data get data => _data;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  AdminGetSettingsModel.fromJson(Map<String, dynamic> json) {
    _data = Data.fromJson(json['data']);
    _message = json['message'] ?? 'msg key null on admin get settings!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}

class Data {
  late String _designWeightUnit;

  String get designWeightUnit => _designWeightUnit;

  Data.fromJson(Map<String, dynamic> json) {
    _designWeightUnit = json['design_weight_unit'] ?? '-';
  }
}
