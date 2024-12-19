import '../wrappers/platform_wrapper.dart';

String adUnitId({
  required String androidTestId,
  required String iosTestId,
  required String androidRealId,
  required String iosRealId,
}) {
  return PlatformWrapper.get.isDebug
      ? PlatformWrapper.get.isAndroid
          ? androidTestId
          : iosTestId
      : PlatformWrapper.get.isAndroid
          ? androidRealId
          : iosRealId;
}
