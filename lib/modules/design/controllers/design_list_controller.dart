import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nkm_admin_panel/api/api_implementer.dart';
import 'package:nkm_admin_panel/modules/design/models/design_list_model.dart'
    as design_list_model;
import 'package:nkm_admin_panel/utils/helpers/helper.dart';
import 'package:nkm_admin_panel/utils/ui/ui_utils.dart';

class DesignListController extends GetxController {
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
          await ApiImplementer.getDesignListApiCall(
        pageNo: pageNo.value,
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
          await ApiImplementer.getDesignListApiCall(
        pageNo: pageNo.value,
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
          await ApiImplementer.getDesignListApiCall(
        pageNo: pageNo.value,
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

  Future<void> refreshOnlyFirstPageAfterDeleteApiCall() async {
    try {
      design_list_model.DesignModel tempNewOn1PageDesignListModel =
          await ApiImplementer.getDesignListApiCall(
        pageNo: 1,
      );
      if (tempNewOn1PageDesignListModel.success &&
          tempNewOn1PageDesignListModel.data.isNotEmpty) {
        for (var item in tempNewOn1PageDesignListModel.data) {
          if (designList.firstWhereOrNull((element) => element.id == item.id) ==
              null) {
            designList.insert(0, item);
          }
        }
        return;
      }
      UiUtils.errorSnackBar(message: tempNewOn1PageDesignListModel.message);
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
}
