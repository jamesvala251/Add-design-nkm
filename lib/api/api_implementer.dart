import 'package:dio/dio.dart';
import 'package:nkm_admin_panel/api/auth_token_dio_client.dart';
import 'package:nkm_admin_panel/api/dio_client.dart';
import 'package:nkm_admin_panel/constants/common_constants.dart';
import 'package:nkm_admin_panel/modules/add_design/models/hallmark_text_filed_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/weights_text_field_model.dart';
import 'package:nkm_admin_panel/modules/design/models/admin_get_settings_model.dart';
import 'package:nkm_admin_panel/modules/design/models/category_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_image_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_model.dart';
import 'package:nkm_admin_panel/modules/add_design/models/create_design_video_model.dart';
import 'package:nkm_admin_panel/modules/design/models/get_gold_caret_model.dart';
import 'package:nkm_admin_panel/modules/design/models/get_supplier_name_model.dart';
import 'package:nkm_admin_panel/modules/design/models/delete_design_model.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart';
import 'package:nkm_admin_panel/modules/design/models/sub_category_model.dart';
import 'package:nkm_admin_panel/modules/login/models/login_model.dart';
import 'package:nkm_admin_panel/modules/login/models/logout_model.dart';
import 'package:nkm_admin_panel/modules/sub_category_design_details/models/sub_category_design_details_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/delete_media_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_hallmark_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_image_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_video_model.dart';
import 'package:nkm_admin_panel/modules/update_design/models/update_design_weight_model.dart';

class ApiImplementer {
  static const String _designRoutePrefix = 'design';

