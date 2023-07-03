package com.goume.health


import android.app.Activity.RESULT_OK
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.VpnService
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val methodChannel = "floating_time_service"
    private  fun startClock(){
        // 启动悬浮窗口服务
        val serviceIntent = Intent(this, FloatingTimeService::class.java)
        startService(serviceIntent)
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannel).setMethodCallHandler { call, result ->
            if (call.method == "start_service") {
                print("configureFlutterEngine start")
                startClock()
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }



}
