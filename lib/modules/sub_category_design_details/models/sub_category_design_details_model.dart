class SubCategoryDesignDetailsModel {
  late Data _data;
  late String _message;
  late bool _success;
  late int _statusCode;

  Data get data => _data;

  String get message => _message;

  bool get success => _success;

  int get statusCode => _statusCode;

  SubCategoryDesignDetailsModel.fromJson(Map<String, dynamic> json) {
    _data = Data.fromJson(json['data']);
    _message = json['message'] ?? 'msg design details api!';
    _success = json['success'] ?? false;
    _statusCode = json['status_code'] ?? -1;
  }
}

class Data {
  late int _id;
  late String _name;
  late String _supplierName;
  late String _weight;
  late String _category;
  late String _subCategory;
  late String _goldColor;
  late String _gender;
  late String _dealerCommission;
  late String _semiDealerCommission;
  late String _shopkeeperCommission;
  late String _articleSeries;
  late List<String> _images;
  late List<String> _videos;

  int get id => _id;

  String get name => _name;

  String get supplierName => _supplierName;

  String get weight => _weight;

  String get category => _category;

  String get subCategory => _subCategory;

  String get goldColor => _goldColor;

  String get gender => _gender;

  String get dealerCommission => _dealerCommission;

  String get semiDealerCommission => _semiDealerCommission;

  String get shopkeeperCommission => _shopkeeperCommission;

  String get articleSeries => _articleSeries;

  List<String> get images => _images;

  List<String> get videos => _videos;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'] ?? '';
    _supplierName = json['supplier_name'] ?? '';
    _weight = json['weight'] ?? '';
    _category = json['category'] ?? '';
    _subCategory = json['sub_category'] ?? '';
    _goldColor = json['gold_color'] ?? '';
    _gender = json['gender'] ?? '';
    _dealerCommission = json['dealer_commission'] ?? '';
    _semiDealerCommission = json['semi_dealer_commission'] ?? '';
    _shopkeeperCommission = json['shopkeeper_commission'] ?? '';
    _articleSeries = json['article_series'] ?? '';

    _images = <String>[];
    if (json['images'] != null) {
      _images = json['images'].cast<String>();
    }
    _videos = <String>[];
    if (json['videos'] != null) {
      _videos = json['videos'].cast<String>();
    }
  }
}
