package com.wxwx.flutter_alibc

import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAlibcPlugin */
class FlutterAlibcPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var channel : MethodChannel? = null
  private var handle: FlutterAlibcHandle? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.e("FlutterAlibcPlugin", "onAttachedToEngine ")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_alibc")
    channel!!.setMethodCallHandler(this)
    handle = FlutterAlibcHandle(channel)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android " + Build.VERSION.RELEASE)
    } else if (call.method == "initAlibc") {
      handle?.initAlibc(result)
    } else if (call.method == "openItemDetail") {
      handle?.openItemDetail(call, result)
    } else if (call.method == "loginTaoBao") {
      handle?.loginTaoBao()
    } else if (call.method == "taoKeLogin") {
      handle?.taoKeLogin(call)
    } else if (call.method == "taoKeLoginForCode") {
      handle?.taoKeLoginForCode(call)
    } else if (call.method == "loginOut") {
      handle?.logoutTaoBao(result)
    } else if (call.method == "openByUrl") {
      handle?.openByUrl(call, result)
    } else if (call.method == "openShop") {
      handle?.openShop(call, result)
    } else if (call.method == "openCart") {
      handle?.openCart(call, result)
    } else if (call.method == "syncForTaoke") {
      handle?.syncForTaoke(call)
    } else if (call.method == "useAlipayNative") {
      handle?.useAlipayNative(call)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.e("FlutterAlibcPlugin", "onDetachedFromEngine ")
    channel?.setMethodCallHandler(null)
    handle?.disposed()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.e("FlutterAlibcPlugin", "onAttachedToActivity ")
    handle?.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
    Log.e("FlutterAlibcPlugin", "onAttachedToActivity ")
    handle?.activity = null
  }
}
