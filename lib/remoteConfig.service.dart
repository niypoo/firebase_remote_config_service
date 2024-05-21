import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

class RemoteConfigService extends GetxService {
  static RemoteConfigService get to => Get.find();

  // parameters
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  // Service int
  Future<RemoteConfigService> init({
    required Map<String, dynamic> defaultParameters,
  }) async {
    // configuration
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(days: 1),
      ),
    );

    // set default
    await remoteConfig.setDefaults(defaultParameters);

    fetchAndActivate();

    return this;
  }

  // get activated value
  bool getValue(String key) => remoteConfig.getBool(key);
  double getDouble(String key) => remoteConfig.getDouble(key);
  int getInt(String key) => remoteConfig.getInt(key);
  String getString(String key) => remoteConfig.getString(key);

  // methods
  Future<void> fetch() async => await remoteConfig.fetch();
  Future<bool> activate() async => await remoteConfig.activate();
  Future<bool> fetchAndActivate() async =>
      await remoteConfig.fetchAndActivate();

  // listen
  listen({Function? callback}) {
    remoteConfig.onConfigUpdated.listen((event) {
      activate();
      if (callback != null) callback();
    });
  }
}
