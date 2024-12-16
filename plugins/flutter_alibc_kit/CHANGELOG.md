## 0.0.1

完成开发

* TODO: Describe initial release.

## 0.0.2

修改readme

## 0.0.3

Android 修正缺少的接口参数

## 0.0.4

AndroidX 测试

## 0.0.5

1.修复Android与iOS逻辑不一致的地方
2.修复枚举混乱的问题
3.修复Android返回参数不正确的问题
4.通过openurl，openItem，openShop，openCart的返回值在失败的情况下，移除tradeFailResult这个失败的回调data（因为Android没有）

## 0.0.6

升级到百川V4.0.2版本
具体升级变动[百川官方更新说明](https://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.749bbe48KRlbQC&treeId=129&articleId=106383&docType=1#s1)

## 0.0.7

1.修正iOS的回调,感谢[JarvanMo](https://github.com/JarvanMo)
2.修正iOS不传入backUrl导致的崩溃问题

## 0.0.8

新增二次授权获取accessToken用于二次授权登录

## 0.0.8

1.新增淘客登录返回token用于服务端二次登录

## 0.0.9

更新百川sdk到4.0.8

## 0.0.12

iOS 更新到 4.0.1.0
  UIwebview换成Wkwebview
Android4.0.0.8

## 0.0.13

iOS 更新到 4.0.1.0
  UIwebview换成Wkwebview
  支持swift
Android4.0.0.8

## 0.0.14

iOS 4.0.1.0
Android4.0.0.8
iOS的依赖不再保存百川的库了，请自行添加淘宝pod源拉取

## 0.0.15

iOS升级
iOS 4.0.1.6
Android4.0.0.8

## 0.0.16

iOS 4.0.1.6
Android4.0.0.8
修复iOS在某些情况下第一次打开二次授权页面不正常的情况
来自：892371707的修复建议

## 0.0.17

iOS 4.0.1.6
Android4.0.0.8
重构

## 0.0.18

和17一样的代码，测试持续集成用

## 0.0.21-nullsafety

支持空安全

## 1.0.0-nullsafety

双端依赖库全部改为本地依赖，适配最新版SDK，android:4.0.0.40，ios:4.0.1.17