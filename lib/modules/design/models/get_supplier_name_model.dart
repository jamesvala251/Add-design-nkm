class GetSupplierNameModel {
  late List<Data> _data;
  late String _message;
  late bool _success;
  late int _statusCode;

  List<Data> get data => _data;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  GetSupplierNameModel.fromJson(Map<String, dynamic> json) {
    _data = <Data>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
    _message = json['message'] ?? 'msg key null on supplier!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}

class Data {
  late int _id;
  late String _name;

  int get id => _id;

  String get name => _name;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'] ?? '';
  }
}
