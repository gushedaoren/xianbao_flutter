package com.goume.health

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class FloatingTimeService : Service() {

    private var overlayView: View? = null
    private var windowManager: WindowManager? = null
    private var layoutParams: WindowManager.LayoutParams? = null
    private var timeTextView: TextView? = null
    private var handler: Handler? = null

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate() {
        super.onCreate()
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null)

        layoutParams = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        } else {
            WindowManager.LayoutParams(
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT
            )
        }

        layoutParams?.gravity = Gravity.TOP or Gravity.START
        layoutParams?.x = 0
        layoutParams?.y = 100

        windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        windowManager?.addView(overlayView, layoutParams)

        timeTextView = overlayView?.findViewById(R.id.timeTextView)

        handler = Handler()
        handler?.post(updateTimeRunnable)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (overlayView != null) {
            windowManager?.removeView(overlayView)
        }
        handler?.removeCallbacks(updateTimeRunnable)
    }

    private val updateTimeRunnable: Runnable = object : Runnable {
        override fun run() {
            val currentTime = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date())
            timeTextView?.text = currentTime
            handler?.postDelayed(this, 1) // 每毫秒更新一次时间
        }
    }

}
