# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-dontwarn com.cmic.gen.sdk.**
-keep class com.cmic.gen.sdk.**{*;}
-dontwarn com.sdk.**
-keep class com.sdk.** { *;}
-dontwarn cn.com.chinatelecom.account.**
-keep class cn.com.chinatelecom.account.**{*;}
-keep public class * extends android.app.Activity

-keep  class com.chuanglan.shanyan_sdk.OneKeyLoginManager{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.tool.CheckAuthTool{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.tool.CLCustomViewSetting{
    public  *;
}
-keepclasseswithmembers class com.chuanglan.shanyan_sdk.tool.ShanYanUIConfig$Builder{
      <methods>;
}
-keep  class com.chuanglan.shanyan_sdk.listener.**{
    public  *;
}
-keep  class com.chuanglan.shanyan_sdk.tool.ConfigPrivacyBean{
    public  *;
}