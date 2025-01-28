import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/modules/design/controllers/design_list_controller.dart';
import 'package:nkm_admin_panel/modules/design/models/delete_design_model.dart';
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/ui/app_dialogs.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class DesignModel {
  late String message;
  late bool success;
  late int statusCode;
  late List<Data> data;

  DesignModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? 'msg key null on design api!';
    success = json['success'] ?? false;
    statusCode = json['status_code'] ?? -1;
    data = <Data>[];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  late int id;
  late String name;
  late Supplier supplier;
  late Category category;
  late SubCategory subCategory;
  late String dealerCommission;
  late String semiDealerCommission;
  late String shopkeeperCommission;
  late List<GoldCaret> goldCaret;
  late String articleSeries;
  late RxList<Images> images = RxList<Images>([]);
  late RxList<Videos> videos = RxList<Videos>([]);
  late RxBool isDeleting = false.obs;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    supplier = Supplier.fromJson(json['supplier']);
    category = Category.fromJson(json['category']);
    subCategory = SubCategory.fromJson(json['sub_category']);
    dealerCommission = json['dealer_commission'] ?? "";
    semiDealerCommission = json['semi_dealer_commission'] ?? "";
    shopkeeperCommission = json['shopkeeper_commission'] ?? "";
    goldCaret = <GoldCaret>[];
    if (json['gold_caret'] != null) {
      json['gold_caret'].forEach((v) {
        goldCaret.add(GoldCaret.fromJson(v));
      });
    }

    articleSeries = json['article_series'] ?? "";

    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }

    if (json['videos'] != null) {
      json['videos'].forEach((v) {
        videos.add(Videos.fromJson(v));
      });
    }
  }

  void deleteDesignApiCall({required int index}) async {
    try {
      isDeleting.value = true;
      DeleteDesignModel deleteDesignModel =
          await ApiImplementer.deleteDesignApiCall(designId: id);
      if (deleteDesignModel.success) {
        DesignListController designListController =
            Get.find<DesignListController>();
        designListController.designList.removeAt(index);
        if (designListController.designList.length <= 12) {
          designListController.refreshOnlyFirstPageAfterDeleteApiCall();
        }
        UiUtils.successSnackBar(message: deleteDesignModel.message);
        return;
      }
      isDeleting.value = false;
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        title: 'err_occurred'.tr,
        description: deleteDesignModel.message,
        onOkBntClick: () => Get.back(),
      );
      return;
    } on DioException catch (dioError) {
      isDeleting.value = false;
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        title: 'err_occurred'.tr,
        description: errMsg,
        onOkBntClick: () => Get.back(),
      );
      return;
    } catch (error) {
      AppDialogs.showInformationDialogue(
        context: Get.context!,
        title: 'err_occurred'.tr,
        description: error.toString(),
        onOkBntClick: () => Get.back(),
      );
      isDeleting.value = false;
      return;
    }
  }
}

class Supplier {
  late int _id;
  late String _name;

  int get id => _id;

  String get name => _name;

  Supplier.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'] ?? '';
  }
}

class Category {
  late int _id;
  late String _name;

  int get id => _id;

  String get name => _name;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'] ?? '';
  }
}

class SubCategory {
  late int _id;
  late String _name;

  int get id => _id;

  String get name => _name;

  SubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'] ?? '';
  }
}

class GoldCaret {
  late String _caret;
  late int _qty;
  late List<DesignWeight> _designWeight;
  late String _articalFrom;
  late String _articalTo;

  String get caret => _caret;

  int get qty => _qty;

  List<DesignWeight> get designWeight => _designWeight;

  String get articalFrom => _articalFrom;

  String get articalTo => _articalTo;

  GoldCaret.fromJson(Map<String, dynamic> json) {
    _caret = json['caret'] ?? '';
    _qty = json['qty'] ?? -1;
    _designWeight = <DesignWeight>[];
    if (json['design_weight'] != null) {
      json['design_weight'].forEach((v) {
        _designWeight.add(DesignWeight.fromJson(v));
      });
    }
    _articalFrom = json['artical_from'] ?? '';
    _articalTo = json['artical_to'] ?? '';
  }
}

class Images {
  late int id;
  late String url;

  Images({required this.id, required this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'] ?? '';
  }
}

class Videos {
  late int id;
  late String url;

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'] ?? '';
  }
}

class DesignWeight {
  late int _id;
  late int _weight;
  late String _hallmark;
  late String _articleNumber;

  int get id => _id;

  int get weight => _weight;

  String get hallmark => _hallmark;

  String get articleNumber => _articleNumber;

  DesignWeight.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _weight = json['weight'] ?? 0;
    _hallmark = json['hallmark_number'] ?? '';
    _articleNumber = json['article_number'] ?? '';
  }
}
