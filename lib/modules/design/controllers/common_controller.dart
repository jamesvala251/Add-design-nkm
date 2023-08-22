import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/modules/design/models/admin_get_settings_model.dart';
import 'package:nkm_admin_panel/modules/design/models/sub_category_model.dart'
    as sub_cate_model;
import 'package:nkm_admin_panel/modules/design/models/get_gold_caret_model.dart'
    as gold_caret_model;
import 'package:nkm_admin_panel/modules/design/models/get_supplier_name_model.dart'
    as supplier_model;
import 'package:nkm_admin_panel/modules/design/models/category_model.dart'
    as cate_model;
import 'package:nkm_admin_panel/utils/helpers/helper.dart';

class CommonController extends GetxController {
  AdminGetSettingsModel? adminGetSettingsModel;
  final RxBool isLoadingAdminSettings = true.obs;
  final RxString errorStringAdminSettings = ''.obs;

  //for supplier
  final RxList<supplier_model.Data> supplierList =
      RxList<supplier_model.Data>([]);
  final RxBool isLoadingSupplier = true.obs;
  final RxString errorStringSupplier = ''.obs;

  //for category
  final RxList<cate_model.Data> categoryList = RxList<cate_model.Data>([]);
  final RxBool isLoadingCategory = true.obs;
  final RxString errorStringCategory = ''.obs;

  //for sub-category
  final RxList<sub_cate_model.Data> subCategoryList =
      RxList<sub_cate_model.Data>([]);
  final RxBool isLoadingSubCategory = true.obs;
  final RxString errorStringSubCategory = ''.obs;

  //for gold caret
  final RxList<gold_caret_model.Data> goldCaretList =
      RxList<gold_caret_model.Data>([]);
  final RxBool isLoadingGoldCaret = true.obs;
  final RxString errorStringGoldCaret = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAdminSettingsApiCall();
    getSuppliersApiCall();
    getCategoryApiCall();
    getGoldCaretApiCall();
  }

  void getAdminSettingsApiCall() async {
    try {
      isLoadingAdminSettings.value = true;
      errorStringAdminSettings.value = '';
      adminGetSettingsModel = await ApiImplementer.getAdminSettingsApiCall();
      if (adminGetSettingsModel!.success) {
        isLoadingAdminSettings.value = false;
        errorStringAdminSettings.value = '';
        return;
      }
      isLoadingAdminSettings.value = false;
      errorStringAdminSettings.value = adminGetSettingsModel!.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingAdminSettings.value = false;
      errorStringAdminSettings.value = errMsg;
      return;
    } catch (error) {
      isLoadingAdminSettings.value = false;
      errorStringAdminSettings.value = error.toString();
      return;
    }
  }

  void getSuppliersApiCall() async {
    try {
      supplierList.clear();
      isLoadingSupplier.value = true;
      errorStringSupplier.value = '';
      supplier_model.GetSupplierNameModel tempSupplierModel =
          await ApiImplementer.getSuppliersNameApiCall();
      if (tempSupplierModel.success) {
        isLoadingSupplier.value = false;
        supplierList.value = tempSupplierModel.data;
        errorStringSupplier.value = '';
        return;
      }
      isLoadingSupplier.value = false;
      errorStringSupplier.value = tempSupplierModel.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingSupplier.value = false;
      errorStringSupplier.value = errMsg;
      return;
    } catch (error) {
      isLoadingSupplier.value = false;
      errorStringSupplier.value = error.toString();
      return;
    }
  }

  void getCategoryApiCall() async {
    try {
      categoryList.clear();
      isLoadingCategory.value = true;
      errorStringCategory.value = '';
      cate_model.CategoryModel tempCategoryModel =
          await ApiImplementer.getCategoryApiCall();
      if (tempCategoryModel.success) {
        isLoadingCategory.value = false;
        categoryList.value = tempCategoryModel.data;
        errorStringCategory.value = '';
        return;
      }
      isLoadingCategory.value = false;
      errorStringCategory.value = tempCategoryModel.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingCategory.value = false;
      errorStringCategory.value = errMsg;
      return;
    } catch (error) {
      isLoadingCategory.value = false;
      errorStringCategory.value = error.toString();
      return;
    }
  }

  void getSubCategoryApiCall({required int categoryId}) async {
    try {
      subCategoryList.clear();
      isLoadingSubCategory.value = true;
      errorStringSubCategory.value = '';
      sub_cate_model.SubCategoryModel tempCategoryModel =
          await ApiImplementer.getSubCategoryApiCall(
        categoryId: categoryId,
      );
      if (tempCategoryModel.success) {
        isLoadingSubCategory.value = false;
        subCategoryList.value = tempCategoryModel.data;
        errorStringSubCategory.value = '';
        return;
      }
      isLoadingSubCategory.value = false;
      errorStringSubCategory.value = tempCategoryModel.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingSubCategory.value = false;
      errorStringSubCategory.value = errMsg;
      return;
    } catch (error) {
      isLoadingSubCategory.value = false;
      errorStringSubCategory.value = error.toString();
      return;
    }
  }

  void getGoldCaretApiCall() async {
    try {
      goldCaretList.clear();
      isLoadingGoldCaret.value = true;
      errorStringGoldCaret.value = '';
      gold_caret_model.GetGoldCaretModel tempCategoryModel =
          await ApiImplementer.getGoldCaretApiCall();
      if (tempCategoryModel.success) {
        isLoadingGoldCaret.value = false;
        goldCaretList.value = tempCategoryModel.data;
        errorStringGoldCaret.value = '';
        return;
      }
      isLoadingGoldCaret.value = false;
      errorStringGoldCaret.value = tempCategoryModel.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingGoldCaret.value = false;
      errorStringGoldCaret.value = errMsg;
      return;
    } catch (error) {
      isLoadingGoldCaret.value = false;
      errorStringGoldCaret.value = error.toString();
      return;
    }
  }
}
