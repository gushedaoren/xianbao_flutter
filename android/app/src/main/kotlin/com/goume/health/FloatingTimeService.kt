package com.goume.health

import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.MotionEvent
import android.view.View
import android.view.WindowManager
import android.widget.ImageButton
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

    private var initialX: Int = 0
    private var initialY: Int = 0
    private var initialTouchX: Float = 0f
    private var initialTouchY: Float = 0f

    private var closeButton:ImageButton?=null

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
        closeButton = overlayView?.findViewById<ImageButton>(R.id.closeButton)
        closeButton?.setOnClickListener {
            stopSelf()
        }

        handler = Handler()
        handler?.post(updateTimeRunnable)

        overlayView?.setOnTouchListener { view, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = layoutParams?.x ?: 0
                    initialY = layoutParams?.y ?: 0
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                }
                MotionEvent.ACTION_MOVE -> {
                    val offsetX = event.rawX - initialTouchX
                    val offsetY = event.rawY - initialTouchY

                    layoutParams?.x = (initialX + offsetX).toInt()
                    layoutParams?.y = (initialY + offsetY).toInt()

                    windowManager?.updateViewLayout(overlayView, layoutParams)
                }
                MotionEvent.ACTION_UP -> {
                    val offsetX = event.rawX - initialTouchX
                    val offsetY = event.rawY - initialTouchY
                    val clickThreshold = 10

                    if (Math.abs(offsetX) < clickThreshold && Math.abs(offsetY) < clickThreshold) {
//                        stopSelf()
                    }
                }
            }
            true
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (overlayView != null) {
            windowManager?.removeView(overlayView)
        }
        closeButton?.setOnClickListener(null)
        handler?.removeCallbacks(updateTimeRunnable)
    }

    private val updateTimeRunnable: Runnable = object : Runnable {
        override fun run() {
            val currentTime = SimpleDateFormat("HH:mm:ss.SSS", Locale.getDefault()).format(Date())
            timeTextView?.text = currentTime
            Log.d("FloatingTimeService", "Current Time: $currentTime")
            handler?.postDelayed(this, 1)
        }
    }
}
