class GetGoldCaretModel {
 late List<Data> _data;
 late String _message;
 late bool _success;
 late int _statusCode;

  List<Data> get data => _data;
  String get message => _message;
  bool get success => _success;
  int get statusCode => _statusCode;

  GetGoldCaretModel.fromJson(Map<String, dynamic> json) {
      _data = <Data>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
    _message = json['message'] ?? 'msg key null on get gold caret api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}

class Data {
  late int _caret;
  late String _label;

  int get caret => _caret;
  String get label => _label;

  Data.fromJson(Map<String, dynamic> json) {
    _caret = json['caret'] ?? 0;
    _label = json['label'] ?? '';
  }
}