  static Future<LoginModel> loginApiCall({
    required String emailId,
    required String password,
  }) async {
    try {
      final response = await DioClient.getDioClient()!.post(
        '$_designRoutePrefix/login',
        data: {
          "email": emailId,
          "password": password,
        },
        options: Options(
          headers: CommonConstants.applicationJsonHeader,
        ),
      );
      return LoginModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<LogoutModel> logoutApiCall() async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        '$_designRoutePrefix/logout',
      );
      return LogoutModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<CategoryModel> getCategoryApiCall() async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        'category',
      );
      return CategoryModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<SubCategoryModel> getSubCategoryApiCall({
    required int categoryId,
  }) async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        'sub-category',
        queryParameters: {
          "category_id": categoryId,
        },
      );
      return SubCategoryModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<CreateDesignModel> createDesignApiCall({
    required int supplierId,
    required int categoryId,
    required int subCategoryId,
    required String designName,
    required String productWeight,
    required String dealerCommission,
    required String semiDealerCommission,
    required String shopkeeperCommission,
    required int caret,
    required String quantity,
    required List<WeightsTextFieldModel> weightList,
    required List<HallmarkTextFiledModel> hallmarkList,
    required List<CreateDesignImageModel> createDesignImageModelList,
    List<CreateDesignVideoModel>? createDesignVideoModelList,
  }) async {
    try {
      Map<String, dynamic> requestJson = {
        'name': designName,
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'dealer_commission': dealerCommission,
        'semi_dealer_commission': semiDealerCommission,
        'shopkeeper_commission': shopkeeperCommission,
        'product_weight': productWeight,
        'supplier_id': supplierId,
        'gold_carets[0][caret]': caret,
        'gold_carets[0][qty]': quantity,
      };

      for (int index = 0; index < weightList.length; index++) {
        requestJson.putIfAbsent(
          'gold_carets[0][weight][$index]',
          () => weightList[index].weight.value,
        );
      }

      for (int index = 0; index < hallmarkList.length; index++) {
        requestJson.putIfAbsent(
          'gold_carets[0][hallmark][$index]',
              () => hallmarkList[index].hallmark.value,
        );
      }

      FormData formData = FormData.fromMap(requestJson);

      for (var element in createDesignImageModelList) {
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(element.imgPath),
        ));
      }

      if (createDesignVideoModelList != null) {
        formData.files.add(MapEntry(
          'videos[]',
          await MultipartFile.fromFile(
              createDesignVideoModelList.first.videoPath),
        ));
      }

      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.post(
        '$_designRoutePrefix/create',
        data: formData,
        options: Options(
          headers: CommonConstants.multipartFormDataHeader,
        ),
      );
      return CreateDesignModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<UpdateDesignModel> updateDesignApiCall({
    required int designId,
    required int supplierId,
    required int categoryId,
    required int subCategoryId,
    required String designName,
    required List<UpdateDesignWeightModel> productWeightModelList,
    required List<UpdateDesignHallmarkModel> updateDesignHallmarkModelList,
    required String dealerCommission,
    required String semiDealerCommission,
    required String shopkeeperCommission,
    List<UpdateDesignImageModel> updateDesignImageModelList = const [],
    List<UpdateDesignVideoModel> updateDesignVideoModelList = const [],
  }) async {
    try {
      Map<String, dynamic> requestJson = {
        'id': designId,
        'name': designName,
        'category_id': categoryId,
        'sub_category_id': subCategoryId,
        'dealer_commission': dealerCommission,
        'semi_dealer_commission': semiDealerCommission,
        'shopkeeper_commission': shopkeeperCommission,
        'supplier_id': supplierId,
      };

      for (int index = 0; index < productWeightModelList.length; index++) {
        requestJson.putIfAbsent(
          'design_weight[$index][id]',
          () => productWeightModelList[index].id,
        );
        requestJson.putIfAbsent(
          'design_weight[$index][weight]',
          () => productWeightModelList[index].weight.value,
        );
      }

      for (int index = 0; index < updateDesignHallmarkModelList.length; index++) {
        requestJson.putIfAbsent(
          'design_weight[$index][hallmark]',
              () => updateDesignHallmarkModelList[index].hallmark.value,
        );
      }

      FormData formData = FormData.fromMap(requestJson);

      for (var element in updateDesignImageModelList) {
        formData.files.add(MapEntry(
          'images[]',
          await MultipartFile.fromFile(element.imgPath),
        ));
      }

      if (updateDesignVideoModelList.isNotEmpty) {
        formData.files.add(MapEntry(
          'videos[]',
          await MultipartFile.fromFile(
              updateDesignVideoModelList.first.videoPath),
        ));
      }

      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.post(
        '$_designRoutePrefix/update',
        data: formData,
        options: Options(
          headers: CommonConstants.multipartFormDataHeader,
        ),
      );
      return UpdateDesignModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<DesignModel> getDesignListApiCall({
    required int pageNo,
  }) async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        'design',
        queryParameters: {
          "page": pageNo,
        },
      );
      return DesignModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<DesignModel> getDesignListByFilterApiCall({
    required int pageNo,
    required String name,
    required int articleNo,
    required int categoryId,
    required int subCategoryId,
  }) async {
    try {
      Map<String, dynamic> requestJson = {
        "page": pageNo,
      };

      if (name.trim().isNotEmpty) {
        requestJson.putIfAbsent('name', () => name);
      }

      if (articleNo != -1) {
        requestJson.putIfAbsent('article_no', () => articleNo);
      }

      if (categoryId != -1) {
        requestJson.putIfAbsent('category', () => categoryId);
      }

      if (subCategoryId != -1) {
        requestJson.putIfAbsent('sub_category', () => subCategoryId);
      }

      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        'design',
        queryParameters: requestJson,
      );
      return DesignModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<DeleteDesignModel> deleteDesignApiCall({
    required int designId,
  }) async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.delete(
        '$_designRoutePrefix/delete/$designId',
      );
      return DeleteDesignModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<DeleteMediaModel> deleteMediaApiCall({
    required int mediaId,
  }) async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.delete(
        '$_designRoutePrefix/delete/media/$mediaId',
      );
      return DeleteMediaModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<SubCategoryDesignDetailsModel>
      getSubCategoryDesignDetailsApiCall({
    required int productId,
  }) async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        '$_designRoutePrefix/detail',
        queryParameters: {
          "product_id": productId,
        },
      );
      return SubCategoryDesignDetailsModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetGoldCaretModel> getGoldCaretApiCall() async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        '$_designRoutePrefix/gold-caret',
      );
      return GetGoldCaretModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<GetSupplierNameModel> getSuppliersNameApiCall() async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        '$_designRoutePrefix/supplier',
      );
      return GetSupplierNameModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  static Future<AdminGetSettingsModel> getAdminSettingsApiCall() async {
    try {
      final response = await AuthTokenDioClient.getAuthTokenDioClient()!.get(
        '$_designRoutePrefix/get-settings',
      );
      return AdminGetSettingsModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
}
