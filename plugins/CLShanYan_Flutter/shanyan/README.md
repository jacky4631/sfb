# flutter 2.3.4 集成文档

注：「[插件示例代码地址](https://github.com/253CL/CLShanYan_Flutter)」<br />

<a name="AiyJS"></a>

## 概述

本文是闪验SDK_flutter **v2.3.4**版本的接入文档，用于指导SDK的使用方法。<br />

<a name="65lmE"></a>

# 创建应用

<br />
应用的创建流程及APPID的获取，请查看「[账号创建](http://flash.253.com/document/details?lid=292&cid=91&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」文档<br
/>**注意：如果应用有多个包名或签名不同的马甲包，须创建多个对应包名和签名的应用，否则马甲包将报包名或签名校验不通过。**<br />

<a name="h4mXI"></a>

### 安装

在工程 pubspec.yaml 中加入 dependencies

- github 集成

```dart
dependencies:shanyan:git:url: git: //github.com/253CL/CLShanYan_Flutter.git
path: shanyan
ref: v2.3.4
.2
```

<a name="UlDef"></a>

### 使用

```dart
import 'package:shanyan/shanyan.dart';
```

<a name="JRH4x"></a>

### 开发环境搭建

<br />权限配置（AndroidManifest.xml文件里面添加权限）<br />
<br />必要权限：<br />

```xml

<uses-permission android:name="android.permission.INTERNET" /><uses-permission
android:name="android.permission.WRITE_SETTINGS" /><uses-permission
android:name="android.permission.ACCESS_WIFI_STATE" /><uses-permission
android:name="android.permission.ACCESS_NETWORK_STATE" /><uses-permission
android:name="android.permission.CHANGE_NETWORK_STATE" /><uses-permission
android:name="android.permission.CHANGE_WIFI_STATE" /><uses-permission
android:name="android.permission.GET_TASKS" />
```

<br />建议的权限：如果选用该权限，需要在预取号步骤前提前动态申请。

```xml

<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

**建议开发者申请本权限，本权限只用于移动运营商在双卡情况下，更精准的获取数据流量卡的运营商类型，**<br />**缺少该权限，存在取号失败概率上升的风险。**<br />
<br />配置权限说明

| **权限名称** | 权限说明 | 使用说明 |
| --- | --- | --- |
| INTERNET | 允许应用程序联网 | 用于访问网关和认证服务器 |
| ACCESS_WIFI_STATE | 允许访问WiFi网络状态信息 | 允许程序访问WiFi网络状态信息 |
| ACCESS_NETWORK_STATE | 允许访问网络状态 | 区分移动网络或WiFi网络 |
| CHANGE_NETWORK_STATE | 允许改变网络连接状态 | 设备在WiFi跟数据双开时，强行切换使用数据网络 |
| CHANGE_WIFI_STATE | 允许改变WiFi网络连接状态 | 设备在WiFi跟数据双开时，强行切换使用 |
| READ_PHONE_STATE | 允许读取手机状态 | （可选）获取IMSI用于判断双卡和换卡 |
| WRITE_SETTINGS | 允许读写系统设置项 | 电信SDK在6.0系统以下进行数据切换用到的权限，添加后可增加电信在WiFi+4G下网络环境下的取号成功率。6.0系统以上可去除 |
| GET_TASKS | 允许应用程序访问TASK |  |

在application标签内配置授权登录activity，screenOrientation和theme可以根据项目需求自行修改<br />

```xml

<activity android:name="com.chuanglan.shanyan_sdk.view.CmccLoginActivity"
    android:configChanges="keyboardHidden|orientation|screenSize" android:launchMode="singleTop"
    android:screenOrientation="behind" />

<activity-alias android:name="com.cmic.sso.sdk.activity.LoginAuthActivity"
android:configChanges="keyboardHidden|orientation|screenSize" android:launchMode="singleTop"
android:screenOrientation="behind"
android:targetActivity="com.chuanglan.shanyan_sdk.view.CmccLoginActivity" /><activity
android:name="com.chuanglan.shanyan_sdk.view.ShanYanOneKeyActivity"
android:configChanges="keyboardHidden|orientation|screenSize" android:launchMode="singleTop"
android:screenOrientation="behind" /><activity
android:name="com.chuanglan.shanyan_sdk.view.CTCCPrivacyProtocolActivity"
android:configChanges="keyboardHidden|orientation|screenSize" android:launchMode="singleTop"
android:screenOrientation="behind" />
```

<br />配置Android9.0对http协议的支持两种方式：<br />
<br />方式一：<br />

```xml
android:usesCleartextTraffic="true"
```

<br />示例代码：<br />

```xml

<application android:name=".view.MyApplication"***android:usesCleartextTraffic="true"></application>
```

<br />方式二：<br />
<br />目前只有移动运营商个别接口为http请求，对于全局禁用Http的项目，需要设置Http白名单。以下为运营商http接口域名：cmpassport.com ;*
.10010.com<br />
<br />(3) 混淆规则：<br />

```java
-dontwarn com.cmic.sso.sdk.**
        -dontwarn com.unicom.xiaowo.account.shield.**
        -dontwarn com.sdk.**
        -keep

class com.cmic.sso.sdk.**{*;}
        -keep

class com.sdk.**{*;}
        -keep

class com.unicom.xiaowo.account.shield.**{*;}
        -keep

class cn.com.chinatelecom.account.api.**{*;}
```

<br />(4) AndResGuard资源压缩过滤：<br />

```java
"R.anim.umcsdk*",
        "R.drawable.umcsdk*",
        "R.layout.layout_shanyan*",
        "R.id.shanyan_view*",
```

<br />通过上面的几个步骤，工程就配置完成了，接下来就可以在工程中使用闪验SDK进行开发了。
<a name="mglDi"></a>

## 一、免密登录API使用说明

<a name="ANoDq"></a>

### 1.初始化

<br />使用一键登录功能前，必须先进行初始化操作。<br />
<br />调用示例<br />

```dart

OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();
oneKeyLoginManager.init(appId: appId).
then
((shanYanResult) {
setState(() {
_code = shanYanResult.code;
_result = shanYanResult.message;
_content = shanYanResult.toJson().toString();
});
```

<br />参数描述

| 参数 | 类型 | 说明 |
| --- | --- | --- |
| appId | String | 闪验平台获取到的appId |

<br />返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String  | 内层事件描述  |
| token | String  | token |

<a name="8Cuhp"></a>

### 2.预取号

- **建议在判断当前用户属于未登录状态时使用，****已登录状态用户请不要调用该方法**
- 建议在执行拉取授权登录页的方法前，提前一段时间调用预取号方法，中间最好有2-3秒的缓冲（因为预取号方法需要1~3s的时间取得临时凭证）
- **请勿频繁的多次调用、请勿与拉起授权登录页同时和之后调用。**
- **避免大量资源下载时调用，例如游戏中加载资源或者更新补丁的时候要顺序执行**

调用示例：<br />

```dart

OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();
oneKeyLoginManager.getPhoneInfo()
.
then
((

ShanYanResult shanYanResult
)
{
setState(() {
_code = shanYanResult.code;
_result = shanYanResult.message;
_content = shanYanResult.toJson().toString();
});

```

返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String  | 内层事件描述  |
| token | String  | token |

<a name="jdF5H"></a>

### 3.拉起授权页

- 调用拉起授权页方法后将会调起运营商授权页面。**已登录状态请勿调用 。**
- **每次调用拉起授权页方法前均需先调用授权页配置方法，否则授权页可能会展示异常。**

<br />调用示例：<br />

```dart
oneKeyLoginManager.openLoginAuth()
.
then
((

ShanYanResult shanYanResult
) {
setState(() {
_code = shanYanResult.code;
_result = shanYanResult.message;
_content = shanYanResult.toJson().toString();
});

if (1000 == shanYanResult.code) {
//拉起授权页成功
} else {
//拉起授权页失败
}
});
```

<br />返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String  | 内层事件描述  |
| token | String  | token（成功情况下返回）用来后台置换手机号。一次有效。 |

<br />授权页点击一键登录监听，需要在拉起授权页方法之前调用

```dart
oneKeyLoginManager.setOneKeyLoginListener((

ShanYanResult shanYanResult
) {
setState(() {
_code = shanYanResult.code;
_result = shanYanResult.message;
_content = shanYanResult.toJson().toString();
});

if (1000 == shanYanResult.code) {
///一键登录获取token成功
} else if (1011 == shanYanResult.code){
///点击返回/取消 （强制自动销毁）
}else{
///一键登录获取token失败
//关闭授权页
oneKeyLoginManager.finishAuthControllerCompletion();
}
});
```

<br />返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String  | 内层事件描述  |
| token | String  | token |

<a name="BRpZP"></a>

### 4.销毁授权页

A.授权页面自动销毁<br />1.在授权登录页面，当用户主动点击左左上角返回按钮时，返回码为1011，SDK将自动销毁授权页；<br />2.安卓
SDK，当用户点击手机的硬件返回键（相当于取消登录），返回码为1011，SDK将自动销毁授权页<br />
3.当用户设置一键登录或者其他自定义控件为自动销毁时，得到回调后，授权页面会自动销毁<br />
<br />B.授权页手动销毁<br />1.当设置一键登录为手动销毁时，点击授权页一键登录按钮成功获取token不会自动销毁授权页，**
请务必在回调中处理完自己的逻辑后手动调用销毁授权页方法。**<br />2.当设置自定义控件为手动销毁时，**请务必在回调中处理完自己的逻辑后手动调用销毁授权页方法。**<br />**<br />
调用示例<br />

```dart

OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();
oneKeyLoginManager.finishAuthControllerCompletion();
```

<a name="WDkUt"></a>

### 5.授权页点击事件监听

<br />调用示例<br />

```dart

OneKeyLoginManager oneKeyLoginManager = new OneKeyLoginManager();
oneKeyLoginManager.setAuthPageActionListener((

AuthPageActionEvent authPageActionEvent
) {
Map map = authPageActionEvent.toMap();
print("setActionListener" + map.toString());
_toast("点击：${map.toString()}");
});
```

<br />返回参数含义如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| type | int | type=1 ，隐私协议点击事件<br />type=2 ，checkbox点击事件<br />type=3 ，"一键登录"按钮点击事件 |
| code | int | type=1 ，隐私协议点击事件，code分为0,1,2,3（协议页序号）<br />type=2 ，checkbox点击事件，code分为0,1（0为未选中，1为选中）<br />type=3 ，"一键登录"按钮点击事件，code分为0,1（0为协议勾选框未选中，1为选中） |
| message | String | 点击事件的详细信息 |

**
<a name="EOGka"></a>

### 6.置换手机号

当一键登录外层code为1000时，您将获取到返回的参数，请将这些参数传递给后端开发人员，并参考「[服务端](https://flash.253.com/document/details?lid=300&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」文档来实现获取手机号码的步骤。<br
/>

<a name="uPVnk"></a>

### 7.授权页界面配置

<a name="Nkxdn"></a>

#### Android部分

<br />调用该方法可实现对三网运营商授权页面个性化设计，**每次调用拉起授权页方法前必须先调用该方法**，否则授权界面会展示异常。（**
三网界面配置内部实现逻辑不同，请务必使用移动、联通、电信卡分别测试三网界面**）<br />
<br />调用示例<br />

```dart

ShanYanUIConfig shanYanUIConfig = ShanYanUIConfig();
shanYanUIConfig.androidPortrait.isFinish = false;
shanYanUIConfig.androidPortrait.setAuthBGImgPath = "
sy_login_test_bg
";
shanYanUIConfig.androidPortrait.setLogoImgPath = "
shanyan_logo
";
shanYanUIConfig.androidPortrait.setAppPrivacyOne = ["协议1", "https://baidu.com/"];
shanYanUIConfig.androidPortrait.setAppPrivacyTwo = ["协议2", "https://baidu.com/"];
shanYanUIConfig.androidPortrait.setAppPrivacyThree = ["协议3", "https://baidu.com/"];
shanYanUIConfig.androidPortrait.setPrivacyText = ["登录即同意", "、", "、", "和", "授权"];
shanYanUIConfig.androidPortrait.setDialogTheme = ["120", "150", "0", "0", "false"];
shanYanUIConfig.androidPortrait.setLogoWidth = 108;
shanYanUIConfig.androidPortrait.setLogoHeight = 45;
shanYanUIConfig.androidPortrait.setLogoHidden = false;
shanYanUIConfig.androidPortrait.setLogoOffsetY = 10;
shanYanUIConfig.androidPortrait.setNumFieldOffsetY = 60;
shanYanUIConfig.androidPortrait.setNumberSize = 18;
shanYanUIConfig.androidPortrait.setLogBtnOffsetY = 120;
shanYanUIConfig.androidPortrait.setLogBtnTextSize = 15;
shanYanUIConfig.androidPortrait.setLogBtnWidth = 250;
shanYanUIConfig.androidPortrait.setLogoHeight = 40;
shanYanUIConfig.androidPortrait.setLogBtnOffsetY = 130;
shanYanUIConfig.androidPortrait.setSloganHidden = true;
```

<br />
<br />ShanYanUIConfig.java配置元素说明<br />是否自动销毁<br />

```dart
bool isFinish; //是否自动销毁 true：是 false：不是
```

授权页背景配置三选一，支持图片，gif图，视频<br />

```dart
  String setAuthBGImgPath; //普通图片
String setAuthBgGifPath; //GIF图片（只支持本地gif图，需要放置到drawable文件夹中）
String setAuthBgVideoPath; //视频背景
```

<br />授权页状态栏<br />

```dart
  bool setStatusBarHidden; //授权页状态栏 设置状态栏是否隐藏
String setStatusBarColor; //设置状态栏背景颜色
bool setLightColor; //设置状态栏字体颜色是否为白色
bool setVirtualKeyTransparent; //设置虚拟键是否透明
```

<br />授权页导航栏<br />

```dart
  bool setFullScreen; //设置是否全屏显示（true：全屏；false：不全屏）默认不全屏
String setNavColor; //设置导航栏背景颜色
String setNavText; //设置导航栏标题文字
String setNavTextColor; //设置导航栏标题文字颜色
int setNavTextSize; //设置导航栏标题文字大小
String setNavReturnImgPath; //设置导航栏返回按钮图标
bool setNavReturnImgHidden = false; //设置导航栏返回按钮是否隐藏（true：隐藏；false：不隐藏）
int setNavReturnBtnWidth; //设置导航栏返回按钮宽度
int setNavReturnBtnHeight; //设置导航栏返回按钮高度
int setNavReturnBtnOffsetRightX; //设置导航栏返回按钮距离屏幕右侧X偏移
int setNavReturnBtnOffsetX; //设置导航栏返回按钮距离屏幕左侧X偏移
int setNavReturnBtnOffsetY; //设置导航栏返回按钮距离屏幕上侧Y偏移
bool setAuthNavHidden; //设置导航栏是否隐藏（true：隐藏；false：不隐藏）
bool setAuthNavTransparent; //设置导航栏是否透明（true：透明；false：不透明）
bool setNavTextBold; //设置导航栏字体是否加粗（true：加粗；false：不加粗）
```

<br />授权页logo<br />

```dart
  String setLogoImgPath; //设置logo图片
int setLogoWidth; //设置logo宽度
int setLogoHeight; //设置logo高度
int setLogoOffsetY; //设置logo相对于标题栏下边缘y偏移
int setLogoOffsetBottomY; //设置logo相对于屏幕底部y偏移
bool setLogoHidden; //设置logo是否隐藏（true：隐藏；false：不隐藏）
int setLogoOffsetX; //设置logo相对屏幕左侧X偏移

```

<br />授权页号码栏<br />

```dart
  String setNumberColor; //设置号码栏字体颜色
int setNumFieldOffsetY; //设置号码栏相对于标题栏下边缘y偏移
int setNumFieldOffsetBottomY; //设置号码栏相对于屏幕底部y偏移
int setNumFieldWidth; //设置号码栏宽度
int setNumFieldHeight; //设置号码栏高度
int setNumberSize; //设置号码栏字体大小
int setNumFieldOffsetX; //设置号码栏相对屏幕左侧X偏移
bool setNumberBold; //设置号码栏字体是否加粗（true：加粗；false：不加粗）
```

<br />授权页登录按钮<br />

```dart
  String setLogBtnText; //设置登录按钮文字
String setLogBtnTextColor; //设置登录按钮文字颜色
String setLogBtnImgPath; //设置授权登录按钮图片
int setLogBtnOffsetY; //设置登录按钮相对于标题栏下边缘Y偏移
int setLogBtnOffsetBottomY; //设置登录按钮相对于屏幕底部Y偏移
int setLogBtnTextSize; //设置登录按钮字体大小
int setLogBtnHeight; //设置登录按钮高度
int setLogBtnWidth; //设置登录按钮宽度
int setLogBtnOffsetX; //设置登录按钮相对屏幕左侧X偏移
bool setLogBtnTextBold; //设置登录按钮字体是否加粗（true：加粗；false：不加粗）
```

<br />授权页隐私栏<br />

```dart
  List<String> setAppPrivacyOne; //设置开发者隐私条款1，包含两个参数：1.名称 2.URL
List<String> setAppPrivacyTwo; //设置开发者隐私条款2，包含两个参数：1.名称 2.URL
List<String> setAppPrivacyThree; //设置开发者隐私条款3，包含两个参数：1.名称 2.URL
bool setPrivacySmhHidden; //设置协议名称是否显示书名号《》，默认显示书名号（true：不显示；false：显示）
int setPrivacyTextSize; //设置隐私栏字体大小
int setPrivacyWidth; //设置隐私栏宽度
List<String> setAppPrivacyColor; //设置隐私条款文字颜色，包含两个参数：1.基础文字颜色 2.协议文字颜色
int setPrivacyOffsetBottomY; //设置隐私条款相对于授权页面底部下边缘y偏移
int setPrivacyOffsetY; //设置隐私条款相对于授权页面标题栏下边缘y偏移
int setPrivacyOffsetX; //设置隐私条款相对屏幕左侧X偏移
bool setPrivacyOffsetGravityLeft; //设置隐私条款文字左对齐（true：左对齐；false：居中）
bool setPrivacyState; //设置隐私条款的CheckBox是否选中（true：选中；false：未选中）
String setUncheckedImgPath; //设置隐私条款的CheckBox未选中时图片
String setCheckedImgPath; //设置隐私条款的CheckBox选中时图片
bool setCheckBoxHidden; //设置隐私条款的CheckBox是否隐藏（true：隐藏；false：不隐藏）
List<int> setCheckBoxWH; //设置checkbox的宽高，包含两个参数：1.宽 2.高
List<int> setCheckBoxMargin; //设置checkbox的间距，包含四个参数：1.左间距 2.上间距 3.右间距 4.下间距
List<String> setPrivacyText; //设置隐私条款名称外的文字,包含五个参数
bool setPrivacyTextBold; //设置协议栏字体是否加粗（true：加粗；false：不加粗）
String setPrivacyCustomToastText; //未勾选协议时toast提示文字
bool? setCheckBoxTipDisable; //设置未勾选协议时 toast 提示是否关闭（true：关闭，false：开启，默认：false）
bool setPrivacyNameUnderline; //协议是否显示下划线
bool setOperatorPrivacyAtLast; //运营商协议是否为最后一个显示
bool setPrivacyGravityHorizontalCenter; //设置隐私协议栏是否居中显示（true：居中；false：居左；默认：false）
bool setPrivacyActivityEnabled; //设置是否使用 SDK 内置协议页 activity（true：使用；false：不使用，只给回调，由开发者根据回调内容自行实现协议页 activity 及相关跳转；默认：true）
```

<br />授权页slogan<br />

```dart
  String setSloganTextColor; //设置slogan文字颜色
int setSloganTextSize; //设置slogan文字字体大小
int setSloganOffsetY; //设置slogan相对于标题栏下边缘y偏移
bool setSloganHidden = false; //设置slogan是否隐藏（true：隐藏；false：不隐藏）
int setSloganOffsetBottomY; //设置slogan相对屏幕底部Y偏移
int setSloganOffsetX; //设置slogan相对屏幕左侧X偏移
bool setSloganTextBold; //设置slogan文字字体是否加粗（true：加粗；false：不加粗）
```

<br />创蓝slogan<br />

```dart
//创蓝slogan设置
int setShanYanSloganOffsetY; //设置创蓝slogan相对于标题栏下边缘y偏移
int setShanYanSloganOffsetBottomY; //设置创蓝slogan相对屏幕底部Y偏移
int setShanYanSloganOffsetX; //设置创蓝slogan相对屏幕左侧X偏移
int setShanYanSloganTextColor; //设置创蓝slogan文字颜色
int setShanYanSloganTextSize; //设置创蓝slogan文字字体大小
bool setShanYanSloganHidden; //设置创蓝slogan是否隐藏（true：隐藏；false：不隐藏）
bool setShanYanSloganTextBold; //设置创蓝slogan文字字体是否加粗（true：加粗；false：不加粗）
```

<br />协议页导航栏<br />

```dart
  int setPrivacyNavColor; //设置协议页导航栏背景颜色
bool setPrivacyNavTextBold; //设置协议页导航栏标题文字是否加粗（true：加粗；false：不加粗）
int setPrivacyNavTextColor; //设置协议页导航栏标题文字颜色
int setPrivacyNavTextSize; //设置协议页导航栏标题文字大小
String setPrivacyNavReturnImgPath; //设置协议页导航栏返回按钮图标
bool setPrivacyNavReturnImgHidden; //设置协议页导航栏返回按钮是否隐藏（true：隐藏；false：不隐藏）
int setPrivacyNavReturnBtnWidth; //设置协议页导航栏返回按钮宽度
int setPrivacyNavReturnBtnHeight; //设置协议页导航栏返回按钮高度
int setPrivacyNavReturnBtnOffsetRightX; //设置协议页导航栏返回按钮距离屏幕右侧X偏移
int setPrivacyNavReturnBtnOffsetX; //设置协议页导航栏返回按钮距离屏幕左侧X偏移
int setPrivacyNavReturnBtnOffsetY; //设置协议页导航栏返回按钮距离屏幕上侧Y偏移
```

<br />授权页隐私协议框<br />

```dart
  String addCustomPrivacyAlertView; //添加授权页上显示隐私协议弹框
```

<br />授权页loading<br />

```dart
  String setLoadingView; //设置授权页点击一键登录自定义loading
```

<br />授权页弹窗样式<br />

```dart

List<
    String>setDialogTheme; //设置授权页为弹窗样式，包含5个参数：1.弹窗宽度 2.弹窗高度 3.弹窗X偏移量（以屏幕中心为原点） 4.弹窗Y偏移量（以屏幕中心为原点） 5.授权页弹窗是否贴于屏幕底部

```

<br />**注意：**<br />**a.控件X偏移如果不设置默认居中。**<br />
<br />添加自定义控件<br />
<br />调用示例

```dart

List<ShanYanCustomWidget> shanyanCustomWidget = [];
final String btn_widgetId = "other_custom_button"; // 标识控件 id
ShanYanCustomWidget buttonWidget =
ShanYanCustomWidget(btn_widgetId, ShanYanCustomWidgetType.TextView);
buttonWidget.textContent = "
其他方式登录 >
";
buttonWidget.bottom = 200;
buttonWidget.width = 150;
buttonWidget.height = 40;
buttonWidget.backgroundColor ="
#330000
";
buttonWidget.isFinish = false;
//buttonWidget.btnNormalImageName = "";
//buttonWidget.btnPressedImageName = "";
buttonWidget.textAlignment = ShanYanCustomWidgetGravityType.center;shanYanUIConfig.androidPortrait
    .widgets = shanyanCustomWidget;
// 添加点击事件监听
oneKeyLoginManager.addClikWidgetEventListener((
eventId) {
_toast("点击了：" + eventId);
});

```

<br />参数说明<br />

```dart
  String widgetId; //自定义控件ID
int left = 0; // 自定义控件距离屏幕左边缘偏移量，单位dp
int top = 0; // 自定义控件距离导航栏底部偏移量，单位dp
int right = 0; // 自定义控件距离屏幕右边缘偏移量，单位dp
int bottom = 0; // 自定义控件距离屏幕底部偏移量，单位dp
int width = 0; // 自定义控件宽度，单位dp
int height = 0; // 自定义控件高度，单位dp
String textContent = ""; // 自定义控件内容
double textFont = 13.0; // 自定义控件文字大小，单位sp
String textColor = "#aa0000"; // 自定义控件文字颜色
String backgroundColor; // 自定义控件背景颜色
String backgroundImgPath; // 自定义控件背景图片
ShanYanCustomWidgetGravityType textAlignment; //自定义控件内容对齐方式
ShanYanCustomWidgetType type; //自定义控件类型，目前只支持 textView,button
bool isFinish = true; //点击自定义控件是否自动销毁授权页
```

<br />

<a name="pRSxu"></a>

#### IOS部分

<br />调用该方法可实现对三网运营商授权页面个性化设计。（**三网界面配置内部实现逻辑不同，请务必使用移动、联通、电信卡分别测试三网界面**）<br />
<br />调用示例<br />

```dart
 /*iOS 页面样式设置*/
shanYanUIConfig.ios.isFinish = false;
shanYanUIConfig.ios.setAuthBGImgPath = "
sy_login_test_bg
";

shanYanUIConfig.ios.setPreferredStatusBarStyle = iOSStatusBarStyle.styleLightContent;shanYanUIConfig
    .ios.setStatusBarHidden = false;
shanYanUIConfig.ios.setAuthNavHidden = false;
shanYanUIConfig.ios.setNavigationBarStyle = iOSBarStyle.styleBlack;shanYanUIConfig.ios
    .setAuthNavTransparent = true;

shanYanUIConfig.ios.setNavText = "
测试
";
shanYanUIConfig.ios.setNavTextColor = "
#80ADFF
";
shanYanUIConfig.ios.setNavTextSize = 18;

shanYanUIConfig.ios.setNavReturnImgPath = "
nav_button_white
";
shanYanUIConfig.ios.setNavReturnImgHidden = false;

//    shanYanUIConfig.ios.setNavBackBtnAlimentRight = true;

shanYanUIConfig.ios.setNavigationBottomLineHidden = false;

shanYanUIConfig.ios.setNavigationTintColor = "
#FF6659
";
shanYanUIConfig.ios.setNavigationBarTintColor = "
#BAFF8C
";
shanYanUIConfig.ios.setNavigationBackgroundImage = "
圆角矩形 2 拷贝
";

//    shanYanUIConfig.ios.setNavigationShadowImage =

shanYanUIConfig.ios.setLogoImgPath = "
logo_shanyan_text
";
//    shanYanUIConfig.ios.setLogoCornerRadius = 30;
shanYanUIConfig.ios.setLogoHidden = false;

shanYanUIConfig.ios.setNumberColor = "
#499191
";
shanYanUIConfig.ios.setNumberSize = 20;
shanYanUIConfig.ios.setNumberBold = true;
shanYanUIConfig.ios.setNumberTextAlignment = iOSTextAlignment.right;

shanYanUIConfig.ios.setLogBtnText = "
测试一键登录
";
shanYanUIConfig.ios.setLogBtnTextColor = "
#FFFFFF
";
shanYanUIConfig.ios.setLoginBtnTextSize = 16;
shanYanUIConfig.ios.setLoginBtnTextBold = false;
shanYanUIConfig.ios.setLoginBtnBgColor = "
#0000FF
";

//    shanYanUIConfig.ios.setLoginBtnNormalBgImage = "2-0btn_15";
//    shanYanUIConfig.ios.setLoginBtnHightLightBgImage = "圆角矩形 2 拷贝";
//    shanYanUIConfig.ios.setLoginBtnDisabledBgImage = "login_btn_normal";

//    shanYanUIConfig.ios.setLoginBtnBorderColor = "#FF7666";
shanYanUIConfig.ios.setLoginBtnCornerRadius = 20;
//    shanYanUIConfig.ios.setLoginBtnBorderWidth = 2;

shanYanUIConfig.ios.setPrivacyTextSize = 10;
shanYanUIConfig.ios.setPrivacyTextBold = false;

shanYanUIConfig.ios.setAppPrivacyTextAlignment = iOSTextAlignment.center;shanYanUIConfig.ios
    .setPrivacySmhHidden = true;
shanYanUIConfig.ios.setAppPrivacyLineSpacing = 5;
shanYanUIConfig.ios.setAppPrivacyNeedSizeToFit = false;
shanYanUIConfig.ios.setAppPrivacyLineFragmentPadding = 10;
shanYanUIConfig.ios.setAppPrivacyAbbreviatedName = "
666
";
shanYanUIConfig.ios.setAppPrivacyColor = ["#808080", "#00cc00"];

shanYanUIConfig.ios.setAppPrivacyNormalDesTextFirst = "
Accept
";
//    shanYanUIConfig.ios.setAppPrivacyTelecom = "中国移动服务协议";
shanYanUIConfig.ios.setAppPrivacyNormalDesTextSecond = "
and
";
shanYanUIConfig.ios.setAppPrivacyFirst = ["测试连接A", "https://www.baidu.com"];
shanYanUIConfig.ios.setAppPrivacyNormalDesTextThird = "
&
";
shanYanUIConfig.ios.setAppPrivacySecond = ["测试连接X", "https://www.sina.com"];
shanYanUIConfig.ios.setAppPrivacyNormalDesTextFourth = "
、
";
shanYanUIConfig.ios.setAppPrivacyThird = ["测试连接C", "https://www.sina.com"];
shanYanUIConfig.ios.setAppPrivacyNormalDesTextLast = "
to login
";

//    shanYanUIConfig.ios.setOperatorPrivacyAtLast = true;
//    shanYanUIConfig.ios.setPrivacyNavText = "闪验运营商协议";
//    shanYanUIConfig.ios.setPrivacyNavTextColor = "#7BC1E8";
//    shanYanUIConfig.ios.setPrivacyNavTextSize = 15;
//    shanYanUIConfig.ios.setPrivacyNavReturnImgPath = "close-black";

shanYanUIConfig.ios.setAppPrivacyWebPreferredStatusBarStyle = iOSStatusBarStyle
    .styleDefault;shanYanUIConfig.ios.setAppPrivacyWebNavigationBarStyle = iOSBarStyle.styleDefault;

//运营商品牌标签("中国**提供认证服务")，不得隐藏
shanYanUIConfig.ios.setSloganTextSize = 11;
shanYanUIConfig.ios.setSloganTextBold = false;
shanYanUIConfig.ios.setSloganTextColor = "
#CEBFFF
";
shanYanUIConfig.ios.setSloganTextAlignment = iOSTextAlignment.center;

//供应商品牌标签("创蓝253提供认技术支持")
shanYanUIConfig.ios.setShanYanSloganTextSize = 11;
shanYanUIConfig.ios.setShanYanSloganTextBold = true;
shanYanUIConfig.ios.setShanYanSloganTextColor = "
#7BC1E8
";
shanYanUIConfig.ios.setShanYanSloganTextAlignment = iOSTextAlignment.center;shanYanUIConfig.ios
    .setShanYanSloganHidden = false;

shanYanUIConfig.ios.setCheckBoxHidden = false;
shanYanUIConfig.ios.setPrivacyState = false;
//    shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyTop = true;
shanYanUIConfig.ios.setCheckBoxVerticalAlignmentToAppPrivacyCenterY = true;
shanYanUIConfig.ios.setUncheckedImgPath = "
checkBoxNor
";
shanYanUIConfig.ios.setCheckedImgPath = "
checkBoxNor
";
shanYanUIConfig.ios.setCheckBoxWH = [
40
,
40
];
shanYanUIConfig.ios.setCheckBoxImageEdgeInsets = [6,12,6,0];

shanYanUIConfig.ios.setLoadingCornerRadius = 10;
shanYanUIConfig.ios.setLoadingBackgroundColor = "
#E68147
";
shanYanUIConfig.ios.setLoadingTintColor = "
#1C7EFF
";

shanYanUIConfig.ios.setShouldAutorotate = false;
shanYanUIConfig.ios.supportedInterfaceOrientations = iOSInterfaceOrientationMask.all;shanYanUIConfig
    .ios.preferredInterfaceOrientationForPresentation = iOSInterfaceOrientation.portrait;

shanYanUIConfig.ios.setAuthTypeUseWindow = true;
shanYanUIConfig.ios.setAuthWindowCornerRadius = 10;

shanYanUIConfig.ios.setAuthWindowModalTransitionStyle = iOSModalTransitionStyle.flipHorizontal;
//    shanYanUIConfig.ios.setAuthWindowModalPresentationStyle = iOSModalPresentationStyle.fullScreen;
shanYanUIConfig.ios.setAppPrivacyWebModalPresentationStyle = iOSModalPresentationStyle
    .fullScreen;shanYanUIConfig.ios.setAuthWindowOverrideUserInterfaceStyle = iOSUserInterfaceStyle
    .unspecified;

shanYanUIConfig.ios.setAuthWindowPresentingAnimate = true;

//弹窗中心位置
shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationCenterX = screenWidthPortrait*0.5;
shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationCenterY = screenHeightPortrait*0.5;

shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationWidth = 300;
shanYanUIConfig.ios.layOutPortrait.setAuthWindowOrientationHeight = screenWidthPortrait*0.7;

//logo
shanYanUIConfig.ios.layOutPortrait.setLogoTop = 40;
shanYanUIConfig.ios.layOutPortrait.setLogoWidth = 80;
shanYanUIConfig.ios.layOutPortrait.setLogoHeight = 40;
shanYanUIConfig.ios.layOutPortrait.setLogoCenterX = 0;
//手机号控件
shanYanUIConfig.ios.layOutPortrait.setNumFieldTop = 40
+
40;
shanYanUIConfig.ios.layOutPortrait.setNumFieldCenterX = 0;
shanYanUIConfig.ios.layOutPortrait.setNumFieldHeight = 30;
shanYanUIConfig.ios.layOutPortrait.setNumFieldWidth = 150;
//一键登录按钮
shanYanUIConfig.ios.layOutPortrait.setLogBtnTop = 80
+
20
+
20;
shanYanUIConfig.ios.layOutPortrait.setLogBtnCenterX = 0;
shanYanUIConfig.ios.layOutPortrait.setLogBtnHeight = 40;
shanYanUIConfig.ios.layOutPortrait.setLogBtnWidth = 200;

//授权页 创蓝slogan（创蓝253提供认证服务）
shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight = 15;
shanYanUIConfig.ios.layOutPortrait.setShanYanSloganLeft = 0;
shanYanUIConfig.ios.layOutPortrait.setShanYanSloganRight = 0;
shanYanUIConfig.ios.layOutPortrait.setShanYanSloganBottom = 15;

//授权页 slogan（***提供认证服务）
shanYanUIConfig.ios.layOutPortrait.setSloganHeight = 15;
shanYanUIConfig.ios.layOutPortrait.setSloganLeft = 0;
shanYanUIConfig.ios.layOutPortrait.setSloganRight = 0;
shanYanUIConfig.ios.layOutPortrait.setSloganBottom = shanYanUIConfig.ios.layOutPortrait
    .setShanYanSloganBottom+ shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight;

//隐私协议
//    shanYanUIConfig.ios.layOutPortrait.setPrivacyHeight = 50;
shanYanUIConfig.ios.layOutPortrait.setPrivacyLeft = 30;
shanYanUIConfig.ios.layOutPortrait.setPrivacyRight = 30;
shanYanUIConfig.ios.layOutPortrait.setPrivacyBottom = shanYanUIConfig.ios.layOutPortrait
    .setSloganBottom+ shanYanUIConfig.ios.layOutPortrait.setShanYanSloganHeight;


```

<br />
<br />添加自定义控件<br />
<br />调用示例<br />

```dart

List<ShanYanCustomWidgetIOS> shanyanCustomWidgetIOS = [];

final String btn_widgetId = "other_custom_button"; // 标识控件 id
ShanYanCustomWidgetIOS buttonWidgetiOS =
ShanYanCustomWidgetIOS(btn_widgetId, ShanYanCustomWidgetType.Button);
buttonWidgetiOS.textContent = "
其他方式登录 >
";
buttonWidgetiOS.centerY = 100;
buttonWidgetiOS.centerX = 0;
buttonWidgetiOS.width = 150;
//    buttonWidgetiOS.left = 50;
//    buttonWidgetiOS.right = 50;
buttonWidgetiOS.height = 40;
buttonWidgetiOS.backgroundColor = "
#330000
";
buttonWidgetiOS.isFinish = true;
buttonWidgetiOS.textAlignment = iOSTextAlignment.center;

shanyanCustomWidgetIOS.add(buttonWidgetiOS);

final String nav_right_btn_widgetId = "other_custom_nav_right_button"; // 标识控件 id
ShanYanCustomWidgetIOS navRightButtonWidgetiOS =
ShanYanCustomWidgetIOS(nav_right_btn_widgetId, ShanYanCustomWidgetType.Button);
navRightButtonWidgetiOS.navPosition = ShanYanCustomWidgetiOSNavPosition
    .navright;navRightButtonWidgetiOS.textContent = "
联系客服
";
navRightButtonWidgetiOS.width = 60;
navRightButtonWidgetiOS.height = 40;
navRightButtonWidgetiOS.textColor = "
#11EF33
";
navRightButtonWidgetiOS.backgroundColor = "
#FDECA3
";
navRightButtonWidgetiOS.isFinish = true;
navRightButtonWidgetiOS.textAlignment = iOSTextAlignment.center;

shanyanCustomWidgetIOS.add(navRightButtonWidgetiOS);

shanYanUIConfig.ios.widgets = shanyanCustomWidgetIOS;

```

<br />**注意：如果添加布局为自定义控件，监听实现请参考demo示例。**<br />**
<a name="D9qrI"></a>

## 二、本机认证API使用说明

<br />**注：本机认证同免密登录，需要初始化，本机认证、免密登录可共用初始化，两个功能同时使用时，只需调用一次初始化即可。**<br />**
<a name="C1ZCW"></a>

### 1.初始化

<br />**同免密登录初始化**<br />**
<a name="Lqzq4"></a>

### 2.本机号校验

<br />在初始化执行之后调用，本机号校验界面需自行实现，可以在多个需要校验的页面中调用。<br />
<br />调用示例：<br />

```dart
//闪验SDK 本机号校验获取token (Android+iOS)
oneKeyLoginManager.startAuthentication()
.
then
((shanYanResult) {
setState(() {
_code = shanYanResult.code;
_result = shanYanResult.message;
_content = shanYanResult.toJson().toString();
});
```

<br />返回为ShanYanResult对象属性如下：

| **字段** | **类型** | **含义** |
| --- | --- | --- |
| code | Int | code为1000:成功；其他：失败 |
| message | String | 描述 |
| innerCode | Int | 内层返回码 |
| innerDesc | String  | 内层事件描述  |
| token | String  | token（成功情况下返回）用来和后台校验手机号。一次有效。 |

<a name="ApxrD"></a>

### 3.校验手机号

<br />
当本机号校验外层code为2000时，您将获取到返回的参数，请将这些参数传递给后端开发人员，并参考「[服务端](http://flash.253.com/document/details?lid=300&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」文档来实现校验本机号的步骤
<a name="dCHBW"></a>

## 三、返回码

该返回码为闪验SDK自身的返回码，请注意1003及1023错误内均含有运营商返回码，具体错误在碰到之后查阅「[返回码](http://flash.253.com/document/details?lid=301&cid=93&pc=28&pn=%25E9%2597%25AA%25E9%25AA%258CSDK)」<br
/>

