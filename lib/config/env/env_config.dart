import 'package:nkm_admin_panel/api/dio_client.dart';

enum EnvTypeEnum { dev, prod }

class EnvConfig {
  final EnvTypeEnum envType;
  final String appName;
  final String baseUrl;

  static EnvConfig? _instance;

  EnvConfig._({
    this.envType = EnvTypeEnum.dev,
    this.appName = "NKM Admin Panel",
    this.baseUrl = "http://3.6.39.35/api/",
  });

  factory EnvConfig({
    EnvTypeEnum? envType,
    String? appName,
    String? baseUrl,
  }) {
    _instance ??= EnvConfig._(
      envType: envType!,
      appName: appName!,
      baseUrl: baseUrl!,
    );
    return _instance!;
  }

  static EnvConfig get instance {
    DioClient dioClient = DioClient();
    return _instance!;
  }
}
