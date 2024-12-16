// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shanYanUIConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShanYanUIConfig _$ShanYanUIConfigFromJson(Map<String, dynamic> json) {
  return ShanYanUIConfig()
    ..ios = ShanYanUIConfigIOS.fromJson(json['ios'] as Map<String, dynamic>)
    ..androidPortrait = ShanYanUIConfigAndroid.fromJson(
        json['androidPortrait'] as Map<String, dynamic>)
    ..androidLandscape = ShanYanUIConfigAndroid.fromJson(
        json['androidLandscape'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ShanYanUIConfigToJson(ShanYanUIConfig instance) =>
    <String, dynamic>{
      'ios': instance.ios.toJson(),
      'androidPortrait': instance.androidPortrait.toJson(),
      'androidLandscape': instance.androidLandscape.toJson(),
    };

ShanYanUIConfigIOS _$ShanYanUIConfigIOSFromJson(Map<String, dynamic> json) {
  return ShanYanUIConfigIOS()
    ..isFinish = json['isFinish'] as bool?
    ..setAuthBGImgPath = json['setAuthBGImgPath'] as String?
    ..setAuthBGVedioPath = json['setAuthBGVedioPath'] as String?
    ..setPreferredStatusBarStyle = _$enumDecodeNullable(
        _$iOSStatusBarStyleEnumMap, json['setPreferredStatusBarStyle'])
    ..setStatusBarHidden = json['setStatusBarHidden'] as bool?
    ..setAuthNavHidden = json['setAuthNavHidden'] as bool?
    ..setNavigationBarStyle = _$enumDecodeNullable(
        _$iOSBarStyleEnumMap, json['setNavigationBarStyle'])
    ..setAuthNavTransparent = json['setAuthNavTransparent'] as bool?
    ..setNavText = json['setNavText'] as String?
    ..setNavTextColor = json['setNavTextColor'] as String?
    ..setNavTextSize = json['setNavTextSize'] as int?
    ..setNavReturnImgPath = json['setNavReturnImgPath'] as String?
    ..setNavReturnImgHidden = json['setNavReturnImgHidden'] as bool?
    ..setBackPressedAvailable = json['setBackPressedAvailable'] as bool?
    ..setFitsSystemWindows = json['setFitsSystemWindows'] as bool?
    ..setNavBackBtnAlimentRight = json['setNavBackBtnAlimentRight'] as bool?
    ..setNavigationBottomLineHidden =
        json['setNavigationBottomLineHidden'] as bool?
    ..setNavigationTintColor = json['setNavigationTintColor'] as String?
    ..setNavigationBarTintColor = json['setNavigationBarTintColor'] as String?
    ..setNavigationBackgroundImage =
        json['setNavigationBackgroundImage'] as String?
    ..setNavigationShadowImage = json['setNavigationShadowImage'] as String?
    ..setLogoImgPath = json['setLogoImgPath'] as String?
    ..setLogoCornerRadius = json['setLogoCornerRadius'] as num?
    ..setLogoHidden = json['setLogoHidden'] as bool?
    ..setNumberColor = json['setNumberColor'] as String?
    ..setNumberSize = json['setNumberSize'] as num?
    ..setNumberBold = json['setNumberBold'] as bool?
    ..setNumberTextAlignment = _$enumDecodeNullable(
        _$iOSTextAlignmentEnumMap, json['setNumberTextAlignment'])
    ..setLogBtnText = json['setLogBtnText'] as String?
    ..setLogBtnTextColor = json['setLogBtnTextColor'] as String?
    ..setLoginBtnTextSize = json['setLoginBtnTextSize'] as num?
    ..setLoginBtnTextBold = json['setLoginBtnTextBold'] as bool?
    ..setLoginBtnBgColor = json['setLoginBtnBgColor'] as String?
    ..setLoginBtnNormalBgImage = json['setLoginBtnNormalBgImage'] as String?
    ..setLoginBtnHightLightBgImage =
        json['setLoginBtnHightLightBgImage'] as String?
    ..setLoginBtnDisabledBgImage = json['setLoginBtnDisabledBgImage'] as String?
    ..setLoginBtnBorderColor = json['setLoginBtnBorderColor'] as String?
    ..setLoginBtnCornerRadius = json['setLoginBtnCornerRadius'] as num?
    ..setLoginBtnBorderWidth = json['setLoginBtnBorderWidth'] as num?
    ..setAppPrivacyColor = (json['setAppPrivacyColor'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setPrivacyTextSize = json['setPrivacyTextSize'] as num?
    ..setPrivacyWidth = json['setPrivacyWidth'] as num?
    ..setPrivacyTextBold = json['setPrivacyTextBold'] as bool?
    ..setAppPrivacyTextAlignment = _$enumDecodeNullable(
        _$iOSTextAlignmentEnumMap, json['setAppPrivacyTextAlignment'])
    ..setPrivacySmhHidden = json['setPrivacySmhHidden'] as bool?
    ..setAppPrivacyLineSpacing = json['setAppPrivacyLineSpacing'] as num?
    ..setAppPrivacyNeedSizeToFit = json['setAppPrivacyNeedSizeToFit'] as bool?
    ..setAppPrivacyAbbreviatedName =
        json['setAppPrivacyAbbreviatedName'] as String?
    ..setAppPrivacyFirst = (json['setAppPrivacyFirst'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setAppPrivacySecond = (json['setAppPrivacySecond'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setAppPrivacyThird = (json['setAppPrivacyThird'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setAppPrivacyNormalDesTextFirst =
        json['setAppPrivacyNormalDesTextFirst'] as String?
    ..setAppPrivacyNormalDesTextSecond =
        json['setAppPrivacyNormalDesTextSecond'] as String?
    ..setAppPrivacyNormalDesTextThird =
        json['setAppPrivacyNormalDesTextThird'] as String?
    ..setAppPrivacyNormalDesTextFourth =
        json['setAppPrivacyNormalDesTextFourth'] as String?
    ..setAppPrivacyNormalDesTextLast =
        json['setAppPrivacyNormalDesTextLast'] as String?
    ..morePrivacy = (json['morePrivacy'] as List<dynamic>?)
        ?.map((e) => ConfigPrivacyBean.fromJson(e as Map<String, dynamic>))
        .toList()
    ..setCheckBoxTipMsg = json['setCheckBoxTipMsg'] as String?
    ..setCheckBoxTipDisable = json['setCheckBoxTipDisable'] as bool?
    ..setOperatorPrivacyAtLast = json['setOperatorPrivacyAtLast'] as bool?
    ..setPrivacyActivityEnabled = json['setPrivacyActivityEnabled'] as bool?
    ..setPrivacyGravityHorizontalCenter =
        json['setPrivacyGravityHorizontalCenter'] as bool?
    ..setPrivacyNavTextColor = json['setPrivacyNavTextColor'] as String?
    ..setPrivacyNavTextSize = json['setPrivacyNavTextSize'] as num?
    ..setPrivacyNavReturnImgPath = json['setPrivacyNavReturnImgPath'] as String?
    ..setAppPrivacyWebPreferredStatusBarStyle = _$enumDecodeNullable(
        _$iOSStatusBarStyleEnumMap,
        json['setAppPrivacyWebPreferredStatusBarStyle'])
    ..setAppPrivacyWebNavigationBarStyle = _$enumDecodeNullable(
        _$iOSBarStyleEnumMap, json['setAppPrivacyWebNavigationBarStyle'])
    ..setAppPrivacyWebNavigationTintColor =
        json['setAppPrivacyWebNavigationTintColor'] as String?
    ..setAppPrivacyWebNavigationBarTintColor =
        json['setAppPrivacyWebNavigationBarTintColor'] as String?
    ..setAppPrivacyWebNavigationBackgroundImage =
        json['setAppPrivacyWebNavigationBackgroundImage'] as String?
    ..setAppPrivacyWebNavigationShadowImage =
        json['setAppPrivacyWebNavigationShadowImage'] as String?
    ..setSloganTextSize = json['setSloganTextSize'] as num?
    ..setSloganTextBold = json['setSloganTextBold'] as bool?
    ..setSloganTextColor = json['setSloganTextColor'] as String?
    ..setSloganTextAlignment = _$enumDecodeNullable(
        _$iOSTextAlignmentEnumMap, json['setSloganTextAlignment'])
    ..setSloganTextHidden = json['setSloganTextHidden'] as bool?
    ..setShanYanSloganTextSize = json['setShanYanSloganTextSize'] as num?
    ..setShanYanSloganTextBold = json['setShanYanSloganTextBold'] as bool?
    ..setShanYanSloganTextColor = json['setShanYanSloganTextColor'] as String?
    ..setShanYanSloganTextAlignment = _$enumDecodeNullable(
        _$iOSTextAlignmentEnumMap, json['setShanYanSloganTextAlignment'])
    ..setShanYanSloganHidden = json['setShanYanSloganHidden'] as bool?
    ..setCheckBoxHidden = json['setCheckBoxHidden'] as bool?
    ..setPrivacyState = json['setPrivacyState'] as bool?
    ..setCheckBoxWH =
        (json['setCheckBoxWH'] as List<dynamic>?)?.map((e) => e as num).toList()
    ..setCheckBoxImageEdgeInsets =
        (json['setCheckBoxImageEdgeInsets'] as List<dynamic>?)
            ?.map((e) => e as num)
            .toList()
    ..setCheckBoxVerticalAlignmentToAppPrivacyTop =
        json['setCheckBoxVerticalAlignmentToAppPrivacyTop'] as bool?
    ..setCheckBoxVerticalAlignmentToAppPrivacyCenterY =
        json['setCheckBoxVerticalAlignmentToAppPrivacyCenterY'] as bool?
    ..setUncheckedImgPath = json['setUncheckedImgPath'] as String?
    ..setCheckedImgPath = json['setCheckedImgPath'] as String?
    ..setLoadingSize = (json['setLoadingSize'] as List<dynamic>?)
        ?.map((e) => e as num)
        .toList()
    ..setLoadingCornerRadius = json['setLoadingCornerRadius'] as num?
    ..setLoadingBackgroundColor = json['setLoadingBackgroundColor'] as String?
    ..setLoadingTintColor = json['setLoadingTintColor'] as String?
    ..widgets = (json['widgets'] as List<dynamic>?)
        ?.map((e) => ShanYanCustomWidgetIOS.fromJson(e as Map<String, dynamic>))
        .toList()
    ..setShouldAutorotate = json['setShouldAutorotate'] as bool?
    ..supportedInterfaceOrientations = _$enumDecodeNullable(
        _$iOSInterfaceOrientationMaskEnumMap,
        json['supportedInterfaceOrientations'])
    ..preferredInterfaceOrientationForPresentation = _$enumDecodeNullable(
        _$iOSInterfaceOrientationEnumMap,
        json['preferredInterfaceOrientationForPresentation'])
    ..setAuthTypeUseWindow = json['setAuthTypeUseWindow'] as bool?
    ..setAuthWindowCornerRadius = json['setAuthWindowCornerRadius'] as num?
    ..setAuthWindowModalTransitionStyle = _$enumDecodeNullable(
        _$iOSModalTransitionStyleEnumMap,
        json['setAuthWindowModalTransitionStyle'])
    ..setAuthWindowModalPresentationStyle = _$enumDecodeNullable(
        _$iOSModalPresentationStyleEnumMap,
        json['setAuthWindowModalPresentationStyle'])
    ..setAppPrivacyWebModalPresentationStyle = _$enumDecodeNullable(
        _$iOSModalPresentationStyleEnumMap,
        json['setAppPrivacyWebModalPresentationStyle'])
    ..setAuthWindowOverrideUserInterfaceStyle = _$enumDecodeNullable(
        _$iOSUserInterfaceStyleEnumMap,
        json['setAuthWindowOverrideUserInterfaceStyle'])
    ..setAuthWindowPresentingAnimate =
        json['setAuthWindowPresentingAnimate'] as bool?
    ..layOutPortrait = ClOrientationLayOutIOS.fromJson(
        json['layOutPortrait'] as Map<String, dynamic>)
    ..layOutLandscape = ClOrientationLayOutIOS.fromJson(
        json['layOutLandscape'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ShanYanUIConfigIOSToJson(ShanYanUIConfigIOS instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('isFinish', instance.isFinish);
  writeNotNull('setAuthBGImgPath', instance.setAuthBGImgPath);
  writeNotNull('setAuthBGVedioPath', instance.setAuthBGVedioPath);
  writeNotNull('setPreferredStatusBarStyle',
      _$iOSStatusBarStyleEnumMap[instance.setPreferredStatusBarStyle]);
  writeNotNull('setStatusBarHidden', instance.setStatusBarHidden);
  writeNotNull('setAuthNavHidden', instance.setAuthNavHidden);
  writeNotNull('setNavigationBarStyle',
      _$iOSBarStyleEnumMap[instance.setNavigationBarStyle]);
  writeNotNull('setAuthNavTransparent', instance.setAuthNavTransparent);
  writeNotNull('setNavText', instance.setNavText);
  writeNotNull('setNavTextColor', instance.setNavTextColor);
  writeNotNull('setNavTextSize', instance.setNavTextSize);
  writeNotNull('setNavReturnImgPath', instance.setNavReturnImgPath);
  writeNotNull('setNavReturnImgHidden', instance.setNavReturnImgHidden);
  writeNotNull('setBackPressedAvailable', instance.setBackPressedAvailable);
  writeNotNull('setFitsSystemWindows', instance.setFitsSystemWindows);
  writeNotNull('setNavBackBtnAlimentRight', instance.setNavBackBtnAlimentRight);
  writeNotNull(
      'setNavigationBottomLineHidden', instance.setNavigationBottomLineHidden);
  writeNotNull('setNavigationTintColor', instance.setNavigationTintColor);
  writeNotNull('setNavigationBarTintColor', instance.setNavigationBarTintColor);
  writeNotNull(
      'setNavigationBackgroundImage', instance.setNavigationBackgroundImage);
  writeNotNull('setNavigationShadowImage', instance.setNavigationShadowImage);
  writeNotNull('setLogoImgPath', instance.setLogoImgPath);
  writeNotNull('setLogoCornerRadius', instance.setLogoCornerRadius);
  writeNotNull('setLogoHidden', instance.setLogoHidden);
  writeNotNull('setNumberColor', instance.setNumberColor);
  writeNotNull('setNumberSize', instance.setNumberSize);
  writeNotNull('setNumberBold', instance.setNumberBold);
  writeNotNull('setNumberTextAlignment',
      _$iOSTextAlignmentEnumMap[instance.setNumberTextAlignment]);
  writeNotNull('setLogBtnText', instance.setLogBtnText);
  writeNotNull('setLogBtnTextColor', instance.setLogBtnTextColor);
  writeNotNull('setLoginBtnTextSize', instance.setLoginBtnTextSize);
  writeNotNull('setLoginBtnTextBold', instance.setLoginBtnTextBold);
  writeNotNull('setLoginBtnBgColor', instance.setLoginBtnBgColor);
  writeNotNull('setLoginBtnNormalBgImage', instance.setLoginBtnNormalBgImage);
  writeNotNull(
      'setLoginBtnHightLightBgImage', instance.setLoginBtnHightLightBgImage);
  writeNotNull(
      'setLoginBtnDisabledBgImage', instance.setLoginBtnDisabledBgImage);
  writeNotNull('setLoginBtnBorderColor', instance.setLoginBtnBorderColor);
  writeNotNull('setLoginBtnCornerRadius', instance.setLoginBtnCornerRadius);
  writeNotNull('setLoginBtnBorderWidth', instance.setLoginBtnBorderWidth);
  writeNotNull('setAppPrivacyColor', instance.setAppPrivacyColor);
  writeNotNull('setPrivacyTextSize', instance.setPrivacyTextSize);
  writeNotNull('setPrivacyWidth', instance.setPrivacyWidth);
  writeNotNull('setPrivacyTextBold', instance.setPrivacyTextBold);
  writeNotNull('setAppPrivacyTextAlignment',
      _$iOSTextAlignmentEnumMap[instance.setAppPrivacyTextAlignment]);
  writeNotNull('setPrivacySmhHidden', instance.setPrivacySmhHidden);
  writeNotNull('setAppPrivacyLineSpacing', instance.setAppPrivacyLineSpacing);
  writeNotNull(
      'setAppPrivacyNeedSizeToFit', instance.setAppPrivacyNeedSizeToFit);
  writeNotNull(
      'setAppPrivacyAbbreviatedName', instance.setAppPrivacyAbbreviatedName);
  writeNotNull('setAppPrivacyFirst', instance.setAppPrivacyFirst);
  writeNotNull('setAppPrivacySecond', instance.setAppPrivacySecond);
  writeNotNull('setAppPrivacyThird', instance.setAppPrivacyThird);
  writeNotNull('setAppPrivacyNormalDesTextFirst',
      instance.setAppPrivacyNormalDesTextFirst);
  writeNotNull('setAppPrivacyNormalDesTextSecond',
      instance.setAppPrivacyNormalDesTextSecond);
  writeNotNull('setAppPrivacyNormalDesTextThird',
      instance.setAppPrivacyNormalDesTextThird);
  writeNotNull('setAppPrivacyNormalDesTextFourth',
      instance.setAppPrivacyNormalDesTextFourth);
  writeNotNull('setAppPrivacyNormalDesTextLast',
      instance.setAppPrivacyNormalDesTextLast);
  writeNotNull(
      'morePrivacy', instance.morePrivacy?.map((e) => e.toJson()).toList());
  writeNotNull('setCheckBoxTipMsg', instance.setCheckBoxTipMsg);
  writeNotNull('setCheckBoxTipDisable', instance.setCheckBoxTipDisable);
  writeNotNull('setOperatorPrivacyAtLast', instance.setOperatorPrivacyAtLast);
  writeNotNull('setPrivacyActivityEnabled', instance.setPrivacyActivityEnabled);
  writeNotNull('setPrivacyGravityHorizontalCenter',
      instance.setPrivacyGravityHorizontalCenter);
  writeNotNull('setPrivacyNavTextColor', instance.setPrivacyNavTextColor);
  writeNotNull('setPrivacyNavTextSize', instance.setPrivacyNavTextSize);
  writeNotNull(
      'setPrivacyNavReturnImgPath', instance.setPrivacyNavReturnImgPath);
  writeNotNull(
      'setAppPrivacyWebPreferredStatusBarStyle',
      _$iOSStatusBarStyleEnumMap[
          instance.setAppPrivacyWebPreferredStatusBarStyle]);
  writeNotNull('setAppPrivacyWebNavigationBarStyle',
      _$iOSBarStyleEnumMap[instance.setAppPrivacyWebNavigationBarStyle]);
  writeNotNull('setAppPrivacyWebNavigationTintColor',
      instance.setAppPrivacyWebNavigationTintColor);
  writeNotNull('setAppPrivacyWebNavigationBarTintColor',
      instance.setAppPrivacyWebNavigationBarTintColor);
  writeNotNull('setAppPrivacyWebNavigationBackgroundImage',
      instance.setAppPrivacyWebNavigationBackgroundImage);
  writeNotNull('setAppPrivacyWebNavigationShadowImage',
      instance.setAppPrivacyWebNavigationShadowImage);
  writeNotNull('setSloganTextSize', instance.setSloganTextSize);
  writeNotNull('setSloganTextBold', instance.setSloganTextBold);
  writeNotNull('setSloganTextColor', instance.setSloganTextColor);
  writeNotNull('setSloganTextAlignment',
      _$iOSTextAlignmentEnumMap[instance.setSloganTextAlignment]);
  writeNotNull('setSloganTextHidden', instance.setSloganTextHidden);
  writeNotNull('setShanYanSloganTextSize', instance.setShanYanSloganTextSize);
  writeNotNull('setShanYanSloganTextBold', instance.setShanYanSloganTextBold);
  writeNotNull('setShanYanSloganTextColor', instance.setShanYanSloganTextColor);
  writeNotNull('setShanYanSloganTextAlignment',
      _$iOSTextAlignmentEnumMap[instance.setShanYanSloganTextAlignment]);
  writeNotNull('setShanYanSloganHidden', instance.setShanYanSloganHidden);
  writeNotNull('setCheckBoxHidden', instance.setCheckBoxHidden);
  writeNotNull('setPrivacyState', instance.setPrivacyState);
  writeNotNull('setCheckBoxWH', instance.setCheckBoxWH);
  writeNotNull(
      'setCheckBoxImageEdgeInsets', instance.setCheckBoxImageEdgeInsets);
  writeNotNull('setCheckBoxVerticalAlignmentToAppPrivacyTop',
      instance.setCheckBoxVerticalAlignmentToAppPrivacyTop);
  writeNotNull('setCheckBoxVerticalAlignmentToAppPrivacyCenterY',
      instance.setCheckBoxVerticalAlignmentToAppPrivacyCenterY);
  writeNotNull('setUncheckedImgPath', instance.setUncheckedImgPath);
  writeNotNull('setCheckedImgPath', instance.setCheckedImgPath);
  writeNotNull('setLoadingSize', instance.setLoadingSize);
  writeNotNull('setLoadingCornerRadius', instance.setLoadingCornerRadius);
  writeNotNull('setLoadingBackgroundColor', instance.setLoadingBackgroundColor);
  writeNotNull('setLoadingTintColor', instance.setLoadingTintColor);
  writeNotNull('widgets', instance.widgets?.map((e) => e.toJson()).toList());
  writeNotNull('setShouldAutorotate', instance.setShouldAutorotate);
  writeNotNull(
      'supportedInterfaceOrientations',
      _$iOSInterfaceOrientationMaskEnumMap[
          instance.supportedInterfaceOrientations]);
  writeNotNull(
      'preferredInterfaceOrientationForPresentation',
      _$iOSInterfaceOrientationEnumMap[
          instance.preferredInterfaceOrientationForPresentation]);
  writeNotNull('setAuthTypeUseWindow', instance.setAuthTypeUseWindow);
  writeNotNull('setAuthWindowCornerRadius', instance.setAuthWindowCornerRadius);
  writeNotNull(
      'setAuthWindowModalTransitionStyle',
      _$iOSModalTransitionStyleEnumMap[
          instance.setAuthWindowModalTransitionStyle]);
  writeNotNull(
      'setAuthWindowModalPresentationStyle',
      _$iOSModalPresentationStyleEnumMap[
          instance.setAuthWindowModalPresentationStyle]);
  writeNotNull(
      'setAppPrivacyWebModalPresentationStyle',
      _$iOSModalPresentationStyleEnumMap[
          instance.setAppPrivacyWebModalPresentationStyle]);
  writeNotNull(
      'setAuthWindowOverrideUserInterfaceStyle',
      _$iOSUserInterfaceStyleEnumMap[
          instance.setAuthWindowOverrideUserInterfaceStyle]);
  writeNotNull('setAuthWindowPresentingAnimate',
      instance.setAuthWindowPresentingAnimate);
  val['layOutPortrait'] = instance.layOutPortrait.toJson();
  val['layOutLandscape'] = instance.layOutLandscape.toJson();
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$iOSStatusBarStyleEnumMap = {
  iOSStatusBarStyle.styleDefault: 0,
  iOSStatusBarStyle.styleLightContent: 1,
  iOSStatusBarStyle.styleDarkContent: 2,
};

const _$iOSBarStyleEnumMap = {
  iOSBarStyle.styleDefault: 0,
  iOSBarStyle.styleBlack: 1,
};

const _$iOSTextAlignmentEnumMap = {
  iOSTextAlignment.center: 0,
  iOSTextAlignment.left: 1,
  iOSTextAlignment.right: 2,
  iOSTextAlignment.justified: 3,
  iOSTextAlignment.natural: 4,
};

const _$iOSInterfaceOrientationMaskEnumMap = {
  iOSInterfaceOrientationMask.portrait: 0,
  iOSInterfaceOrientationMask.landscapeLeft: 1,
  iOSInterfaceOrientationMask.landscapeRight: 2,
  iOSInterfaceOrientationMask.portraitUpsideDown: 3,
  iOSInterfaceOrientationMask.landscape: 4,
  iOSInterfaceOrientationMask.all: 5,
  iOSInterfaceOrientationMask.allButUpsideDown: 6,
};

const _$iOSInterfaceOrientationEnumMap = {
  iOSInterfaceOrientation.portrait: 0,
  iOSInterfaceOrientation.portraitUpsideDown: 1,
  iOSInterfaceOrientation.landscapeLeft: 2,
  iOSInterfaceOrientation.landscapeRight: 3,
  iOSInterfaceOrientation.unknown: 4,
};

const _$iOSModalTransitionStyleEnumMap = {
  iOSModalTransitionStyle.coverVertical: 0,
  iOSModalTransitionStyle.flipHorizontal: 1,
  iOSModalTransitionStyle.crossDissolve: 2,
};

const _$iOSModalPresentationStyleEnumMap = {
  iOSModalPresentationStyle.fullScreen: 0,
  iOSModalPresentationStyle.overFullScreen: 1,
  iOSModalPresentationStyle.automatic: 2,
};

const _$iOSUserInterfaceStyleEnumMap = {
  iOSUserInterfaceStyle.unspecified: 0,
  iOSUserInterfaceStyle.light: 1,
  iOSUserInterfaceStyle.dark: 2,
};

ClOrientationLayOutIOS _$ClOrientationLayOutIOSFromJson(
    Map<String, dynamic> json) {
  return ClOrientationLayOutIOS()
    ..setLogoWidth = json['setLogoWidth'] as num?
    ..setLogoHeight = json['setLogoHeight'] as num?
    ..setLogoLeft = json['setLogoLeft'] as num?
    ..setLogoRight = json['setLogoRight'] as num?
    ..setLogoTop = json['setLogoTop'] as num?
    ..setLogoBottom = json['setLogoBottom'] as num?
    ..setLogoCenterX = json['setLogoCenterX'] as num?
    ..setLogoCenterY = json['setLogoCenterY'] as num?
    ..setNumFieldWidth = json['setNumFieldWidth'] as num?
    ..setNumFieldHeight = json['setNumFieldHeight'] as num?
    ..setNumFieldLeft = json['setNumFieldLeft'] as num?
    ..setNumFieldRight = json['setNumFieldRight'] as num?
    ..setNumFieldTop = json['setNumFieldTop'] as num?
    ..setNumFieldBottom = json['setNumFieldBottom'] as num?
    ..setNumFieldCenterX = json['setNumFieldCenterX'] as num?
    ..setNumFieldCenterY = json['setNumFieldCenterY'] as num?
    ..setLogBtnHeight = json['setLogBtnHeight'] as num?
    ..setLogBtnWidth = json['setLogBtnWidth'] as num?
    ..setLogBtnLeft = json['setLogBtnLeft'] as num?
    ..setLogBtnRight = json['setLogBtnRight'] as num?
    ..setLogBtnTop = json['setLogBtnTop'] as num?
    ..setLogBtnBottom = json['setLogBtnBottom'] as num?
    ..setLogBtnCenterX = json['setLogBtnCenterX'] as num?
    ..setLogBtnCenterY = json['setLogBtnCenterY'] as num?
    ..setPrivacyHeight = json['setPrivacyHeight'] as num?
    ..setPrivacyWidth = json['setPrivacyWidth'] as num?
    ..setPrivacyLeft = json['setPrivacyLeft'] as num?
    ..setPrivacyRight = json['setPrivacyRight'] as num?
    ..setPrivacyTop = json['setPrivacyTop'] as num?
    ..setPrivacyBottom = json['setPrivacyBottom'] as num?
    ..setPrivacyCenterX = json['setPrivacyCenterX'] as num?
    ..setPrivacyCenterY = json['setPrivacyCenterY'] as num?
    ..setSloganHeight = json['setSloganHeight'] as num?
    ..setSloganWidth = json['setSloganWidth'] as num?
    ..setSloganLeft = json['setSloganLeft'] as num?
    ..setSloganRight = json['setSloganRight'] as num?
    ..setSloganTop = json['setSloganTop'] as num?
    ..setSloganBottom = json['setSloganBottom'] as num?
    ..setSloganCenterX = json['setSloganCenterX'] as num?
    ..setSloganCenterY = json['setSloganCenterY'] as num?
    ..setShanYanSloganHeight = json['setShanYanSloganHeight'] as num?
    ..setShanYanSloganWidth = json['setShanYanSloganWidth'] as num?
    ..setShanYanSloganLeft = json['setShanYanSloganLeft'] as num?
    ..setShanYanSloganRight = json['setShanYanSloganRight'] as num?
    ..setShanYanSloganTop = json['setShanYanSloganTop'] as num?
    ..setShanYanSloganBottom = json['setShanYanSloganBottom'] as num?
    ..setShanYanSloganCenterX = json['setShanYanSloganCenterX'] as num?
    ..setShanYanSloganCenterY = json['setShanYanSloganCenterY'] as num?
    ..setAuthWindowOrientationCenterX =
        json['setAuthWindowOrientationCenterX'] as num?
    ..setAuthWindowOrientationCenterY =
        json['setAuthWindowOrientationCenterY'] as num?
    ..setAuthWindowOrientationOriginX =
        json['setAuthWindowOrientationOriginX'] as num?
    ..setAuthWindowOrientationOriginY =
        json['setAuthWindowOrientationOriginY'] as num?
    ..setAuthWindowOrientationWidth =
        json['setAuthWindowOrientationWidth'] as num?
    ..setAuthWindowOrientationHeight =
        json['setAuthWindowOrientationHeight'] as num?;
}

Map<String, dynamic> _$ClOrientationLayOutIOSToJson(
    ClOrientationLayOutIOS instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('setLogoWidth', instance.setLogoWidth);
  writeNotNull('setLogoHeight', instance.setLogoHeight);
  writeNotNull('setLogoLeft', instance.setLogoLeft);
  writeNotNull('setLogoRight', instance.setLogoRight);
  writeNotNull('setLogoTop', instance.setLogoTop);
  writeNotNull('setLogoBottom', instance.setLogoBottom);
  writeNotNull('setLogoCenterX', instance.setLogoCenterX);
  writeNotNull('setLogoCenterY', instance.setLogoCenterY);
  writeNotNull('setNumFieldWidth', instance.setNumFieldWidth);
  writeNotNull('setNumFieldHeight', instance.setNumFieldHeight);
  writeNotNull('setNumFieldLeft', instance.setNumFieldLeft);
  writeNotNull('setNumFieldRight', instance.setNumFieldRight);
  writeNotNull('setNumFieldTop', instance.setNumFieldTop);
  writeNotNull('setNumFieldBottom', instance.setNumFieldBottom);
  writeNotNull('setNumFieldCenterX', instance.setNumFieldCenterX);
  writeNotNull('setNumFieldCenterY', instance.setNumFieldCenterY);
  writeNotNull('setLogBtnHeight', instance.setLogBtnHeight);
  writeNotNull('setLogBtnWidth', instance.setLogBtnWidth);
  writeNotNull('setLogBtnLeft', instance.setLogBtnLeft);
  writeNotNull('setLogBtnRight', instance.setLogBtnRight);
  writeNotNull('setLogBtnTop', instance.setLogBtnTop);
  writeNotNull('setLogBtnBottom', instance.setLogBtnBottom);
  writeNotNull('setLogBtnCenterX', instance.setLogBtnCenterX);
  writeNotNull('setLogBtnCenterY', instance.setLogBtnCenterY);
  writeNotNull('setPrivacyHeight', instance.setPrivacyHeight);
  writeNotNull('setPrivacyWidth', instance.setPrivacyWidth);
  writeNotNull('setPrivacyLeft', instance.setPrivacyLeft);
  writeNotNull('setPrivacyRight', instance.setPrivacyRight);
  writeNotNull('setPrivacyTop', instance.setPrivacyTop);
  writeNotNull('setPrivacyBottom', instance.setPrivacyBottom);
  writeNotNull('setPrivacyCenterX', instance.setPrivacyCenterX);
  writeNotNull('setPrivacyCenterY', instance.setPrivacyCenterY);
  writeNotNull('setSloganHeight', instance.setSloganHeight);
  writeNotNull('setSloganWidth', instance.setSloganWidth);
  writeNotNull('setSloganLeft', instance.setSloganLeft);
  writeNotNull('setSloganRight', instance.setSloganRight);
  writeNotNull('setSloganTop', instance.setSloganTop);
  writeNotNull('setSloganBottom', instance.setSloganBottom);
  writeNotNull('setSloganCenterX', instance.setSloganCenterX);
  writeNotNull('setSloganCenterY', instance.setSloganCenterY);
  writeNotNull('setShanYanSloganHeight', instance.setShanYanSloganHeight);
  writeNotNull('setShanYanSloganWidth', instance.setShanYanSloganWidth);
  writeNotNull('setShanYanSloganLeft', instance.setShanYanSloganLeft);
  writeNotNull('setShanYanSloganRight', instance.setShanYanSloganRight);
  writeNotNull('setShanYanSloganTop', instance.setShanYanSloganTop);
  writeNotNull('setShanYanSloganBottom', instance.setShanYanSloganBottom);
  writeNotNull('setShanYanSloganCenterX', instance.setShanYanSloganCenterX);
  writeNotNull('setShanYanSloganCenterY', instance.setShanYanSloganCenterY);
  writeNotNull('setAuthWindowOrientationCenterX',
      instance.setAuthWindowOrientationCenterX);
  writeNotNull('setAuthWindowOrientationCenterY',
      instance.setAuthWindowOrientationCenterY);
  writeNotNull('setAuthWindowOrientationOriginX',
      instance.setAuthWindowOrientationOriginX);
  writeNotNull('setAuthWindowOrientationOriginY',
      instance.setAuthWindowOrientationOriginY);
  writeNotNull(
      'setAuthWindowOrientationWidth', instance.setAuthWindowOrientationWidth);
  writeNotNull('setAuthWindowOrientationHeight',
      instance.setAuthWindowOrientationHeight);
  return val;
}

ShanYanUIConfigAndroid _$ShanYanUIConfigAndroidFromJson(
    Map<String, dynamic> json) {
  return ShanYanUIConfigAndroid(
    isFinish: json['isFinish'] as bool,
  )
    ..setAuthBGImgPath = json['setAuthBGImgPath'] as String?
    ..setAuthBgGifPath = json['setAuthBgGifPath'] as String?
    ..setAuthBgVideoPath = json['setAuthBgVideoPath'] as String?
    ..setStatusBarHidden = json['setStatusBarHidden'] as bool?
    ..setStatusBarColor = json['setStatusBarColor'] as String?
    ..setLogBtnBackgroundColor = json['setLogBtnBackgroundColor'] as String?
    ..setLightColor = json['setLightColor'] as bool?
    ..setVirtualKeyTransparent = json['setVirtualKeyTransparent'] as bool?
    ..setAuthFlagSecureEnable = json['setAuthFlagSecureEnable'] as bool?
    ..setPrivacyFlagSecureEnable = json['setPrivacyFlagSecureEnable'] as bool?
    ..setFullScreen = json['setFullScreen'] as bool?
    ..setNavReturnBtnWidth = json['setNavReturnBtnWidth'] as int?
    ..setNavReturnBtnHeight = json['setNavReturnBtnHeight'] as int?
    ..setNavReturnBtnOffsetRightX = json['setNavReturnBtnOffsetRightX'] as int?
    ..setNavReturnBtnOffsetX = json['setNavReturnBtnOffsetX'] as int?
    ..setNavReturnBtnOffsetY = json['setNavReturnBtnOffsetY'] as int?
    ..setNavColor = json['setNavColor'] as String?
    ..setNavText = json['setNavText'] as String?
    ..setNavTextColor = json['setNavTextColor'] as String?
    ..setNavTextSize = json['setNavTextSize'] as int?
    ..setNavReturnImgPath = json['setNavReturnImgPath'] as String?
    ..setNavReturnImgHidden = json['setNavReturnImgHidden'] as bool?
    ..setBackPressedAvailable = json['setBackPressedAvailable'] as bool?
    ..setFitsSystemWindows = json['setFitsSystemWindows'] as bool?
    ..setAuthNavHidden = json['setAuthNavHidden'] as bool?
    ..setAuthNavTransparent = json['setAuthNavTransparent'] as bool?
    ..setNavTextBold = json['setNavTextBold'] as bool?
    ..setLogoImgPath = json['setLogoImgPath'] as String?
    ..setLogoHidden = json['setLogoHidden'] as bool?
    ..setLogoOffsetY = json['setLogoOffsetY'] as int?
    ..setLogoOffsetBottomY = json['setLogoOffsetBottomY'] as int?
    ..setLogoOffsetX = json['setLogoOffsetX'] as int?
    ..setLogoWidth = json['setLogoWidth'] as int?
    ..setLogoHeight = json['setLogoHeight'] as int?
    ..setNumFieldOffsetY = json['setNumFieldOffsetY'] as int?
    ..setNumFieldOffsetBottomY = json['setNumFieldOffsetBottomY'] as int?
    ..setNumberSize = json['setNumberSize'] as int?
    ..setNumFieldOffsetX = json['setNumFieldOffsetX'] as int?
    ..setNumFieldWidth = json['setNumFieldWidth'] as int?
    ..setNumFieldHeight = json['setNumFieldHeight'] as int?
    ..setNumberColor = json['setNumberColor'] as String?
    ..setNumberBold = json['setNumberBold'] as bool?
    ..setLogBtnOffsetY = json['setLogBtnOffsetY'] as int?
    ..setLogBtnOffsetBottomY = json['setLogBtnOffsetBottomY'] as int?
    ..setLogBtnTextSize = json['setLogBtnTextSize'] as int?
    ..setLogBtnOffsetX = json['setLogBtnOffsetX'] as int?
    ..setLogBtnHeight = json['setLogBtnHeight'] as int?
    ..setLogBtnWidth = json['setLogBtnWidth'] as int?
    ..setLogBtnText = json['setLogBtnText'] as String?
    ..setLogBtnTextColor = json['setLogBtnTextColor'] as String?
    ..setLogBtnImgPath = json['setLogBtnImgPath'] as String?
    ..setLogBtnTextBold = json['setLogBtnTextBold'] as bool?
    ..setPrivacyOffsetBottomY = json['setPrivacyOffsetBottomY'] as int?
    ..setPrivacyOffsetY = json['setPrivacyOffsetY'] as int?
    ..setPrivacyOffsetX = json['setPrivacyOffsetX'] as int?
    ..setAppPrivacyOne = (json['setAppPrivacyOne'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setAppPrivacyTwo = (json['setAppPrivacyTwo'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setAppPrivacyThree = (json['setAppPrivacyThree'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setPrivacySmhHidden = json['setPrivacySmhHidden'] as bool?
    ..setPrivacyTextSize = json['setPrivacyTextSize'] as int?
    ..setPrivacyWidth = json['setPrivacyWidth'] as int?
    ..setAppPrivacyColor = (json['setAppPrivacyColor'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setPrivacyOffsetGravityLeft = json['setPrivacyOffsetGravityLeft'] as bool?
    ..setPrivacyState = json['setPrivacyState'] as bool?
    ..setUncheckedImgPath = json['setUncheckedImgPath'] as String?
    ..setCheckedImgPath = json['setCheckedImgPath'] as String?
    ..setCheckBoxHidden = json['setCheckBoxHidden'] as bool?
    ..setCheckBoxWH =
        (json['setCheckBoxWH'] as List<dynamic>?)?.map((e) => e as int).toList()
    ..setCheckBoxOffsetXY = (json['setCheckBoxOffsetXY'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList()
    ..setCheckBoxMargin = (json['setCheckBoxMargin'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList()
    ..setPrivacyText = (json['setPrivacyText'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setPrivacyTextBold = json['setPrivacyTextBold'] as bool?
    ..setCheckBoxTipDisable = json['setCheckBoxTipDisable'] as bool?
    ..setPrivacyCustomToastText = json['setPrivacyCustomToastText'] as String?
    ..setPrivacyNameUnderline = json['setPrivacyNameUnderline'] as bool?
    ..setPrivacyGravityHorizontalCenter =
        json['setPrivacyGravityHorizontalCenter'] as bool?
    ..setPrivacyActivityEnabled = json['setPrivacyActivityEnabled'] as bool?
    ..setSloganOffsetY = json['setSloganOffsetY'] as int?
    ..setSloganOffsetBottomY = json['setSloganOffsetBottomY'] as int?
    ..setSloganOffsetX = json['setSloganOffsetX'] as int?
    ..setSloganTextColor = json['setSloganTextColor'] as String?
    ..setSloganTextSize = json['setSloganTextSize'] as int?
    ..setSloganHidden = json['setSloganHidden'] as bool?
    ..setSloganTextBold = json['setSloganTextBold'] as bool?
    ..setShanYanSloganOffsetY = json['setShanYanSloganOffsetY'] as int?
    ..setShanYanSloganOffsetBottomY =
        json['setShanYanSloganOffsetBottomY'] as int?
    ..setShanYanSloganOffsetX = json['setShanYanSloganOffsetX'] as int?
    ..setShanYanSloganTextColor = json['setShanYanSloganTextColor'] as String?
    ..setShanYanSloganTextSize = json['setShanYanSloganTextSize'] as int?
    ..setShanYanSloganHidden = json['setShanYanSloganHidden'] as bool?
    ..setShanYanSloganTextBold = json['setShanYanSloganTextBold'] as bool?
    ..setPrivacyNavColor = json['setPrivacyNavColor'] as String?
    ..setPrivacyNavTextBold = json['setPrivacyNavTextBold'] as bool?
    ..setPrivacyNavTextColor = json['setPrivacyNavTextColor'] as String?
    ..setPrivacyNavTextSize = json['setPrivacyNavTextSize'] as int?
    ..setPrivacyNavReturnImgPath = json['setPrivacyNavReturnImgPath'] as String?
    ..setPrivacyNavReturnImgHidden =
        json['setPrivacyNavReturnImgHidden'] as bool?
    ..setPrivacyNavReturnBtnWidth = json['setPrivacyNavReturnBtnWidth'] as int?
    ..setPrivacyNavReturnBtnHeight =
        json['setPrivacyNavReturnBtnHeight'] as int?
    ..setPrivacyNavReturnBtnOffsetRightX =
        json['setPrivacyNavReturnBtnOffsetRightX'] as int?
    ..setPrivacyNavReturnBtnOffsetX =
        json['setPrivacyNavReturnBtnOffsetX'] as int?
    ..setPrivacyNavReturnBtnOffsetY =
        json['setPrivacyNavReturnBtnOffsetY'] as int?
    ..setLoadingView = json['setLoadingView'] as String?
    ..setDialogTheme = (json['setDialogTheme'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList()
    ..setActivityTranslateAnim =
        (json['setActivityTranslateAnim'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList()
    ..widgetLayouts = (json['widgetLayouts'] as List<dynamic>?)
        ?.map((e) =>
            ShanYanCustomWidgetLayout.fromJson(e as Map<String, dynamic>))
        .toList()
    ..widgets = (json['widgets'] as List<dynamic>?)
        ?.map((e) => ShanYanCustomWidget.fromJson(e as Map<String, dynamic>))
        .toList()
    ..morePrivacy = (json['morePrivacy'] as List<dynamic>?)
        ?.map((e) => ConfigPrivacyBean.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ShanYanUIConfigAndroidToJson(
    ShanYanUIConfigAndroid instance) {
  final val = <String, dynamic>{
    'isFinish': instance.isFinish,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('setAuthBGImgPath', instance.setAuthBGImgPath);
  writeNotNull('setAuthBgGifPath', instance.setAuthBgGifPath);
  writeNotNull('setAuthBgVideoPath', instance.setAuthBgVideoPath);
  writeNotNull('setStatusBarHidden', instance.setStatusBarHidden);
  writeNotNull('setStatusBarColor', instance.setStatusBarColor);
  writeNotNull('setLogBtnBackgroundColor', instance.setLogBtnBackgroundColor);
  writeNotNull('setLightColor', instance.setLightColor);
  writeNotNull('setVirtualKeyTransparent', instance.setVirtualKeyTransparent);
  writeNotNull('setAuthFlagSecureEnable', instance.setAuthFlagSecureEnable);
  writeNotNull(
      'setPrivacyFlagSecureEnable', instance.setPrivacyFlagSecureEnable);
  writeNotNull('setFullScreen', instance.setFullScreen);
  writeNotNull('setNavReturnBtnWidth', instance.setNavReturnBtnWidth);
  writeNotNull('setNavReturnBtnHeight', instance.setNavReturnBtnHeight);
  writeNotNull(
      'setNavReturnBtnOffsetRightX', instance.setNavReturnBtnOffsetRightX);
  writeNotNull('setNavReturnBtnOffsetX', instance.setNavReturnBtnOffsetX);
  writeNotNull('setNavReturnBtnOffsetY', instance.setNavReturnBtnOffsetY);
  writeNotNull('setNavColor', instance.setNavColor);
  writeNotNull('setNavText', instance.setNavText);
  writeNotNull('setNavTextColor', instance.setNavTextColor);
  writeNotNull('setNavTextSize', instance.setNavTextSize);
  writeNotNull('setNavReturnImgPath', instance.setNavReturnImgPath);
  writeNotNull('setNavReturnImgHidden', instance.setNavReturnImgHidden);
  writeNotNull('setBackPressedAvailable', instance.setBackPressedAvailable);
  writeNotNull('setFitsSystemWindows', instance.setFitsSystemWindows);
  writeNotNull('setAuthNavHidden', instance.setAuthNavHidden);
  writeNotNull('setAuthNavTransparent', instance.setAuthNavTransparent);
  writeNotNull('setNavTextBold', instance.setNavTextBold);
  writeNotNull('setLogoImgPath', instance.setLogoImgPath);
  writeNotNull('setLogoHidden', instance.setLogoHidden);
  writeNotNull('setLogoOffsetY', instance.setLogoOffsetY);
  writeNotNull('setLogoOffsetBottomY', instance.setLogoOffsetBottomY);
  writeNotNull('setLogoOffsetX', instance.setLogoOffsetX);
  writeNotNull('setLogoWidth', instance.setLogoWidth);
  writeNotNull('setLogoHeight', instance.setLogoHeight);
  writeNotNull('setNumFieldOffsetY', instance.setNumFieldOffsetY);
  writeNotNull('setNumFieldOffsetBottomY', instance.setNumFieldOffsetBottomY);
  writeNotNull('setNumberSize', instance.setNumberSize);
  writeNotNull('setNumFieldOffsetX', instance.setNumFieldOffsetX);
  writeNotNull('setNumFieldWidth', instance.setNumFieldWidth);
  writeNotNull('setNumFieldHeight', instance.setNumFieldHeight);
  writeNotNull('setNumberColor', instance.setNumberColor);
  writeNotNull('setNumberBold', instance.setNumberBold);
  writeNotNull('setLogBtnOffsetY', instance.setLogBtnOffsetY);
  writeNotNull('setLogBtnOffsetBottomY', instance.setLogBtnOffsetBottomY);
  writeNotNull('setLogBtnTextSize', instance.setLogBtnTextSize);
  writeNotNull('setLogBtnOffsetX', instance.setLogBtnOffsetX);
  writeNotNull('setLogBtnHeight', instance.setLogBtnHeight);
  writeNotNull('setLogBtnWidth', instance.setLogBtnWidth);
  writeNotNull('setLogBtnText', instance.setLogBtnText);
  writeNotNull('setLogBtnTextColor', instance.setLogBtnTextColor);
  writeNotNull('setLogBtnImgPath', instance.setLogBtnImgPath);
  writeNotNull('setLogBtnTextBold', instance.setLogBtnTextBold);
  writeNotNull('setPrivacyOffsetBottomY', instance.setPrivacyOffsetBottomY);
  writeNotNull('setPrivacyOffsetY', instance.setPrivacyOffsetY);
  writeNotNull('setPrivacyOffsetX', instance.setPrivacyOffsetX);
  writeNotNull('setAppPrivacyOne', instance.setAppPrivacyOne);
  writeNotNull('setAppPrivacyTwo', instance.setAppPrivacyTwo);
  writeNotNull('setAppPrivacyThree', instance.setAppPrivacyThree);
  writeNotNull('setPrivacySmhHidden', instance.setPrivacySmhHidden);
  writeNotNull('setPrivacyTextSize', instance.setPrivacyTextSize);
  writeNotNull('setPrivacyWidth', instance.setPrivacyWidth);
  writeNotNull('setAppPrivacyColor', instance.setAppPrivacyColor);
  writeNotNull(
      'setPrivacyOffsetGravityLeft', instance.setPrivacyOffsetGravityLeft);
  writeNotNull('setPrivacyState', instance.setPrivacyState);
  writeNotNull('setUncheckedImgPath', instance.setUncheckedImgPath);
  writeNotNull('setCheckedImgPath', instance.setCheckedImgPath);
  writeNotNull('setCheckBoxHidden', instance.setCheckBoxHidden);
  writeNotNull('setCheckBoxWH', instance.setCheckBoxWH);
  writeNotNull('setCheckBoxOffsetXY', instance.setCheckBoxOffsetXY);
  writeNotNull('setCheckBoxMargin', instance.setCheckBoxMargin);
  writeNotNull('setPrivacyText', instance.setPrivacyText);
  writeNotNull('setPrivacyTextBold', instance.setPrivacyTextBold);
  writeNotNull('setCheckBoxTipDisable', instance.setCheckBoxTipDisable);
  writeNotNull('setPrivacyCustomToastText', instance.setPrivacyCustomToastText);
  writeNotNull('setPrivacyNameUnderline', instance.setPrivacyNameUnderline);
  writeNotNull('setPrivacyGravityHorizontalCenter',
      instance.setPrivacyGravityHorizontalCenter);
  writeNotNull('setPrivacyActivityEnabled', instance.setPrivacyActivityEnabled);
  writeNotNull('setSloganOffsetY', instance.setSloganOffsetY);
  writeNotNull('setSloganOffsetBottomY', instance.setSloganOffsetBottomY);
  writeNotNull('setSloganOffsetX', instance.setSloganOffsetX);
  writeNotNull('setSloganTextColor', instance.setSloganTextColor);
  writeNotNull('setSloganTextSize', instance.setSloganTextSize);
  writeNotNull('setSloganHidden', instance.setSloganHidden);
  writeNotNull('setSloganTextBold', instance.setSloganTextBold);
  writeNotNull('setShanYanSloganOffsetY', instance.setShanYanSloganOffsetY);
  writeNotNull(
      'setShanYanSloganOffsetBottomY', instance.setShanYanSloganOffsetBottomY);
  writeNotNull('setShanYanSloganOffsetX', instance.setShanYanSloganOffsetX);
  writeNotNull('setShanYanSloganTextColor', instance.setShanYanSloganTextColor);
  writeNotNull('setShanYanSloganTextSize', instance.setShanYanSloganTextSize);
  writeNotNull('setShanYanSloganHidden', instance.setShanYanSloganHidden);
  writeNotNull('setShanYanSloganTextBold', instance.setShanYanSloganTextBold);
  writeNotNull('setPrivacyNavColor', instance.setPrivacyNavColor);
  writeNotNull('setPrivacyNavTextBold', instance.setPrivacyNavTextBold);
  writeNotNull('setPrivacyNavTextColor', instance.setPrivacyNavTextColor);
  writeNotNull('setPrivacyNavTextSize', instance.setPrivacyNavTextSize);
  writeNotNull(
      'setPrivacyNavReturnImgPath', instance.setPrivacyNavReturnImgPath);
  writeNotNull(
      'setPrivacyNavReturnImgHidden', instance.setPrivacyNavReturnImgHidden);
  writeNotNull(
      'setPrivacyNavReturnBtnWidth', instance.setPrivacyNavReturnBtnWidth);
  writeNotNull(
      'setPrivacyNavReturnBtnHeight', instance.setPrivacyNavReturnBtnHeight);
  writeNotNull('setPrivacyNavReturnBtnOffsetRightX',
      instance.setPrivacyNavReturnBtnOffsetRightX);
  writeNotNull(
      'setPrivacyNavReturnBtnOffsetX', instance.setPrivacyNavReturnBtnOffsetX);
  writeNotNull(
      'setPrivacyNavReturnBtnOffsetY', instance.setPrivacyNavReturnBtnOffsetY);
  writeNotNull('setLoadingView', instance.setLoadingView);
  writeNotNull('setDialogTheme', instance.setDialogTheme);
  writeNotNull('setActivityTranslateAnim', instance.setActivityTranslateAnim);
  writeNotNull(
      'widgetLayouts', instance.widgetLayouts?.map((e) => e.toJson()).toList());
  writeNotNull('widgets', instance.widgets?.map((e) => e.toJson()).toList());
  writeNotNull(
      'morePrivacy', instance.morePrivacy?.map((e) => e.toJson()).toList());
  return val;
}

ShanYanCustomWidgetLayout _$ShanYanCustomWidgetLayoutFromJson(
    Map<String, dynamic> json) {
  return ShanYanCustomWidgetLayout(
    json['widgetLayoutName'] as String,
    _$enumDecode(_$ShanYanCustomWidgetLayoutTypeEnumMap, json['type']),
  )
    ..widgetLayoutId = (json['widgetLayoutId'] as List<dynamic>)
        .map((e) => e as String)
        .toList()
    ..left = json['left'] as int
    ..top = json['top'] as int
    ..right = json['right'] as int
    ..bottom = json['bottom'] as int
    ..width = json['width'] as int
    ..height = json['height'] as int;
}

Map<String, dynamic> _$ShanYanCustomWidgetLayoutToJson(
        ShanYanCustomWidgetLayout instance) =>
    <String, dynamic>{
      'widgetLayoutName': instance.widgetLayoutName,
      'widgetLayoutId': instance.widgetLayoutId,
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
      'width': instance.width,
      'height': instance.height,
      'type': _$ShanYanCustomWidgetLayoutTypeEnumMap[instance.type],
    };

const _$ShanYanCustomWidgetLayoutTypeEnumMap = {
  ShanYanCustomWidgetLayoutType.RelativeLayout: 'RelativeLayout',
};

ConfigPrivacyBean _$ConfigPrivacyBeanFromJson(Map<String, dynamic> json) {
  return ConfigPrivacyBean(
    json['name'] as String?,
    json['url'] as String?,
  )
    ..color = json['color'] as String?
    ..midStr = json['midStr'] as String?
    ..title = json['title'] as String?;
}

Map<String, dynamic> _$ConfigPrivacyBeanToJson(ConfigPrivacyBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'color': instance.color,
      'midStr': instance.midStr,
      'title': instance.title,
    };

ShanYanCustomWidget _$ShanYanCustomWidgetFromJson(Map<String, dynamic> json) {
  return ShanYanCustomWidget(
    json['widgetId'] as String,
    _$enumDecodeNullable(_$ShanYanCustomWidgetTypeEnumMap, json['type']),
  )
    ..left = json['left'] as int
    ..top = json['top'] as int
    ..right = json['right'] as int
    ..bottom = json['bottom'] as int
    ..width = json['width'] as int
    ..height = json['height'] as int
    ..textContent = json['textContent'] as String
    ..textFont = (json['textFont'] as num).toDouble()
    ..textColor = json['textColor'] as String
    ..backgroundColor = json['backgroundColor'] as String?
    ..backgroundImgPath = json['backgroundImgPath'] as String?
    ..textAlignment = _$enumDecode(
        _$ShanYanCustomWidgetGravityTypeEnumMap, json['textAlignment'])
    ..isFinish = json['isFinish'] as bool;
}

Map<String, dynamic> _$ShanYanCustomWidgetToJson(ShanYanCustomWidget instance) {
  final val = <String, dynamic>{
    'widgetId': instance.widgetId,
    'left': instance.left,
    'top': instance.top,
    'right': instance.right,
    'bottom': instance.bottom,
    'width': instance.width,
    'height': instance.height,
    'textContent': instance.textContent,
    'textFont': instance.textFont,
    'textColor': instance.textColor,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backgroundColor', instance.backgroundColor);
  writeNotNull('backgroundImgPath', instance.backgroundImgPath);
  val['textAlignment'] =
      _$ShanYanCustomWidgetGravityTypeEnumMap[instance.textAlignment];
  writeNotNull('type', _$ShanYanCustomWidgetTypeEnumMap[instance.type]);
  val['isFinish'] = instance.isFinish;
  return val;
}

const _$ShanYanCustomWidgetTypeEnumMap = {
  ShanYanCustomWidgetType.TextView: 'TextView',
  ShanYanCustomWidgetType.Button: 'Button',
  ShanYanCustomWidgetType.ImageView: 'ImageView',
};

const _$ShanYanCustomWidgetGravityTypeEnumMap = {
  ShanYanCustomWidgetGravityType.left: 'left',
  ShanYanCustomWidgetGravityType.right: 'right',
  ShanYanCustomWidgetGravityType.center: 'center',
};

ShanYanCustomWidgetIOS _$ShanYanCustomWidgetIOSFromJson(
    Map<String, dynamic> json) {
  return ShanYanCustomWidgetIOS(
    json['widgetId'] as String,
    _$enumDecodeNullable(_$ShanYanCustomWidgetTypeEnumMap, json['type']),
  )
    ..left = json['left'] as num?
    ..top = json['top'] as num?
    ..right = json['right'] as num?
    ..bottom = json['bottom'] as num?
    ..width = json['width'] as num?
    ..height = json['height'] as num?
    ..centerX = json['centerX'] as num?
    ..centerY = json['centerY'] as num?
    ..cornerRadius = json['cornerRadius'] as num?
    ..borderWidth = json['borderWidth'] as num?
    ..borderColor = json['borderColor'] as String?
    ..textContent = json['textContent'] as String?
    ..textFont = (json['textFont'] as num?)?.toDouble()
    ..textColor = json['textColor'] as String?
    ..backgroundColor = json['backgroundColor'] as String?
    ..image = json['image'] as String?
    ..backgroundImgPath = json['backgroundImgPath'] as String?
    ..textAlignment =
        _$enumDecode(_$iOSTextAlignmentEnumMap, json['textAlignment'])
    ..navPosition = _$enumDecodeNullable(
        _$ShanYanCustomWidgetiOSNavPositionEnumMap, json['navPosition'])
    ..isFinish = json['isFinish'] as bool;
}

Map<String, dynamic> _$ShanYanCustomWidgetIOSToJson(
    ShanYanCustomWidgetIOS instance) {
  final val = <String, dynamic>{
    'widgetId': instance.widgetId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('left', instance.left);
  writeNotNull('top', instance.top);
  writeNotNull('right', instance.right);
  writeNotNull('bottom', instance.bottom);
  writeNotNull('width', instance.width);
  writeNotNull('height', instance.height);
  writeNotNull('centerX', instance.centerX);
  writeNotNull('centerY', instance.centerY);
  writeNotNull('cornerRadius', instance.cornerRadius);
  writeNotNull('borderWidth', instance.borderWidth);
  writeNotNull('borderColor', instance.borderColor);
  writeNotNull('textContent', instance.textContent);
  writeNotNull('textFont', instance.textFont);
  writeNotNull('textColor', instance.textColor);
  writeNotNull('backgroundColor', instance.backgroundColor);
  writeNotNull('image', instance.image);
  writeNotNull('backgroundImgPath', instance.backgroundImgPath);
  val['textAlignment'] = _$iOSTextAlignmentEnumMap[instance.textAlignment];
  writeNotNull('type', _$ShanYanCustomWidgetTypeEnumMap[instance.type]);
  writeNotNull('navPosition',
      _$ShanYanCustomWidgetiOSNavPositionEnumMap[instance.navPosition]);
  val['isFinish'] = instance.isFinish;
  return val;
}

const _$ShanYanCustomWidgetiOSNavPositionEnumMap = {
  ShanYanCustomWidgetiOSNavPosition.navleft: 'navleft',
  ShanYanCustomWidgetiOSNavPosition.navright: 'navright',
};
