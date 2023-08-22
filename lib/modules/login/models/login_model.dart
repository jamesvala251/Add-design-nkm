class LoginModel {
  late String _token;
  late String _message;
  late bool _success;
  late int _statusCode;

  String get token => _token;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  LoginModel.fromJson(Map<String, dynamic> json) {
    _token = json['token'] ?? '';
    _message = json['message'] ?? 'msg key null on admin login api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}
