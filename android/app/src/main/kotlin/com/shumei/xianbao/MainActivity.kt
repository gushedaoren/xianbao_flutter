package com.shumei.xianbao


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
    private val CHANNEL = "wifi_proxy_channel"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setWifiProxy" -> {
                    val proxyAddress = call.argument<String>("proxyAddress")
                    val proxyPort = call.argument<String>("proxyPort")
                    // 调用原生方法设置WiFi代理地址
                    setWifiProxy(proxyAddress, proxyPort)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }


    // 启动VPN服务
    private fun startVpnService() {

        val serviceIntent = Intent(this, MyVpnService::class.java)
        startService(serviceIntent)

    }
    private fun setWifiProxy(proxyAddress: String?, proxyPort: String?) {
        Log.d("MainActivity", "start setWifiProxy")
        startVpnService()

    }

}
