class CreateDesignModel {
  late String _message;
  late bool _success;
  late int _statusCode;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  CreateDesignModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'] ?? 'msg key null on create design api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}
