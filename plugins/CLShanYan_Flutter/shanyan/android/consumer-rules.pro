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
