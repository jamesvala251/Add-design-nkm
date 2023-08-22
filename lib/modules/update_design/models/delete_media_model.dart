class DeleteMediaModel {
  late String _message;
  late bool _success;
  late int _statusCode;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  DeleteMediaModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'] ?? 'msg key null on delete media api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}
