# 苏分宝淘客系统 · Flutter APP

苏分宝是一套包含 **Flutter APP、运营管理后台和 Java 服务端** 的淘客系统，围绕商品查券、推广转链、订单采集、佣金结算、分销与提现开展业务。

本仓库为开源版 Flutter APP `sfb`，用于构建 Android / iOS 客户端。当前插件已适配 **Flutter 3.47.3 / Dart 3.13.3**，业务接口由 `sfb_server` 的 APP 服务提供。

开源版功能按当前 `sfb_admin`、`sfb_server`、`sfb` 三个项目整理；商业版能力与交付范围参照官方文档。

[官方文档](https://www.mailvor.com) · [功能对比](https://www.mailvor.com/01.介绍/30.functional.html) · [演示体验](https://www.mailvor.com/01.介绍/20.demo.html) · [版本与授权](https://www.mailvor.com/01.介绍/40.price.html)

## 项目组成

| 项目 | 用途 | 源码 |
| --- | --- | --- |
| `sfb_admin` | 运营管理后台：用户、订单、财务、营销、配置及系统管理 | [GitHub](https://github.com/jacky4631/sfb_admin) · [Gitee](https://gitee.com/jacky4631/sfb_admin) |
| `sfb_server` | 管理端 API、APP API、第三方平台对接与定时任务 | [GitHub](https://github.com/jacky4631/sfb_server) · [Gitee](https://gitee.com/jacky4631/sfb_server) |
| `sfb`（本仓库） | Android / iOS Flutter APP | [GitHub](https://github.com/jacky4631/sfb) · [Gitee](https://gitee.com/jacky4631/sfb) |

## 当前开源版功能

以下为当前三端源码包含的业务模块。第三方联盟、支付、短信、推送等功能需要配置自己的账号、密钥、证书与对应权限。

| 模块 | 已包含的功能 |
| --- | --- |
| 商品与平台对接 | 淘宝、京东、拼多多、唯品会、抖音相关商品查询、详情、转链与订单模块；美团外卖、饿了么等活动入口与相关接口 |
| 查券与推广 | 关键词搜索、联想词、搜索历史、商品排序、链接 / 口令识别查券、分享与推广海报 |
| 用户与账号 | 手机验证码、一键登录、微信与 Apple 登录；昵称头像、地址、账号注销、实名核验与签约相关流程 |
| 订单与收益 | 多平台订单列表、订单绑定用户与找回、订单采集与归属处理、收益预估、佣金明细与结算 |
| 分销与会员 | 邀请码、好友与推广关系、会员等级、分润比例、会员订单与支付配置 |
| 财务管理 | 用户余额、账单、提现申请、审核与记录，微信 / 支付宝等支付和打款相关模块 |
| 积分与营销 | 积分配置与记录、签到天数、用户任务、积分商品与兑换订单、活动与消息配置 |
| 个人中心 | 收藏、分享 APP、消息分类入口、意见反馈、帮助与企业微信客服入口 |
| 微信管理 | 微信菜单、图文管理、自动回复、密钥配置、微信支付配置、模板消息及直播相关管理页面 |
| 商城与运营配置 | 订单消息、热门搜索、个人中心菜单、商城参数、短信、物流、APP 版本与美团活动配置 |
| 系统管理 | 后台用户、角色、菜单权限、部门、岗位、字典；角色菜单权限抽屉分配 |
| 系统监控与工具 | 在线用户、操作日志、异常日志、SQL 监控、定时任务、代码生成、存储、邮件、支付宝工具与接口文档入口 |

菜单是否显示还取决于数据库菜单数据与角色权限。仓库中保留的页面或配置入口，不等于已具备商业版同名功能的完整三端流程。

## 开源版与商业版

两版都围绕淘客业务展开。当前开源版已升级 Vue 3 和 Flutter 插件，**技术栈版本不能再作为区分两版的主要依据**；商业版重点在更多业务场景、运营能力与交付服务。

| 方向 | 当前开源版 | 商业版（按官方文档） |
| --- | --- | --- |
| 淘客业务 | 商品查券、转链、订单、分销、会员、提现等已有源码模块 | 在基础业务上提供更多平台与运营配置 |
| 本地生活与平台扩展 | 已含抖音、美团外卖、饿了么等相关模块 | 文档另覆盖淘宝闪购、京东外卖、美团团购、滴滴出行、美团霸王餐等场景 |
| 品牌与页面定制 | 可通过修改源码与现有配置调整页面 | 自定义装修、模板与页面管理、按 APP 版本绑定模板、模板导入导出 |
| 租户与团队运营 | 当前三仓库未提供商业版完整的租户运营能力 | SaaS 租户、独立 APP / 配置 / 用户 / 订单数据，团长页面与独立分佣管理 |
| 价格与结算 | 现有订单解锁、佣金和结算配置 | 一键价保与价格监控，确认收货结算、固定日期结算等增强能力 |
| 打包与多端 | Flutter APP 本地编译 Android / iOS | Android / iOS 在线打包，uni-app 小程序与独立鸿蒙构建方案 |
| 交付与服务 | 三端源码，自助搭建与二次开发 | 按商业子版本提供安装包 / 源码、部署、环境搭建与售后服务 |

商业版交付分为：

| 版本 | 源码交付范围 |
| --- | --- |
| 商业部署版 | 安装包，不含源码 |
| 商业标准版 | 服务端安装包 + 其他端源码 |
| 商业高级版 | 全部源码 |
| 商业企业级版 | 全部源码，另含在线打包源码与文档站源码 |

价格、授权主体数量、外包交付权限与升级服务，请查看[版本与授权说明](https://www.mailvor.com/01.介绍/40.price.html)，README 不维护报价副本。

## 技术栈与运行环境

| 端 | 当前开源版 | 商业版文档说明 |
| --- | --- | --- |
| 管理端 | Vue 3.5、Element Plus 2、Vite 5、Pinia、Vue Router 4；建议 Node.js 20+ | Vue 3、Element Plus、Node.js 20+ |
| APP | 本次升级验证使用 Flutter 3.47.3 / Dart 3.13.3；约束为 Flutter ≥ 3.44、Dart ≥ 3.12 | Flutter 3.47.3 / Dart 3.13.3 |
| 服务端 | Java 8、Spring Boot 2.6.7、MyBatis Plus | Java 25、Spring Boot 4.1.1 |
| 数据存储 | MySQL 5.7、Redis | MySQL 5.7+、Redis |
| 小程序 / 鸿蒙 | 本 README 对应的三个开源仓库未包含独立交付端 | uni-app 小程序；鸿蒙使用独立 Flutter-OH 工具链，详见对应文档 |

当前开源 APP 最低支持 **Android 7.0（API 24）/ iOS 15**。Android 构建配置为 AGP 8.11.1、Gradle 8.14、Kotlin 2.3.20、JDK 17；iOS 本地构建需要 macOS 与 Xcode。APP 的 Android JDK 与服务端 Java 8 是两套构建环境。

## APP 项目结构

```text
sfb/
├── lib/
│   ├── main.dart       # 应用入口
│   ├── base.dart       # 开发与生产服务地址
│   ├── httpUrl.dart    # 接口路径与网络客户端
│   ├── service.dart    # 业务接口封装
│   ├── index/          # 首页与主导航
│   ├── login/          # 登录流程
│   ├── page/           # 商品等业务页面
│   ├── order/          # 订单与收益
│   ├── me/             # 个人中心
│   └── util/           # 全局配置与工具
├── android/            # Android 工程与签名配置
├── ios/                # iOS 工程与 CocoaPods 配置
├── assets/             # 图片、字体等资源
├── package/            # 本地 Flutter 组件
└── pubspec.yaml        # Flutter 依赖与资源清单
```

## APP 快速启动

### 1. 准备环境与服务端

本次升级验证使用 **Flutter 3.47.3 / Dart 3.13.3**。安装 Flutter 后先运行：

```bash
flutter --version
flutter doctor -v
```

Android 使用 JDK 17、SDK 37、NDK `28.2.13676358`；iOS 使用 macOS、Xcode 和 CocoaPods。确认后端的 `mshop-app` 已启动，默认端口 `8008`、上下文 `/api`。

### 2. 获取代码与依赖

```bash
git clone https://gitee.com/jacky4631/sfb.git
cd sfb
flutter pub get
```

`package/` 中包含本地组件，需与主工程一起保留。部分插件通过 Git 获取，具体版本以 `pubspec.yaml` 与 `pubspec.lock` 为准。

### 3. 配置接口与第三方服务

在 `lib/base.dart` 中设置开发和生产服务地址，例如：

```dart
static final baseHost = kDebugMode
    ? 'http://192.168.1.100:8008'
    : 'https://api.example.com';
```

上面的 IP 与域名仅为示例。真机调试应填写手机可访问的开发机 IP，不能使用手机自身的 `localhost`。代码会拼接 `/api`，`baseHost` 不要再次追加该前缀。

按启用功能配置以下项目：

| 项目 | 主要位置或说明 |
| --- | --- |
| 应用标识、图标与资源 | `android/`、`ios/`、`assets/`、`pubspec.yaml` |
| Android 签名 | `android/app/build.gradle`，替换证书路径、别名和密码为自己的配置 |
| iOS 签名与权限 | 使用 Xcode 配置 Bundle ID、Team、描述文件、Capabilities 与 `ios/Runner/Info.plist` |
| 微信、极光等客户端参数 | `lib/util/global.dart` 及原生工程相关配置 |
| 百川、支付、一键登录、人脸核验 | 按平台准备账号、证书、安全图与权限，并同步配置对应服务端参数 |

配置细节见 [APP 准备](https://www.mailvor.com/02.开源版本/01.开发文档/30.app-prepare.html) 和 [APP 启动文档](https://www.mailvor.com/02.开源版本/01.开发文档/60.start-app.html)。

### 4. 调试运行

```bash
flutter devices
flutter run
```

多设备连接时可使用 `flutter run -d DEVICE_ID` 指定设备。修改顶层服务地址或已创建网络客户端的超时配置后，执行热重启或重新运行。

## 打包与检查

### Android

配置自己的签名证书后执行：

```bash
flutter build apk --release
```

APK 默认位于 `build/app/outputs/flutter-apk/app-release.apk`。本地 Android 构建使用 **JDK 17**；若 Flutter 自动选中了 Android Studio 的其他 JDK，请先确认 `flutter doctor -v` 显示的实际 Java 环境。

### iOS

```bash
cd ios
pod install
cd ..
open ios/Runner.xcworkspace
```

在 Xcode 中配置签名后运行真机或执行 Archive。需要通过命令行验证时可使用：

```bash
flutter build ios --debug --no-codesign
```

该命令生成未签名应用包，用于编译验证；安装真机需有效签名。

当前工程同时使用 Swift Package Manager 与 CocoaPods。若旧工作区升级后仍锁定旧版人脸 SDK，可在 `ios/` 执行 `pod update --no-repo-update` 后重新构建。保留工程中的百川资源复制与静态 framework 清理构建阶段，这是当前 iOS 安装包所需的处理。

### 本地检查

```bash
flutter analyze --no-pub --no-fatal-warnings --no-fatal-infos
flutter test --no-pub test/single_flight_test.dart
```

静态检查仍有历史 warning / info，上述参数允许保留这些提示，但不会忽略 error。详细发布流程见 [APP 打包文档](https://www.mailvor.com/02.开源版本/02.部署文档/30.app-build.html)。

## 文档与演示

| 内容 | 入口 |
| --- | --- |
| 项目介绍与技术架构 | [框架介绍](https://www.mailvor.com/01.介绍/10.introduce.html) |
| 开源版开发与部署 | [开发文档](https://www.mailvor.com/02.开源版本/01.开发文档/00.introduce.html) |
| 商业版能力清单 | [功能对比](https://www.mailvor.com/01.介绍/30.functional.html) |
| APP / 小程序及后台体验 | [演示中心](https://www.mailvor.com/01.介绍/20.demo.html) |
| 商业版搭建流程 | [商业版文档](https://www.mailvor.com/03.商业版本/01.前期准备/10.introduce.html) |
| 授权与咨询 | [版本与授权](https://www.mailvor.com/01.介绍/40.price.html#联系客服) |

演示中心包含商业版功能与租户演示，不能直接作为当前开源仓库的功能验收清单。开源版以本 README 和对应源码为准，商业版以官方文档及具体交付版本为准。

## 使用与版权

完整使用条件见本仓库 [LICENSE](LICENSE) 与官方授权说明。保留项目原有使用约定：

1. 允许用于个人学习、毕业设计、教学案例、公益事业及取得授权后的商业使用。
2. 商用必须保留版权信息，并支付商用授权费用。
3. 禁止将本项目的代码与资源进行任何形式的出售。

具体授权范围与交付权益见[版本与授权说明](https://www.mailvor.com/01.介绍/40.price.html)。第三方源码、插件及二进制文件的版权与许可按各自声明执行。

Copyright © 2018–2026 MAILVOR。苏分宝商标与著作权归苏州迈沃通信有限公司所有。All rights reserved.

## 界面演示（商业版）

以下截图取自官方文档 `tsq-docs/docs/public/home`，使用其现有缩略图，按浏览路径排列。它们展示商业版演示 APP 的界面，包含一键价保、淘宝闪购等商业版功能；当前开源版界面与功能请以上文说明为准。更多体验入口见[演示中心](https://www.mailvor.com/01.介绍/20.demo.html)。

<table>
  <tr>
    <th>首页与快捷入口</th>
    <th>多平台商品搜索</th>
    <th>商品与返利榜单</th>
  </tr>
  <tr>
    <td><img src="demoimages/readme/home.jpg" alt="商业版：首页与快捷入口" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/search.jpg" alt="商业版：多平台商品搜索" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/ranking.jpg" alt="商业版：商品与返利榜单" width="240" loading="lazy"></td>
  </tr>
</table>

<table>
  <tr>
    <th>美团外卖红包</th>
    <th>积分签到与任务</th>
    <th>个人中心</th>
  </tr>
  <tr>
    <td><img src="demoimages/readme/takeaway.jpg" alt="商业版：美团外卖红包" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/points.jpg" alt="商业版：积分签到与任务" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/profile.jpg" alt="商业版：个人中心" width="240" loading="lazy"></td>
  </tr>
</table>

<table>
  <tr>
    <th>一键价保与价格监控</th>
    <th>淘宝闪购外卖红包</th>
    <th>提现页面</th>
  </tr>
  <tr>
    <td><img src="demoimages/readme/price-protection.jpg" alt="商业版：一键价保与价格监控" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/flash-delivery.jpg" alt="商业版：淘宝闪购外卖红包" width="240" loading="lazy"></td>
    <td><img src="demoimages/readme/withdraw.jpg" alt="商业版：提现页面" width="240" loading="lazy"></td>
  </tr>
</table>
