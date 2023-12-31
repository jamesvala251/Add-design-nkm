class CommonConstants {
  static const Map<String, String> xWwwFromUrlEncodedHeader = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static const Map<String, String> applicationJsonHeader = {
    'Content-Type': 'application/json'
  };

  static const Map<String, String> multipartFormDataHeader = {
    'Content-Type': 'multipart/form-data'
  };

  static const int connectionTimeOutInMilliseconds = 180000;
  static const int receiveTimeOutInMilliseconds = 180000;
  static const int errorMilliseconds = 1000;
  static const int errorLongMilliseconds = 3000;

  static const String regular = "proxima_nova_regular";
  static const String bold = "proxima_nova_bold";
  static const String thin = "proxima_nova_thin";

  //TODO For Video and Image Upload Size
  static const int capturedImageQuality = 60;
  static const int pickedImageQuality = 70;

  static const double imageUploadSizeInMb = 10;

  //Theme Constants
  static const int lightThemeFlag = 1;
  static const int darkThemeFlag = 2;
  static const int autoThemeFlag = 3;

  //For Method Channel
  static const String getAndroidVersionMethod = "getAndroidVersion";
  static const String getVersionNameAndVersionCodeMethod =
      "getVersionNameAndVersionCode";
  static const String nkmAdminPanelMethodChannel =
      "com.org.nkm_admin_panel/common_channel";
  static const String nkmNosePinsLLPFolderName =
      'nkm_admin_panel_order_invoice';
  static const String nativeDataMapKeyVersionName = "version_name";
  static const String nativeDataMapKeyVersionCode = "version_code";
  static const String nativeDataMapKeyPackageName = "package_name";

  //Login Type
  static const int loginTypeUser = 1;
  static const int loginTypeAdmin = 2;
  static const int appUpdateSeverityForceUpdate = 1;
  static const int appUpdateSeverityOptionUpdate = 2;

  //Firebase Dynamic Link Keys
  static const String goldKaratDynamicLinkKey = 'gold_karat';
  static const String screenNameDynamicLinkKey = 'product_details_screen';
  static const String dashboardControllerTag = 'dashboard_controller_tag';

  //add design
  static const String selectSupplier = 'Select Supplier';
  static const String selectCategory = 'Select Category';
  static const String selectSubCategory = 'Select Sub-Category';
  static const String selectGoldCaret = 'Select Gold Caret';

  static const int maxCaretQuantity = 7;
}
