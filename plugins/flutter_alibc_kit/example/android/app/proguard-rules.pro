-keepattributes Signature
 -ignorewarnings
 -keep class javax.ws.rs.** { *; }
 -keep class com.alibaba.fastjson.** { *; }
 -dontwarn com.alibaba.fastjson.**
 -keep class sun.misc.Unsafe { *; }
 -dontwarn sun.misc.**
 -keep class com.taobao.** {*;}
 -keep class com.alibaba.** {*;}
 -keep class com.alipay.** {*;}

 -dontwarn com.taobao.**
 -dontwarn com.alibaba.**
 -dontwarn com.alipay.**

 -keep class com.ut.** {*;}
 -dontwarn com.ut.**

 -keep class com.ta.** {*;}
 -dontwarn com.ta.**
 -keep class org.json.** {*;}
 -keep class com.ali.auth.**  {*;}
 -dontwarn com.ali.auth.**

 -keep class com.taobao.securityjni.** {*;}
 -keep class com.taobao.wireless.security.** {*;}
 -keep class com.taobao.dp.**{*;}
 -keep class com.alibaba.wireless.security.**{*;}

 -keep interface mtopsdk.mtop.global.init.IMtopInitTask {*;}
 -keep class * implements mtopsdk.mtop.global.init.IMtopInitTask {*;}