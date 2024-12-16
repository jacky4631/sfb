package com.example.flutter_z_location;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class GpsListener implements LocationListener {

    private MethodChannel.Result result;
    private final LocationManager locationManager;

    GpsListener(MethodChannel.Result result, LocationManager locationManager) {
        this.result = result;
        this.locationManager = locationManager;
    }

    void handleGps(int accuracy) {
        Criteria criteria = new Criteria();
        if (accuracy == 1) {
            criteria.setAccuracy(Criteria.ACCURACY_FINE);
        } else {
            criteria.setAccuracy(Criteria.ACCURACY_COARSE);
        }
        criteria.setAltitudeRequired(false);
        criteria.setBearingRequired(false);
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        criteria.setCostAllowed(true);
        locationManager.requestSingleUpdate(criteria, this, Looper.getMainLooper());
    }

    @Override
    public void onLocationChanged(@NonNull Location location) {
        locationManager.removeUpdates(this);
        Map<String, String> map = new HashMap<>();
        map.put("latitude", String.valueOf(location.getLatitude()));
        map.put("longitude", String.valueOf(location.getLongitude()));
        map.put("code", "00000");
        map.put("message", "获取成功");
        result.success(map);
    }

    @Override
    public void onLocationChanged(@NonNull List<Location> locations) {
        LocationListener.super.onLocationChanged(locations);
    }

    @Override
    public void onFlushComplete(int requestCode) {
        LocationListener.super.onFlushComplete(requestCode);
    }

    @Override
    public void onProviderEnabled(@NonNull String provider) {
        LocationListener.super.onProviderEnabled(provider);
    }

    @Override
    public void onProviderDisabled(@NonNull String provider) {
        //LocationListener.super.onProviderDisabled(provider);
        Map<String, String> map = new HashMap<>();
        map.put("code", "A0005");
        map.put("message", "位置服务提供者被禁用");
        result.success(map);
    }
}
