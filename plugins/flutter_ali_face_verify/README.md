# flutter_ali_face_verify

A new Flutter project.

## Getting Started
- SDK需要一些权限，请自行申请
- 先调用`initService`

## Android 端
如果找不到认识SDK，那就在`android`下的`build.gradle`添加`        maven {
url "https://mvn.cloud.alipay.com/nexus/content/repositories/open/"
}`
具体如下 :
```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url "https://mvn.cloud.alipay.com/nexus/content/repositories/open/"
        }
    }
}
```

## IOS
 ios podfile 添加`source "https://code.aliyun.com/mpaas-public/podspecs.git"`
因为我不会在`.podspec`添加三方源。。。

## 两端
两端的差异挺大的其实。返回结果，我只能区分一下，也只返回了code。
除了`certifyId`和`bizCode`，所有参数可以通过`extParams`传递，但是请注意可能会有平台差异化。当然只能传递字符串了。。。

