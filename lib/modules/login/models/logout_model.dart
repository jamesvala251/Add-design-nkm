class LogoutModel {
  late String _message;
  late bool _success;
  late int _statusCode;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  LogoutModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'] ?? 'msg key null on admin logout api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}
