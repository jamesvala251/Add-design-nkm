import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart'
    as design_list_model;
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class FilterDesignController extends GetxController {
  late RxString designName = ''.obs;
  late RxInt articleNo = (-1).obs;

  //for category
  late RxInt selectedCategoryId = (-1).obs;
  late String selectedCategoryName = '';

  //for sub-category
  late RxInt selectedSubCategoryId = (-1).obs;
  late String selectedSubCategoryName = '';

  final RxBool isFilterApplied = false.obs;

  final RxBool isLoadingDesignList = true.obs;
  final RxString errorStringDesignList = ''.obs;
  final RxList<design_list_model.Data> designList =
      RxList<design_list_model.Data>([]);
  final RxInt pageNo = 1.obs;

  final RxBool isLoadingNextPage = false.obs;
  final RxString errorWhileLoadingNextPage = ''.obs;
  final RxBool hasMorePage = true.obs;

  void getDesignListApiCall() async {
    try {
      pageNo.value = 1;
      designList.clear();
      isLoadingDesignList.value = true;
      errorStringDesignList.value = '';
      design_list_model.DesignModel tempSubCategoryDesignListModel =
          await ApiImplementer.getDesignListByFilterApiCall(
        pageNo: pageNo.value,
        name: designName.value,
        articleNo: articleNo.value,
        categoryId: selectedCategoryId.value,
        subCategoryId: selectedSubCategoryId.value,
      );
      if (tempSubCategoryDesignListModel.success) {
        isLoadingDesignList.value = false;
        designList.value = tempSubCategoryDesignListModel.data;
        errorStringDesignList.value = '';
        return;
      }
      isLoadingDesignList.value = false;
      errorStringDesignList.value = tempSubCategoryDesignListModel.message;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingDesignList.value = false;
      errorStringDesignList.value = errMsg;
      return;
    } catch (error) {
      isLoadingDesignList.value = false;
      errorStringDesignList.value = error.toString();
      return;
    }
  }

  void loadNextDesignListPage() async {
    try {
      pageNo.value++;
      isLoadingNextPage.value = true;
      errorWhileLoadingNextPage.value = '';
      hasMorePage.value = true;
      design_list_model.DesignModel tempSubCateDesignListModel =
          await ApiImplementer.getDesignListByFilterApiCall(
        pageNo: pageNo.value,
        name: designName.value,
        articleNo: articleNo.value,
        categoryId: selectedCategoryId.value,
        subCategoryId: selectedSubCategoryId.value,
      );
      if (tempSubCateDesignListModel.success) {
        if (tempSubCateDesignListModel.data.isEmpty) {
          isLoadingNextPage.value = false;
          errorWhileLoadingNextPage.value = '';
          hasMorePage.value = false;
          return;
        }
        designList.addAll(tempSubCateDesignListModel.data);
        isLoadingNextPage.value = false;
        errorWhileLoadingNextPage.value = '';
        hasMorePage.value = true;
        return;
      }
      isLoadingNextPage.value = false;
      errorWhileLoadingNextPage.value = tempSubCateDesignListModel.message;
      hasMorePage.value = true;
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      isLoadingNextPage.value = false;
      errorWhileLoadingNextPage.value = errMsg;
      hasMorePage.value = true;
      return;
    } catch (error) {
      isLoadingNextPage.value = false;
      errorWhileLoadingNextPage.value = error.toString();
      hasMorePage.value = true;
      return;
    }
  }

  Future<void> refreshDesignListApiCall() async {
    try {
      pageNo.value = 1;
      isLoadingNextPage.value = false;
      errorWhileLoadingNextPage.value = '';
      hasMorePage.value = true;
      design_list_model.DesignModel tempSubCategoryDesignListModel =
          await ApiImplementer.getDesignListByFilterApiCall(
        pageNo: pageNo.value,
        name: designName.value,
        articleNo: articleNo.value,
        categoryId: selectedCategoryId.value,
        subCategoryId: selectedSubCategoryId.value,
      );
      if (tempSubCategoryDesignListModel.success &&
          tempSubCategoryDesignListModel.data.isNotEmpty) {
        designList.value = tempSubCategoryDesignListModel.data;
        return;
      }
      UiUtils.errorSnackBar(message: tempSubCategoryDesignListModel.message);
      return;
    } on DioException catch (dioError) {
      String errMsg = Helper.getErrMsgFromDioError(
        dioError: dioError,
      );
      UiUtils.errorSnackBar(message: errMsg);
      return;
    } catch (error) {
      UiUtils.errorSnackBar(message: error.toString());
      return;
    }
  }

  void removeParticularFilter({
    bool designNameArg = false,
    bool articleNoArg = false,
    categoryArg = false,
    subCateArg = false,
  }) {
    if (designNameArg) {
      designName.value = '';
      if (articleNo.value == -1 &&
          selectedCategoryId.value == -1 &&
          selectedSubCategoryId.value == -1) {
        isFilterApplied.value = false;
      }
      getDesignListApiCall();
      return;
    }

    if (articleNoArg) {
      articleNo.value = -1;
      if (designName.value.isEmpty &&
          selectedCategoryId.value == -1 &&
          selectedSubCategoryId.value == -1) {
        isFilterApplied.value = false;
      }
      getDesignListApiCall();
      return;
    }

    if (categoryArg) {
      selectedCategoryId.value = -1;
      selectedCategoryName = '';

      if (designName.value.isEmpty &&
          articleNo.value == -1 &&
          selectedSubCategoryId.value == -1) {
        isFilterApplied.value = false;
      }
      getDesignListApiCall();
      return;
    }

    if (subCateArg) {
      selectedSubCategoryId.value = -1;
      selectedSubCategoryName = '';

      if (designName.value.isEmpty &&
          articleNo.value == -1 &&
          selectedCategoryId.value == -1) {
        isFilterApplied.value = false;
      }
      getDesignListApiCall();
      return;
    }
  }

  void clearFilter() {
    isFilterApplied.value = false;
    designName.value = '';
    articleNo.value = -1;
    selectedCategoryId.value = -1;
    selectedCategoryName = '';
    selectedSubCategoryId.value = -1;
    selectedSubCategoryName = '';
  }
}
