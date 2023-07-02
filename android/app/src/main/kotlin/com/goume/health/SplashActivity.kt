package com.goume.health

import android.os.Bundle
import android.app.Activity
import com.qq.e.ads.splash.SplashAD
import com.qq.e.ads.splash.SplashADListener
import android.content.Intent
import android.util.Log
import com.qq.e.comm.managers.GDTAdSdk
import android.widget.FrameLayout
import com.qq.e.comm.util.AdError

class SplashActivity : Activity() {
    private lateinit var splashAD: SplashAD
    private val appId = "1203397873"
    private val adId = "2046404519187902" // 替换为你的启动页广告位 ID

    private fun showStartupAd() {
        GDTAdSdk.init(this, appId)
        val adContainer = findViewById<FrameLayout>(R.id.adContainer)
        // 创建启动页广告对象
        val ad = SplashAD(this, adId, object : SplashADListener {
            override fun onADPresent() {
                // 广告展示回调
            }

            override fun onADClicked() {
                // 广告点击回调
            }
            override fun onADTick(p0: Long) {

            }
            override fun onADLoaded(p0: Long) {

            }
            override fun onADExposure() {

            }
            override fun onADDismissed() {
                // 广告关闭回调
                startMainActivity() // 启动应用主界面
            }

            override fun onNoAD(error: AdError) {
                // 广告加载失败回调
//                Log.e("SplashActivity",error)
                startMainActivity() // 直接启动应用主界面
            }
        })

        // 加载启动页广告
        ad.fetchAndShowIn(adContainer)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        showStartupAd()
    }

    private fun startMainActivity() {
//        val intent = Intent(this, MainActivity::class.java)
//        startActivity(intent)
//        finish()

        // 启动悬浮窗口服务
        val serviceIntent = Intent(this, FloatingTimeService::class.java)
        startService(serviceIntent)
        finish()
    }
}
