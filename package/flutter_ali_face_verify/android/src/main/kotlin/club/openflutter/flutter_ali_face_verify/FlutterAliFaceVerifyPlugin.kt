package club.openflutter.flutter_ali_face_verify

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.alipay.mobile.android.verify.sdk.ServiceFactory
import com.alipay.mobile.android.verify.sdk.interfaces.ICallback
import com.alipay.mobile.android.verify.sdk.interfaces.IService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterPluginTestPlugin */
class FlutterAliFaceVerifyPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var applicationContext: Context? = null

    private var activity: Activity? = null

    private var mService: IService? = null;

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "club.openflutter/flutter_ali_face_verify")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "initService") {
            if (applicationContext == null) {
                result.success(false)
            } else {
                ServiceFactory.init(applicationContext)
                mService = ServiceFactory.create(activity).build();
                result.success(true)
            }
        } else if (call.method == "startService") {
            Log.e("TAG","---> start service")
            if (activity == null) {
                result.error("-999", "activity is null", null)
            } else {
                val extParams = call.argument<Map<String, Any>>("extParams").orEmpty()
                val certifyId = call.argument<String?>("certifyId")
                val param: MutableMap<String, Any?> = mutableMapOf()
                param.putAll(extParams)
                param["certifyId"] = certifyId
                mService?.startService(
                    param
                ) {
                    result.success(it.orEmpty())
                }
            }
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        applicationContext = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

}
