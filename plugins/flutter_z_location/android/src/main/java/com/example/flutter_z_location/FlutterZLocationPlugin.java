package com.example.flutter_z_location;

import static android.content.pm.PackageManager.PERMISSION_GRANTED;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.location.Criteria;
import android.location.LocationManager;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterZLocationPlugin
 */
public class FlutterZLocationPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;

    @Nullable
    private Activity activity;
    private static final int REQ_CODE = 9527;
    private static final String[] permissions = new String[]{
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.ACCESS_COARSE_LOCATION,
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_z_location");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("getCoordinate")) {
            requestCurrentGps(call, result);
        } else if (call.method.equals("requestPermission")) {
            checkPermission(result);
        } else {
            result.notImplemented();
        }
    }


    private void checkPermission(@NonNull Result result) {

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            Map<String, String> map = new HashMap<>();
            map.put("code", "A00001");
            map.put("message", "不支持该版本, 需Android 6.0以上");
            result.success(map);
            return;
        }

        if (activity == null) {
            Map<String, String> map = new HashMap<>();
            map.put("code", "A00001");
            map.put("message", "权限请求-activity获取失败");
            result.success(map);
            return;
        }

        // 权限请求
        for (String permission : permissions) {
            int i = ContextCompat.checkSelfPermission(activity, permission);
            if (i != PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity, permissions, REQ_CODE);
                return;
            }
        }

    }


    private void requestCurrentGps(@NonNull MethodCall call, @NonNull Result result) {

        Integer accuracy = call.argument("accuracy");
        if (accuracy == null) {
            accuracy = 2;
        }

        // activity为空
        if (activity == null) {
            Map<String, String> map = new HashMap<>();
            map.put("code", "A0001");
            map.put("message", "gps请求-activity获取失败");
            result.success(map);
            return;
        }

        // 版本过低
        if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.M) {
            Map<String, String> map = new HashMap<>();
            map.put("code", "A00002");
            map.put("message", "不支持该版本,需Android 6.0以上");
            result.success(map);
            return;
        }
        LocationManager locationManager = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
        // 检查 GPS 定位是否开启
        boolean isGpsEnabled = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        // 检查网络定位是否开启
        boolean isNetworkEnabled = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        if (!isGpsEnabled && !isNetworkEnabled) {
            // 定位服务未开启
            Map<String, String> map = new HashMap<>();
            map.put("code", "A0003");
            map.put("message", "定位服务未开启");
            result.success(map);
            return;
        }

        // 权限检查
        // 精确地理位置
        int fineLocation = ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION);
        // 粗略地理位置信息
        int coarseLocation = ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION);
        if (fineLocation != PERMISSION_GRANTED && coarseLocation != PERMISSION_GRANTED) {
            // 定位服务被禁用
            Map<String, String> map = new HashMap<>();
            map.put("code", "A0004");
            map.put("message", "定位服务被禁用");
            result.success(map);
            return;
        }

        // 定位服务已开启
        GpsListener gpsListener = new GpsListener(result, locationManager);
        gpsListener.handleGps(accuracy);

    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {

    }
}
